import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speak(String text, {bool english = false}) async {
    await _tts.stop();
    await _tts.setLanguage(english ? 'en-IN' : 'mr-IN');
    await _tts.setSpeechRate(0.45);
    await _tts.speak(text);
  }

  static Future<void> stop() => _tts.stop();
}
