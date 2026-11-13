import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as speech;

import 'dart:io';

import '../../customers/services/customer_service.dart';

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
  String? audioPath;
  String? fileName;
  String recognizedText = '';
  DateTime? recordingStartedAt;
  Duration? recordingDuration;
  List<dynamic> customers = [];
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

  @override
  void initState() {
    super.initState();
    loadCustomers();
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
