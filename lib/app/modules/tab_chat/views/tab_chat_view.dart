import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ulala_now2/app/modules/session/controllers/chat_controller.dart';

import '../../../data/constants/app_colors.dart';
import '../../../data/models/chat_message.dart';
import '../../session/controllers/session_controller.dart';
import '../widgets/ChatInputBar.dart';
import '../widgets/ChatMessageListView.dart';

class TabChatView extends StatefulWidget {
  const TabChatView({super.key});

  @override
  State<TabChatView> createState() => _TabChatViewState();
}

class _TabChatViewState extends State<TabChatView> {
  bool isInputVisible = false;

  void toggleInput() {
    setState(() => isInputVisible = !isInputVisible);
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    final sessionController = Get.find<SessionController>();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final sessionId = sessionController.sessionId;
    final nickname =
        sessionController.session.value?.participants
            .firstWhereOrNull((p) => p.uid == userId)
            ?.nickname ??
        'unknown'.tr;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: AppColors.vividLavender,
        onPressed: toggleInput,
        child: Icon(isInputVisible ? Icons.close : Icons.chat),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<ChatMessage>>(
                  stream: chatController.getChatStream(sessionId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final messages = snapshot.data!;
                    if (messages.isEmpty) {
                      return const Center(child: Text("아직 메시지가 없습니다."));
                    }

                    return ChatMessageListView(
                      messages: messages,
                      userId: userId,
                    );
                  },
                ),
              ),

              // 🔽 입력창 (FAB와 겹치지 않도록 하단 마진)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    isInputVisible
                        ? Padding(
                          key: const ValueKey(true),
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 70,
                            top: 8,
                            bottom: 8, // ✅ FAB 공간 확보
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ChatInputBar(
                              controller: chatController.inputController,
                              onSend: () {
                                chatController.sendMessage(sessionId, nickname);
                                toggleInput(); // 전송 후 자동 닫기
                              },
                            ),
                          ),
                        )
                        : const SizedBox.shrink(key: ValueKey(false)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
