import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message.dart';
import '../providers/color_providers.dart';
// import '../utils/commons/chat_handler.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  final List<Message> _messages = []; // Updated to hold Message objects

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _loadInitialMessages(); // Load initial messages from Firestore
  }

  Future<void> _loadInitialMessages() async {
    // Listen for real-time updates from Firestore
    FirebaseFirestore.instance
        .collection('chats')
        .doc(_user.uid)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _messages.clear();
        for (var doc in snapshot.docs) {
          final messageData = doc.data();
          _messages.add(Message(
            text: messageData['text'],
            sender: messageData['sender'] == _user.uid
                ? MessageSender.user
                : MessageSender.ai,
          ));
        }
      });
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Clear the input field immediately
    _controller.clear();

    // Add user message to the local list
    setState(() {
      _messages.add(Message(text: text, sender: MessageSender.user));
    });

    // Save user message to Firestore
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_user.uid)
        .collection('messages')
        .add({
      'text': text,
      'sender': _user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Mock an AI response
    _mockAiResponse();
  }

  void _mockAiResponse() async {
    // Mock delay for AI response
    await Future.delayed(const Duration(seconds: 1));

    // Mock AI response
    const aiResponse = 'This is a mock AI response.';

    // Add AI response to the local list
    setState(() {
      _messages.add(Message(text: aiResponse, sender: MessageSender.ai));
    });

    // Save AI response to Firestore
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_user.uid)
        .collection('messages')
        .add({
      'text': aiResponse,
      'sender': 'ai',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorState = ref.watch(colorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.sender == MessageSender.user;
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? colorState.baseColor
                          : colorState.generatedColors[1],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                          color: isUserMessage
                              ? colorState.generatedColors[1]
                              : colorState.generatedColors[0]),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        prefixIcon: Icon(
                          Icons.emoji_emotions,
                          color: colorState.generatedColors[1],
                        ),
                        hintText: 'Message',
                        hintStyle:
                            TextStyle(color: colorState.generatedColors[1]),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: colorState.generatedColors[1],
                  radius: 25,
                  child: IconButton(
                    color: colorState.baseColor,
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage, // Call send message method
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
