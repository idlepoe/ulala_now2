import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ulala_now2/app/modules/session/controllers/chat_controller.dart';

import '../../../data/models/chat_message.dart';
import '../../session/controllers/session_controller.dart';

class TabChatView extends GetView<ChatController> {
  const TabChatView({super.key});

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
        'unknown'.tr;
    final sessionId = Get.find<SessionController>().sessionId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Column(
        children: [
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'chat_empty_alt1'.tr,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'chat_empty_alt2'.tr,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final msg = messages[messages.length - 1 - index];
                    final isMine = msg.senderId == userId;
                    final bubbleColor = isMine
                        ? (isDark ? Colors.blue[300] : Colors.blue[100])
                        : (isDark ? Colors.grey[700] : Colors.grey[200]);

                    // 날짜 구분이 필요한지 판단
                    final currentDate = DateFormat('yyyy-MM-dd').format(msg.createdAt);
                    final prevDate = index < messages.length - 1
                        ? DateFormat('yyyy-MM-dd').format(
                        messages[messages.length - index - 2].createdAt)
                        : null;

                    final needsDateSeparator = currentDate != prevDate;

                    return Column(
                      children: [
                        if (needsDateSeparator)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              DateFormat.yMMMMEEEEd('ko_KR').format(msg.createdAt), // 예: 2024년 5월 31일 금요일
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Align(
                          alignment:
                          isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                    color: theme.textTheme.labelSmall?.color?.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                  decoration: InputDecoration(hintText: 'enter_message'.tr),
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
    );
  }
}
