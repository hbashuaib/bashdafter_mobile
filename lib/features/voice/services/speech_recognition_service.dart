import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionService {
  SpeechRecognitionService._();

  static final SpeechRecognitionService instance = SpeechRecognitionService._();

  final stt.SpeechToText _speechToText = stt.SpeechToText();

  Future<bool>? _initialization;
  void Function(String status)? _statusListener;
  void Function(SpeechRecognitionError error)? _errorListener;

  bool get isListening => _speechToText.isListening;

  Future<bool> initialize({
    required void Function(String status) onStatus,
    required void Function(SpeechRecognitionError error) onError,
  }) {
    _statusListener = onStatus;
    _errorListener = onError;

    return _initialization ??= _speechToText.initialize(
      onStatus: (status) => _statusListener?.call(status),
      onError: (error) => _errorListener?.call(error),
    );
  }

  Future<List<stt.LocaleName>> locales() {
    return _speechToText.locales();
  }

  Future<void> listen({
    required String localeId,
    required void Function(SpeechRecognitionResult result) onResult,
  }) {
    return _speechToText.listen(
      onResult: onResult,
      listenOptions: stt.SpeechListenOptions(localeId: localeId),
    );
  }

  Future<void> stop() {
    return _speechToText.stop();
  }

  Future<void> cancel() {
    return _speechToText.cancel();
  }
}
