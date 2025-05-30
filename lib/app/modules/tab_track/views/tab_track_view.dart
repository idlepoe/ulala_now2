import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../session/controllers/session_controller.dart';
import '../../session/views/session_player_view.dart';
import '../../session/widgets/session_loading_view.dart';

class TabTrackView extends GetView<SessionController> {
  const TabTrackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.session.value;

      if (session == null) {
        return SessionLoadingView();
      }
      final tracks = controller.currentTracks;

      return Scaffold(
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
                      controller.changeTab(1);
                    },
                  ),
                ),
              )
            else
              const Expanded(child: SessionPlayerView()),
            // const Divider(height: 1),
          ],
        ),
      );
    });
  }
}
