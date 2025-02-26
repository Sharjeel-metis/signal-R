import 'package:flutter/material.dart';
import 'package:signal_r/signal_r_service.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SignalRService _signalRService = SignalRService();
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    _initializeSignalR();
  }

  void _initializeSignalR() async {
    await _signalRService.connect();


    _signalRService.listenForMessages((user, message) {
      setState(() {
        messages.add("$user: $message");
      });
    });
  }

  void _sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      await _signalRService.sendMessage("User1", text);
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _signalRService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Room")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(messages[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Enter message..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
