import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../widgets/chat_and_participants_bar.dart';
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
          title: controller.session.value!.name,
          // onSync: controller.sync,
          onSync: controller.showFixTutorial,
          onAddTrack: controller.openTrackSearchSheet,
          onShowHistory: _onShowHistory,
          onShare: _shareSessionLink,
          fixButtonKey: controller.fixButtonKey,
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

    final url = 'https://ulala-now2.web.app/session/$sessionId';
    final context = Get.context!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "세션 공유",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              QrImageView(
                data: url,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 16),
              SelectableText(
                url,
                style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Share.share(url);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text("링크 공유"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: url));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('링크가 복사되었습니다')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text("복사"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
