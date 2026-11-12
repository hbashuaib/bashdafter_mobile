import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

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
  bool isRecording = false;
  bool isLoadingCustomers = true;
  String? audioPath;
  String? fileName;
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

      setState(() {
        isRecording = true;
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

    setState(() {
      audioPath = path;
      fileName = name;
      recordingDuration = duration;
      isRecording = false;
    });
  }

  Future<void> playRecording() async {
    if (audioPath == null) return;
    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(audioPath!));
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
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Recording')),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

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
          ],
        ),
      ),
    );
  }
}
