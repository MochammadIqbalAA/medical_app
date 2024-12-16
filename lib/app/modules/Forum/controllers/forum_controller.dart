import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class ForumController {
  final TextEditingController messageController = TextEditingController();
  final List<Map<String, String>> messages = [];
  late stt.SpeechToText _speech;
  bool isListening = false;
  String speechText = "";

  ForumController() {
    _speech = stt.SpeechToText();
  }

  Future<bool> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }


  Future<void> startListening(Function onUpdate) async {
    bool isGranted = await checkMicrophonePermission();
    if (!isGranted) {
      print("Microphone permission denied.");
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (available) {
      isListening = true;
      var locales = await _speech.locales();
      print('Available locales: $locales'); 

      _speech.listen(
        onResult: (result) {
          speechText = result.recognizedWords; // update text
          messageController.text = speechText; // textfiels
          onUpdate();
        },
        localeId: 'id_ID',
      );
    } else {
      print("Speech recognition not available.");
    }
  }

  /// Menghentikan pendengaran suara
  void stopListening(Function onUpdate) {
    isListening = false;
    _speech.stop();
    onUpdate(); // Memperbarui state di view
  }

  /// Mengirim pesan ke daftar lokal
  void sendMessage(Function onUpdate) {
    String content = messageController.text;
    if (content.isNotEmpty) {
      messages.add({
        'content': content,
        'timestamp': DateTime.now().toLocal().toString(),
      });
      messageController.clear();
      onUpdate(); // Memperbarui state di view
    }
  }
}
