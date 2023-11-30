import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p_student/models/message.dart';
import 'dart:convert';

import 'package:p_student/models/student_info.dart';

class ChatViewModel extends ChangeNotifier {
  List<String> uids = [];

  bool reloadChatMessage = true;

  List<StudentInfo> students = [];
  bool loadingUid = true;

  String uid = "";
  Map<String, dynamic> chatData = {};
  List<Message> messages = [];

  Future<void> getStreamContact() async {
    while (true) {
      await getChatContact();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> getStreamChatMassage() async {
    while (reloadChatMessage) {
      await getChatMessage();
      // await Future.delayed(const Duration(m: 2));
    }
  }

  Future<void> getChatContact() async {
    final List<String> newUid = [];
    final response = await http.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/p-care-e73a4/databases/(default)/documents/chat'));
    var jsonData = json.decode(response.body);
    if (jsonData['documents'] != null) {
      for (final document in jsonData['documents']) {
        final name = document['name'];
        final uid = name.split('/').last;
        newUid.add(uid);
      }
      if (newUid.length != uids.length) {
        uids = newUid;
        final studentResponse = await http.get(Uri.parse(
            'https://firestore.googleapis.com/v1/projects/p-care-e73a4/databases/(default)/documents/student_info'));
        var studentJson = json.decode(studentResponse.body);
        for (final document in studentJson['documents']) {
          final name = document['name'];
          final uid = name.split('/').last;

          if (uids.contains(uid)) {
            final fields = document['fields'];
            final student = StudentInfo.fromMap(fields);
            student.uid = uid;
            students.add(student);
          }
        }
      } else {
        // return;
      }
    }
    loadingUid = true;
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    try {
      // Thêm tin nhắn mới
      Map<String, dynamic> newData =
          createNewMessage('server', message);
      chatData['fields']?.addAll(newData);
      log(jsonEncode(chatData));
      // Patch lại API
      await patchChatData(uid, chatData['fields']);
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> getChatMessage() async {
    List<Message> newMessages = [];
    final response = await http.get(Uri.parse(
        'https://firestore.googleapis.com/v1/projects/p-care-e73a4/databases/(default)/documents/chat/$uid'));
    if (response.statusCode == 200) {
      chatData = json.decode(response.body);
      if (chatData.containsKey('fields')) {
        final Map<String, dynamic> fields = chatData['fields'];
        fields.forEach(
          (key, value) {
            final Map<String, dynamic> mapValue = value['mapValue']['fields'];
             Message message = Message.fromJson(mapValue);
            message.createTime = int.parse(key);
            newMessages.add(message);
            
          },
        );
        if(newMessages.length!=messages.length){
          messages=newMessages;
          messages.sort((a, b) => (a.createTime ?? 0).compareTo(b.createTime ?? 0));
        }
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
    reloadChatMessage = false;
    notifyListeners();
    uid = studentId;
    log(uid);
    messages = [];
    reloadChatMessage = true;
    notifyListeners();
  }
}
