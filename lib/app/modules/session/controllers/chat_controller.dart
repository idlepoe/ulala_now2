import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../data/models/chat_message.dart';

class ChatController extends GetxController {
  final inputController = TextEditingController();

  Stream<List<ChatMessage>> getChatStream(String sessionId) {
    return FirebaseFirestore.instance
        .collection('sessions/$sessionId/chats')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatMessage.fromJson(doc.data()))
        .toList());
  }

  Future<void> sendMessage(String sessionId, String senderName) async {
    final content = inputController.text.trim();
    if (content.isEmpty) return;

    inputController.clear();

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final message = {
      'senderId': uid,
      'senderName': senderName,
      'message': content,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('sessions/$sessionId/chats')
        .add(message);
  }


  final RxInt unreadCount = 0.obs;
  DateTime lastOpened = DateTime.now();

  void handleNewMessage(ChatMessage msg) {
    if (msg.createdAt.isAfter(lastOpened)) {
      unreadCount.value++;
    }
  }

  void markAllAsRead() {
    lastOpened = DateTime.now();
    unreadCount.value = 0;
  }

  void startListening(String sessionId) {
    FirebaseFirestore.instance
        .collection('sessions/$sessionId/chats')
        .orderBy('createdAt')
        .snapshots()
        .listen((snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final msg = ChatMessage.fromJson(change.doc.data()!);
          handleNewMessage(msg);
        }
      }
    });
  }
}
