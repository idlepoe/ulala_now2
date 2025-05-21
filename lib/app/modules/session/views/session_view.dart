import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ulala_now2/app/modules/session/controllers/chat_controller.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../widgets/chat_bottom_sheet.dart';
import '../widgets/participant_chip.dart';
import '../widgets/played_track_bottom_sheet.dart';
import 'session_app_bar.dart';
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
        appBar: SessionAppBar(
          title: controller.session.value?.name ?? '세션',
          onSync: controller.sync,
          onAddTrack: controller.openTrackSearchSheet,
          onShowHistory: _onShowHistory,
          onShare: _shareSessionLink,
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            if (tracks.isEmpty)
              Expanded(
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.playlist_add),
                    label: Text("재생할 음악 트랙 추가하기"),
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: SpeedDial(
            icon: Icons.menu,
            activeIcon: Icons.close,
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            overlayOpacity: 0.1,
            spacing: 10,
            spaceBetweenChildren: 8,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.playlist_add),
                backgroundColor: Colors.green,
                label: '트랙 추가',
                onTap: () => controller.openTrackSearchSheet(),
              ),
              SpeedDialChild(
                child: const Icon(Icons.history),
                backgroundColor: Colors.orange,
                label: '트랙 이력',
                onTap: () {
                  showModalBottomSheet(
                    context: Get.context!,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder:
                        (_) => PlayedTrackBottomSheet(
                          sessionId: controller.session.value!.id,
                        ),
                  );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.share),
                backgroundColor: Colors.indigo,
                label: '세션 공유',
                onTap: _shareSessionLink,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _shareSessionLink() {
    final sessionId = controller.session.value?.id;
    if (sessionId == null) return;

    final url = 'https://myapp.page.link/session/$sessionId';
    SharePlus.instance.share(ShareParams(uri: Uri.tryParse(url)));
  }

  void _onShowHistory() {
    // 조금 기다렸다가 새로운 BottomSheet 열기
    Future.delayed(const Duration(milliseconds: 200), () {
      showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (_) =>
                PlayedTrackBottomSheet(sessionId: controller.session.value!.id),
      );
    });
  }
}
