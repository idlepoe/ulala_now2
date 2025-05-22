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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final chatController = Get.find<ChatController>();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final nickname =
        Get.find<SessionController>().session.value?.participants
            .firstWhereOrNull((p) => p.uid == userId)
            ?.nickname ??
        '알 수 없음';
    final sessionId = Get.find<SessionController>().sessionId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.focusNode.requestFocus();
    });

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, // ✅ 테마 기반 배경색
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              '채팅',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
                  if (messages.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '🪐 아직 아무도 말을 걸지 않았어요!\n\n첫 번째 메시지를 남겨보세요 🌟',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.6),
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final msg = messages[messages.length - 1 - index];
                      final isMine = msg.senderId == userId;

                      final bubbleColor =
                          isMine
                              ? (isDark ? Colors.blue[300] : Colors.blue[100])
                              : (isDark ? Colors.grey[700] : Colors.grey[200]);

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
                            color: bubbleColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMine)
                                Text(
                                  msg.senderName,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                msg.message,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat.Hm().format(msg.createdAt),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.textTheme.labelSmall?.color
                                      ?.withOpacity(0.6),
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
                    focusNode: chatController.focusNode,
                    decoration: const InputDecoration(
                      hintText: "메시지를 입력하세요...",
                    ),
                    onSubmitted: (value) async {
                      await chatController.sendMessage(sessionId, nickname);
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
