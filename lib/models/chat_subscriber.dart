import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nightview/models/chat_message_data.dart';

class ChatSubscriber extends ChangeNotifier {
  Map<String, ChatMessageData> _messages = {};

  Map<String, ChatMessageData> get messages => _messages;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> subscribeToChat(String chatId) {
    final firestore = FirebaseFirestore.instance;

    _messages.clear();

    return firestore.collection('chats').doc(chatId).collection('messages').orderBy('timestamp').snapshots().listen((snapshot) {
      for (DocumentChange<Map<String, dynamic>> docChange in snapshot.docChanges) {
        switch (docChange.type) {
          case DocumentChangeType.added:
            _messages[docChange.doc.id] = ChatMessageData(
              message: docChange.doc.get('message'),
              sender: docChange.doc.get('sender'),
              timestamp: docChange.doc.get('timestamp').toDate(),
            );
            break;
          case DocumentChangeType.modified:
            _messages[docChange.doc.id] = ChatMessageData(
              message: docChange.doc.get('message'),
              sender: docChange.doc.get('sender'),
              timestamp: docChange.doc.get('timestamp').toDate(),
            );
            break;
          case DocumentChangeType.removed:
            _messages.remove(docChange.doc.id);
            break;
        }
      }
      notifyListeners();
    });
  }

}
