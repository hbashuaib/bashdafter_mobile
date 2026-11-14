import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as speech;

import 'dart:io';

import '../../customers/services/customer_service.dart';
import '../../products/services/product_service.dart';
import '../../purchases/services/create_purchase_service.dart';
import '../../purchases/services/create_purchase_item_service.dart';
import '../models/voice_purchase_item.dart';

class VoiceRecorderScreen extends StatefulWidget {
  const VoiceRecorderScreen({super.key});

  @override
  State<VoiceRecorderScreen> createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends State<VoiceRecorderScreen> {
  final _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final speech.SpeechToText _speech = speech.SpeechToText();
  bool isRecording = false;
  bool isLoadingCustomers = true;
  bool speechEnabled = false;
  bool isListening = false;
  bool isSavingPurchase = false;
  String? audioPath;
  String? fileName;
  String recognizedText = '';
  DateTime? recordingStartedAt;
  Duration? recordingDuration;
  List<dynamic> customers = [];
  List<dynamic> products = [];
  List<VoicePurchaseItem> parsedItems = [];
  Map<String, dynamic>? selectedCustomer;

  Future<void> loadCustomers() async {
    try {
      final result = await CustomerService().getCustomers();

      if (!mounted) return;

      setState(() {
        customers = result;
        isLoadingCustomers = false;
      });
    } catch (e) {
      debugPrint('Load Customers Error: $e');

      if (!mounted) return;

      setState(() {
        isLoadingCustomers = false;
      });
    }
  }

  Future<void> loadProducts() async {
    try {
      final result = await ProductService().getProducts();

      if (!mounted) return;

      setState(() {
        products = result;
      });
    } catch (e) {
      debugPrint('Load Products Error: $e');
    }
  }

  Future<void> startRecording() async {
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer first')),
      );

      return;
    }

    setState(() {
      audioPath = null;
      fileName = null;
      recordingDuration = null;
      recognizedText = '';
    });

    if (await _audioRecorder.hasPermission()) {
      final baseDir = await getApplicationDocumentsDirectory();
      final customerId = selectedCustomer!['id'];
      final customerName = sanitizeFolderName(selectedCustomer!['name']);

      final customerFolder = Directory(
        '${baseDir.path}/voices/customer_${customerId}_$customerName',
      );

      await customerFolder.create(recursive: true);

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final path =
          '${customerFolder.path}/${customerId}_${customerName}_$timestamp.m4a';

      await _audioRecorder.start(const RecordConfig(), path: path);

      if (speechEnabled) {
        setState(() {
          recognizedText = '';
          isListening = true;
        });

        await _speech.listen(
          onResult: (result) {
            if (!mounted) return;

            setState(() {
              recognizedText = result.recognizedWords;

              if (result.finalResult) {
                isListening = false;
              }
            });
          },

          listenOptions: speech.SpeechListenOptions(
            listenFor: const Duration(minutes: 2),
            pauseFor: const Duration(seconds: 15),
          ),
        );
      }

      setState(() {
        isRecording = true;
        isListening = speechEnabled;
        recordingStartedAt = DateTime.now();
      });
    }
  }

  Future<void> stopRecording() async {
    final path = await _audioRecorder.stop();
    final duration = DateTime.now().difference(recordingStartedAt!);
    final name = path?.split('/').last;

    if (!mounted) {
      return;
    }

    if (_speech.isListening) {
      await _speech.stop();
    }

    setState(() {
      audioPath = path;
      fileName = name;
      recordingDuration = duration;
      isRecording = false;
      isListening = false;
    });

    parseTranscript();
    matchProducts();
  }

  Future<void> playRecording() async {
    if (audioPath == null) return;
    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(audioPath!));
  }

  Future<void> initializeSpeech() async {
    speechEnabled = await _speech.initialize();

    debugPrint('Speech initialized: $speechEnabled');

    if (mounted) {
      setState(() {});
    }
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String sanitizeFolderName(String value) {
    return value
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  String normalizeNumbers(String text) {
    return text
        .replaceAll('one', '1')
        .replaceAll('two', '2')
        .replaceAll('three', '3')
        .replaceAll('four', '4')
        .replaceAll('five', '5')
        .replaceAll('six', '6')
        .replaceAll('seven', '7')
        .replaceAll('eight', '8')
        .replaceAll('nine', '9')
        .replaceAll('ten', '10');
  }

  String normalizeProductName(String value) {
    value = value.toLowerCase().trim();

    if (value.endsWith('s') && value.length > 2) {
      value = value.substring(0, value.length - 1);
    }

    return value;
  }

  List<dynamic> getSuggestedProducts(String productName) {
    final search = normalizeProductName(productName);

    return products
        .where((product) {
          final name = normalizeProductName(product['name'].toString());

          return name.contains(search) ||
              search.contains(name) ||
              name.startsWith(search.isNotEmpty ? search[0] : '');
        })
        .take(5)
        .toList();
  }

  void parseTranscript() {
    parsedItems.clear();
    final normalized = normalizeNumbers(recognizedText.toLowerCase());
    final words = normalized.split(' ');

    for (int i = 0; i < words.length - 1; i++) {
      final quantity = int.tryParse(words[i]);

      if (quantity != null) {
        final productName = words[i + 1];

        parsedItems.add(
          VoicePurchaseItem(quantity: quantity, productName: productName),
        );
      }
    }

    setState(() {});
  }

  void matchProducts() {
    for (final item in parsedItems) {
      final search = normalizeProductName(item.productName);

      final matches = products.where((product) {
        final productName = normalizeProductName(product['name'].toString());

        return productName.contains(search);
      }).toList();

      if (matches.isEmpty) {
        item.matchedProduct = null;
        item.candidateProducts = [];
      } else if (matches.length == 1) {
        item.matchedProduct = matches.first;
        item.candidateProducts = [];
      } else {
        item.matchedProduct = null;
        item.candidateProducts = matches;
      }
    }

    setState(() {});
  }

  void showPurchaseDraft() {
    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text('Purchase Draft'),

          content: SizedBox(
            width: double.maxFinite,

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('Customer: ${selectedCustomer?['name']}'),

                  const SizedBox(height: 16),

                  ...parsedItems
                      .where((item) => item.matchedProduct != null)
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),

                          child: Text(
                            '${item.matchedProduct!['name']} x ${item.quantity}',
                          ),
                        ),
                      ),

                  const Divider(),

                  Text(
                    'Total: YER ${voicePurchaseTotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton.icon(
              onPressed: isSavingPurchase ? null : saveVoicePurchase,

              icon: const Icon(Icons.save),

              label: Text(isSavingPurchase ? 'Saving...' : 'Confirm Purchase'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveVoicePurchase() async {
    if (selectedCustomer == null) {
      return;
    }

    final validItems = parsedItems
        .where((item) => item.matchedProduct != null)
        .toList();

    if (validItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No valid products found')));

      return;
    }

    setState(() {
      isSavingPurchase = true;
    });

    try {
      final purchaseId = await CreatePurchaseService().createPurchase(
        customerId: selectedCustomer!['id'],
        notes: 'Created from Voice Purchase',
      );

      for (final item in validItems) {
        await CreatePurchaseItemService().createItem(
          purchaseId: purchaseId,
          productId: item.matchedProduct!['id'],
          itemName: item.matchedProduct!['name'],
          quantity: item.quantity.toString(),
          unitPrice: item.matchedProduct!['selling_price'].toString(),
        );
      }

      if (!mounted) return;

      Navigator.pop(context);

      setState(() {
        recognizedText = '';
        parsedItems.clear();
        audioPath = null;
        fileName = null;
        recordingDuration = null;
        isSavingPurchase = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice Purchase Saved Successfully')),
      );
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save purchase')));
    } finally {
      if (mounted) {
        setState(() {
          isSavingPurchase = false;
        });
      }
    }
  }

  double get voicePurchaseTotal {
    double total = 0;

    for (final item in parsedItems) {
      if (item.matchedProduct != null) {
        final price =
            double.tryParse(item.matchedProduct!['selling_price'].toString()) ??
            0;

        total += price * item.quantity;
      }
    }

    return total;
  }

  double itemTotal(VoicePurchaseItem item) {
    if (item.matchedProduct == null) {
      return 0;
    }

    final price =
        double.tryParse(item.matchedProduct!['selling_price'].toString()) ?? 0;

    return price * item.quantity;
  }

  bool hasInsufficientStock(VoicePurchaseItem item) {
    if (item.matchedProduct == null) {
      return false;
    }

    final stock =
        double.tryParse(item.matchedProduct!['current_stock'].toString()) ?? 0;

    return item.quantity > stock;
  }

  bool get canCreatePurchase {
    if (voicePurchaseTotal <= 0) {
      return false;
    }

    if (parsedItems.any((item) => hasInsufficientStock(item))) {
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    loadCustomers();
    loadProducts();
    initializeSpeech();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startListening() async {
    if (!speechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition unavailable')),
      );

      return;
    }

    setState(() {
      recognizedText = '';
      isListening = true;
    });

    debugPrint('Speech listening started');

    await _speech.listen(
      onResult: (result) {
        setState(() {
          recognizedText = result.recognizedWords;

          if (result.finalResult) {
            isListening = false;
          }
        });
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();

    if (!mounted) return;

    setState(() {
      isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Recording')),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (isLoadingCustomers)
                const CircularProgressIndicator()
              else
                DropdownButtonFormField<Map<String, dynamic>>(
                  value: selectedCustomer,

                  decoration: const InputDecoration(
                    labelText: 'Customer',
                    border: OutlineInputBorder(),
                  ),

                  items: customers.map((customer) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: customer,
                      child: Text(customer['name'] ?? ''),
                    );
                  }).toList(),

                  onChanged: audioPath != null
                      ? null
                      : (value) {
                          setState(() {
                            selectedCustomer = value;
                          });
                        },
                ),

              const SizedBox(height: 20),

              Icon(
                isRecording ? Icons.mic : Icons.mic_none,
                size: 100,
                color: isRecording ? Colors.red : Colors.blue,
              ),

              const SizedBox(height: 20),

              Text(isRecording ? 'Recording...' : 'Ready'),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: Icon(isRecording ? Icons.stop : Icons.mic),
                label: Text(isRecording ? 'Stop' : 'Start Recording'),

                onPressed: () {
                  if (isRecording) {
                    stopRecording();
                  } else {
                    startRecording();
                  }
                },
              ),

              if (audioPath != null) ...[
                const SizedBox(height: 30),

                const Text(
                  'Recording Saved',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.blue),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                selectedCustomer?['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        Row(
                          children: [
                            const Icon(Icons.audio_file, color: Colors.green),

                            const SizedBox(width: 8),

                            Expanded(child: Text(fileName ?? '')),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.orange),

                            const SizedBox(width: 8),

                            Text(
                              recordingDuration != null
                                  ? formatDuration(recordingDuration!)
                                  : '--:--',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: playRecording,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play Recording'),
                ),

                const SizedBox(height: 20),

                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Recording'),

                  onPressed: () {
                    setState(() {
                      audioPath = null;
                      fileName = null;
                      recordingDuration = null;
                    });
                  },
                ),
              ],

              if (isListening)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.record_voice_over, color: Colors.red),

                      SizedBox(width: 8),

                      Text(
                        'Listening...',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              if (recognizedText.isNotEmpty) ...[
                const SizedBox(height: 20),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recognized Text',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),

                        Text(recognizedText),
                      ],
                    ),
                  ),
                ),

                if (parsedItems.isNotEmpty) ...[
                  const SizedBox(height: 20),

                  const Text(
                    'Detected Items',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 8),

                  Card(
                    child: Column(
                      children: parsedItems.map((item) {
                        return ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),

                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,

                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text('Remove Item'),

                                    content: Text(
                                      'Remove ${item.productName}?',
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },

                                        child: const Text('Cancel'),
                                      ),

                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },

                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                setState(() {
                                  parsedItems.remove(item);
                                });
                              }
                            },
                          ),
                          title: Text(
                            item.matchedProduct?['name'] ?? item.productName,
                          ),

                          subtitle: item.matchedProduct != null
                              ? Text(
                                  'Price: YER ${item.matchedProduct!['selling_price']}'
                                  '\nStock: ${item.matchedProduct!['current_stock']}'
                                  '${hasInsufficientStock(item) ? '\n⚠ Insufficient Stock' : ''}',
                                  style: TextStyle(
                                    color: hasInsufficientStock(item)
                                        ? Colors.red
                                        : null,
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      item.candidateProducts.isNotEmpty
                                          ? 'Multiple products found for "${item.productName}". Please select one:'
                                          : 'Product Not Found. Suggested products:',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Builder(
                                      builder: (_) {
                                        final suggestions =
                                            item.candidateProducts.isNotEmpty
                                            ? item.candidateProducts
                                            : getSuggestedProducts(
                                                item.productName,
                                              );

                                        if (suggestions.isEmpty) {
                                          return const SizedBox();
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          children: [
                                            const SizedBox(height: 8),

                                            ...suggestions.map((product) {
                                              return Card(
                                                margin: const EdgeInsets.only(
                                                  bottom: 4,
                                                ),

                                                child: ListTile(
                                                  dense: true,

                                                  title: Text(product['name']),

                                                  subtitle: Text(
                                                    'Stock: ${product['current_stock']}'
                                                    ' | Price: YER ${product['selling_price']}',
                                                  ),

                                                  onTap: () {
                                                    setState(() {
                                                      item.matchedProduct =
                                                          product;
                                                    });
                                                  },
                                                ),
                                              );
                                            }),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),

                          trailing: SizedBox(
                            width: 120,

                            child: Row(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),

                                  onPressed: () {
                                    if (item.quantity <= 1) return;

                                    setState(() {
                                      item.quantity--;
                                    });
                                  },
                                ),

                                Text('${item.quantity}'),

                                IconButton(
                                  icon: const Icon(Icons.add),

                                  onPressed: () {
                                    setState(() {
                                      item.quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                Card(
                  color: Colors.green.shade50,

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Purchase Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Divider(),

                        Text(
                          'Customer: ${selectedCustomer?['name'] ?? ''}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 12),

                        ...parsedItems
                            .where((item) => item.matchedProduct != null)
                            .map((item) {
                              final price =
                                  double.tryParse(
                                    item.matchedProduct!['selling_price']
                                        .toString(),
                                  ) ??
                                  0;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),

                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(item.matchedProduct!['name']),
                                    ),

                                    Text(
                                      '${item.quantity} × ${price.toStringAsFixed(0)}',
                                    ),

                                    const SizedBox(width: 12),

                                    Text(
                                      itemTotal(item).toStringAsFixed(0),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                        const Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              'YER ${voicePurchaseTotal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Create Purchase'),
                    onPressed: canCreatePurchase ? showPurchaseDraft : null,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
