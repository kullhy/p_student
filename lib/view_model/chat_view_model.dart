import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p_student/models/message.dart';
import 'dart:convert';

import 'package:p_student/models/student_info.dart';

class ChatViewModel extends ChangeNotifier {
  final List<String> uids = [];

  List<StudentInfo> students = [];
  bool loadingUid = true;
  String uid ="";
  Map<String, dynamic> chatData = {};
  List<Message> messages = [];

  Future<void> getChatUid() async {
  final List<String> newUid = [];

    final response = await http.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/p-care-e73a4/databases/(default)/documents/chat'));
    var jsonData = json.decode(response.body);
    if (jsonData['documents'] != null) {
      for (final document in jsonData['documents']) {
        final name = document['name'];
        final uid = name.split('/').last;
        newUid.add(uid);
        if(newUid.length!=uids.length){
          uids = newUid;
        }
      }
    }
    final studentResponse = await http.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/p-care-e73a4/databases/(default)/documents/student_info'));
    var studentJson = json.decode(studentResponse.body);
    for (final document in studentJson['documents']) {
      final name = document['name'];
      final uid = name.split('/').last;

      if (uids.contains(uid)) {
        final fields = document['fields'];
        final student = StudentInfo.fromMap(fields);
        student.uid=uid;
        students.add(student);
      }
    }
    loadingUid = true;
    notifyListeners();
  }
  

  Future<void> check() async {
    try {
      final uid = '4cEdHvXK0tUE9TfxzTq5mquiS7F2';

      // Thêm tin nhắn mới
      Map<String, dynamic> newData =
          createNewMessage('server', 'Hello from server');
      chatData['fields']?.addAll(newData);
      log(jsonEncode(chatData));
      // Patch lại API
      await patchChatData(uid, chatData['fields']);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getChatData() async {
    final response = await http.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/p-care-e73a4/databases/(default)/documents/chat/$uid'));
    if (response.statusCode == 200) {
      chatData = json.decode(response.body);
      if (chatData.containsKey('fields')) {
        final Map<String, dynamic> fields = chatData['fields'];
        fields.forEach((key, value) {
          final Map<String, dynamic> mapValue = value['mapValue']['fields'];
          final Message message = Message.fromJson(mapValue);
          messages.add(message);
        });
      }
    } else {
      throw Exception('Failed to load chat data');
    }
  }

  Map<String, dynamic> createNewMessage(String sender, String content) {
    return {
      DateTime.now().millisecondsSinceEpoch.toString(): {
        'mapValue': {
          'fields': {
            'sender': {'stringValue': sender},
            'content': {'stringValue': content},
          }
        }
      }
    };
  }

  Future<void> patchChatData(String uid, Map<String, dynamic> newData) async {
    final response = await http.patch(
        Uri.parse(
            'https://firestore.googleapis.com/v1/projects/p-care-e73a4/databases/(default)/documents/chat/$uid'),
        body: json.encode({'fields': newData}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Failed to patch chat data');
    }
  }

  void setChatUID(String studentId) {
    
    uid = studentId;
    log(uid);
    notifyListeners();
  }
}
