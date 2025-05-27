import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_pip_mode/actions/pip_action.dart';
import 'package:simple_pip_mode/actions/pip_actions_layout.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../../../../main.dart';
import '../../../data/utils/logger.dart';
import '../widgets/chat_and_participants_bar.dart';
import '../widgets/mini_player_view.dart';
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

      return PipWidget(
        pipLayout: PipActionsLayout.mediaOnlyPause,
        onPipEntered: () {
          controller.sync();
        },
        onPipExited: () {
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
            if (controller.appLifecycleState == AppLifecycleState.resumed) {
              controller.sync();
            } else {
              logger.d("앱이 아직 포그라운드 아님. sync() 생략됨.");
            }
          });
        },
        onPipAction: (action) {
          switch (action) {
            case PipAction.play:
              controller.sync();
              break;
            case PipAction.pause:
              controller.youtubeController.pauseVideo();
              break;
            default:
              break;
          }
        },
        pipChild: const MiniPlayerView(),
        child: Scaffold(
          appBar: SessionAppBar(
            title: controller.session.value!.name,
            // onSync: controller.sync,
            onSync: controller.sync,
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
                      label: Text('add_track_to_play'.tr),
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!kIsWeb && Platform.isAndroid)
                  FloatingActionButton.small(
                    heroTag: 'pip_button',
                    onPressed: () {
                      _ensurePipMode();
                      // Get.to(() => PipExampleView());
                    },
                    child: const Icon(Icons.picture_in_picture),
                  ),
                SessionFloatingMenu(
                  onAddTrack: controller.openTrackSearchSheet,
                  onShowHistory: () {
                    showModalBottomSheet(
                      context: context,
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
                  onShare: _shareSessionLink,
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
              Text(
                'share_session'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              QrImageView(data: url, version: QrVersions.auto, size: 200.0),
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
                    label: Text('link_share'.tr),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: url));
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('link_copied'.tr)));
                    },
                    icon: const Icon(Icons.copy),
                    label: Text('copy'.tr),
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

  Future<void> _ensurePipMode() async {
    final isPipActivated = await SimplePip.isPipActivated;
    final isAvailable = await SimplePip.isPipAvailable;

    // 진입 시점에서 PiP가 꺼져 있다면 수동으로 진입
    if (isAvailable && !isPipActivated) {
      await pip.enterPipMode();
      await pip.setAutoPipMode();
    }
  }
}
