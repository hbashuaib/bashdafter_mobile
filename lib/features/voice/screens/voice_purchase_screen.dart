import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/speech_recognition_service.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/widgets/app_form_field_helper.dart';

class VoicePurchaseScreen extends StatefulWidget {
  const VoicePurchaseScreen({super.key});

  @override
  State<VoicePurchaseScreen> createState() => _VoicePurchaseScreenState();
}

class _VoicePurchaseScreenState extends State<VoicePurchaseScreen> {
  final SpeechRecognitionService _speechRecognition =
      SpeechRecognitionService.instance;
  final TextEditingController _transcriptController = TextEditingController();

  bool _speechInitializing = false;
  bool _speechAvailable = false;
  bool _isListening = false;

  String? _englishLocaleId;
  String? _speechError;
  String _textBeforeSpeechSession = '';

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();

    if (_isAndroid) {
      _speechInitializing = true;
      unawaited(_initializeSpeechRecognition());
    } else {
      _speechError = 'Voice purchase input is currently enabled on Android.';
    }
  }

  @override
  void dispose() {
    if (_speechRecognition.isListening) {
      unawaited(_speechRecognition.cancel());
    }

    _transcriptController.dispose();
    super.dispose();
  }

  Future<void> _initializeSpeechRecognition() async {
    try {
      final available = await _speechRecognition.initialize(
        onStatus: (status) {
          if (!mounted) return;

          setState(() {
            _isListening = status == 'listening';
          });
        },
        onError: (error) {
          if (!mounted) return;

          setState(() {
            _isListening = false;
            _speechError = error.errorMsg;
          });
        },
      );

      if (!mounted) return;

      if (!available) {
        setState(() {
          _speechInitializing = false;
          _speechAvailable = false;
          _speechError = context.l10n.voiceRecognitionUnavailable;
        });
        return;
      }

      final locales = await _speechRecognition.locales();
      String? englishLocaleId;

      for (final locale in locales) {
        if (locale.localeId.toLowerCase() == 'en-us') {
          englishLocaleId = locale.localeId;
          break;
        }
      }

      if (englishLocaleId == null) {
        for (final locale in locales) {
          if (locale.localeId.toLowerCase().startsWith('en')) {
            englishLocaleId = locale.localeId;
            break;
          }
        }
      }

      if (!mounted) return;

      setState(() {
        _speechInitializing = false;
        _englishLocaleId = englishLocaleId;
        _speechAvailable = englishLocaleId != null;
        _speechError = englishLocaleId == null
            ? context.l10n.voiceNoEnglishLanguageInstalled
            : null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _speechInitializing = false;
        _speechAvailable = false;
        _speechError = context.l10n.voiceStartFailed(error.toString());
      });
    }
  }

  Future<void> _startListening() async {
    final localeId = _englishLocaleId;
    if (!_speechAvailable || localeId == null) return;

    _textBeforeSpeechSession = _transcriptController.text.trim();

    setState(() {
      _speechError = null;
      _isListening = true;
    });

    try {
      await _speechRecognition.listen(
        localeId: localeId,
        onResult: (result) {
          if (!mounted) return;

          final recognizedWords = result.recognizedWords.trim();
          final transcript = [
            _textBeforeSpeechSession,
            recognizedWords,
          ].where((part) => part.isNotEmpty).join(' ');

          setState(() {
            _transcriptController.value = TextEditingValue(
              text: transcript,
              selection: TextSelection.collapsed(offset: transcript.length),
            );

            if (result.finalResult) {
              _isListening = false;
            }
          });
        },
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isListening = false;
        _speechError = context.l10n.voiceListeningFailed(error.toString());
      });
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speechRecognition.stop();
    } catch (error) {
      if (mounted) {
        setState(() {
          _speechError = context.l10n.voiceStopFailed(error.toString());
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  void _clearTranscript() {
    _transcriptController.clear();
    setState(() {
      _speechError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusMessage = !_isAndroid
        ? context.l10n.voicePurchaseAndroidOnly
        : _speechInitializing
        ? context.l10n.voicePreparingSpeechRecognition
        : _isListening
        ? context.l10n.voiceListeningInstructions
        : _speechAvailable
        ? context.l10n.voiceSpeakInEnglish(_englishLocaleId ?? '')
        : context.l10n.voiceRecognitionNotReady;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.voicePurchase)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.voicePurchaseInstructions),
              const SizedBox(height: 12),
              Text(statusMessage),
              if (_speechError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _speechError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _speechInitializing ||
                              (!_speechAvailable && !_isListening)
                          ? null
                          : _isListening
                          ? _stopListening
                          : _startListening,
                      icon: Icon(_isListening ? Icons.stop : Icons.mic),
                      label: Text(
                        _speechInitializing
                            ? context.l10n.voicePreparing
                            : _isListening
                            ? context.l10n.voiceStopListening
                            : context.l10n.voiceStartSpeaking,
                      ),
                    ),
                  ),
                  if (_transcriptController.text.isNotEmpty)
                    IconButton(
                      onPressed: _isListening ? null : _clearTranscript,
                      tooltip: context.l10n.voiceClearTranscript,
                      icon: const Icon(Icons.clear),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _transcriptController,
                  textDirection: TextDirection.ltr,
                  onChanged: (_) {
                    setState(() {});
                  },

                  readOnly: _isListening,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: AppFormFieldHelper.decoration(
                    context: context,
                    label: context.l10n.voiceTranscript,
                    hintText: context.l10n.voiceTranscriptHint,
                  ).copyWith(alignLabelWithHint: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
