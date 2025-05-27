import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/session/widgets/participant_chip.dart';

import '../../../data/models/session_participant.dart';
import '../controllers/chat_controller.dart';
import 'chat_bottom_sheet.dart';

class ChatAndParticipantsBar extends StatelessWidget {
  final List<SessionParticipant> participants;

  const ChatAndParticipantsBar({
    super.key,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // 채팅 버튼 + 뱃지
          Obx(() {
            final chatController = Get.find<ChatController>();
            final count = chatController.unreadCount.value;

            return Badge(
              label: Text('$count'),
              isLabelVisible: count > 0,
              child: IconButton(
                icon: Image.asset(
                  'assets/images/ic_chat.png',
                  width: 32,
                  height: 32,
                ),
                tooltip: 'open_chat'.tr,
                onPressed: () {
                  chatController.markAllAsRead();
                  Get.bottomSheet(const ChatBottomSheet());
                },
              ),
            );
          }),

          const SizedBox(width: 8),

          // 참가자 리스트
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: participants
                    .map((p) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ParticipantChip(participant: p, size: 20),
                ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
