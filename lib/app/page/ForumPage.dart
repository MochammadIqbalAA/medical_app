import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = []; // List lokal untuk menyimpan pesan
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _speechText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  /// Memeriksa dan meminta izin mikrofon sebelum menggunakan speech-to-text
  Future<bool> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  /// Memulai pendengaran suara
  Future<void> _startListening() async {
    bool isGranted = await _checkMicrophonePermission();
    if (!isGranted) {
      print("Microphone permission denied.");
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (available) {
      setState(() => _isListening = true);

      // Mendapatkan locale yang tersedia
      var locales = await _speech.locales();
      print('Available locales: $locales');  // Debugging log

      // Mendengarkan dengan Bahasa Indonesia
      _speech.listen(
        onResult: (result) {
          setState(() {
            _speechText = result.recognizedWords; // Mengupdate teks yang terdeteksi
            _messageController.text = _speechText; // Memasukkan teks ke TextField
          });
        },
        localeId: 'id_ID', // Bahasa Indonesia
      );
    } else {
      print("Speech recognition not available.");
    }
  }

  /// Menghentikan pendengaran suara
  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  /// Mengirim pesan ke daftar lokal
  void _sendMessage(String content) {
    if (content.isNotEmpty) {
      setState(() {
        _messages.add({
          'content': content,
          'timestamp': DateTime.now().toLocal().toString(),
        });
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Forum'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Daftar pesan
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('No messages yet.'))
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        title: Text(
                          message['content'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          message['timestamp'] ?? '',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
          // Input pesan
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? _stopListening : _startListening,
                  color: _isListening ? Colors.red : Colors.blue,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
