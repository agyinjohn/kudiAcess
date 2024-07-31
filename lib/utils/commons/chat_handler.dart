import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getChatHistory(String userId) async {
  List<Map<String, dynamic>> chatHistory = [];

  try {
    final chatDocs = await FirebaseFirestore.instance
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp')
        .get();

    chatHistory = chatDocs.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    print('Error getting chat history: $e');
  }

  return chatHistory;
}

Future<void> saveMessage(String userId, Map<String, dynamic> message) async {
  try {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .add(message);
  } catch (e) {
    print('Error saving message: $e');
  }
}

Future<String> getPostResultFromApi({
  required String userId,
  required String message,
}) async {
  var url = 'https://chatgpt-api8.p.rapidapi.com/';
  var headers = {
    'content-type': 'application/json',
    'X-RapidAPI-Key': '1b7ce6c3b7mshc55c336c0b688b2p198075jsnefa532851b2a',
    'X-RapidAPI-Host': 'chatgpt-api8.p.rapidapi.com',
  };

  List<Map<String, dynamic>> chatHistory = await getChatHistory(userId);
  chatHistory.add({'content': message, 'role': 'user'});

  String responseText = '';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(chatHistory),
    );

    Map<String, dynamic> jsonResponse =
        json.decode(utf8.decode(response.bodyBytes));
    if (jsonResponse['error'] != null) {
      throw HttpException(jsonResponse['error']["message"]);
    }
    if (jsonResponse.isNotEmpty) {
      responseText = jsonResponse['text'];

      await saveMessage(userId, {
        'content': responseText,
        'role': 'ai',
        'timestamp': FieldValue.serverTimestamp()
      });
    }
  } catch (e) {
    print(e);
  }

  await saveMessage(userId, {
    'content': message,
    'role': 'user',
    'timestamp': FieldValue.serverTimestamp()
  });

  return responseText;
}
