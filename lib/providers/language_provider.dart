import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = "English";
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  String get selectedLanguage => _selectedLanguage;
  stt.SpeechToText get speech => _speech;
  bool get isListening => _isListening;

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  Future<void> startListening(Function(String) onResult) async {
    bool available = await _speech.initialize();
    if (available) {
      _isListening = true;
      notifyListeners();
      _speech.listen(onResult: (val) {
        onResult(val.recognizedWords);
      });
    }
  }

  void stopListening() {
    _speech.stop();
    _isListening = false;
    notifyListeners();
  }
}
