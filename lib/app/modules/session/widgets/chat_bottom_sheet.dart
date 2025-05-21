import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../../../data/models/chat_message.dart';
import '../controllers/chat_controller.dart';
import '../controllers/session_controller.dart';

class ChatBottomSheet extends StatelessWidget {
  const ChatBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final nickname =
        Get.find<SessionController>().session.value?.participants
            .firstWhereOrNull((p) => p.uid == userId)
            ?.nickname ??
        '알 수 없음';

    final sessionId = Get.find<SessionController>().sessionId;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text(
              '채팅',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 🔻 메시지 리스트
            Expanded(
              child: StreamBuilder<List<ChatMessage>>(
                stream: chatController.getChatStream(sessionId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final msg = messages[messages.length - 1 - index];
                      final isMine = msg.senderId == userId;
                      return Align(
                        alignment:
                            isMine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isMine ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMine)
                                Text(
                                  msg.senderName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              Text(msg.message),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat.Hm().format(msg.createdAt),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const Divider(),

            // 🔻 입력창
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController.inputController,
                    decoration: const InputDecoration(
                      hintText: "메시지를 입력하세요...",
                    ),
                    onSubmitted: (value) {
                      chatController.sendMessage(sessionId, nickname);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    chatController.sendMessage(sessionId, nickname);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
