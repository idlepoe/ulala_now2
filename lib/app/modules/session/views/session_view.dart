import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ulala_now2/app/modules/session/controllers/chat_controller.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../widgets/chat_and_participants_bar.dart';
import '../widgets/chat_bottom_sheet.dart';
import '../widgets/participant_chip.dart';
import '../widgets/played_track_bottom_sheet.dart';
import '../widgets/session_floating_menu.dart';
import '../widgets/session_loading_view.dart';
import 'session_app_bar.dart';
import 'session_player_view.dart';

class SessionView extends GetView<SessionController> {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.session.value;

      if (session == null) {
        return SessionLoadingView();
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
            ChatAndParticipantsBar(participants: session.participants),
          ],
        ),
        floatingActionButton: SessionFloatingMenu(
          onAddTrack: controller.openTrackSearchSheet,
          onShowHistory: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder:
                  (_) => PlayedTrackBottomSheet(
                    sessionId: controller.session.value!.id,
                  ),
            );
          },
          onShare: _shareSessionLink,
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
