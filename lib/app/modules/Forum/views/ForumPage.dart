import 'package:flutter/material.dart';
import '../controllers/forum_controller.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late ForumController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ForumController();
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
            child: _controller.messages.isEmpty
                ? const Center(child: Text('No messages yet.'))
                : ListView.builder(
                    itemCount: _controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = _controller.messages[index];
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
                  icon: Icon(_controller.isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _controller.isListening
                      ? () => setState(() => _controller.stopListening(() => setState(() {})))
                      : () => _controller.startListening(() => setState(() {})),
                  color: _controller.isListening ? Colors.red : Colors.blue,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller.messageController,
                    decoration: const InputDecoration(
                      labelText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _controller.sendMessage(() => setState(() {}));
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
