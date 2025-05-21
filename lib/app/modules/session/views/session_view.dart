import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:ulala_now2/app/modules/session/controllers/chat_controller.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../widgets/chat_bottom_sheet.dart';
import '../widgets/participant_chip.dart';
import 'session_player_view.dart';

class SessionView extends GetView<SessionController> {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.session.value;

      if (session == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final tracks = controller.currentTracks;

      return Scaffold(
        appBar: GFAppBar(
          title: Text(session.name),
          actions: [
            GFButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              text: "싱크",
              onPressed: () {
                controller.sync();
              },
            ),
            SizedBox(width: 10),
            GFIconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await controller.openTrackSearchSheet();
              },
              tooltip: "트랙 추가",
            ),
            SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            if (tracks.isEmpty)
              Expanded(
                child: Center(
                  child: GFButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    text: "재생할 음악 트랙 추가하기",
                    onPressed: () async {
                      await controller.openTrackSearchSheet();
                    },
                  ),
                ),
              )
            else
              const Expanded(child: SessionPlayerView()),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // 채팅 버튼 + 뱃지
                  Obx(() {
                    final chatController = Get.find<ChatController>();
                    final count = chatController.unreadCount.value;
                    return Badge(
                      label: Text('$count'),
                      isLabelVisible: count > 1,
                      child: IconButton(
                        icon: Icon(Icons.chat_bubble),
                        onPressed: () {
                          chatController.markAllAsRead();
                          Get.bottomSheet(ChatBottomSheet());
                        },
                      ),
                    );
                  }),

                  const SizedBox(width: 8),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        spacing: 8,
                        children:
                            session.participants.map((p) {
                              return ParticipantChip(participant: p, size: 20);
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
