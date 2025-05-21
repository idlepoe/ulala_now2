import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:ulala_now2/app/modules/session/widgets/upcoming_track_tile.dart';

import '../controllers/session_controller.dart';

class UpcomingTrackList extends GetView<SessionController> {
  const UpcomingTrackList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tracks = controller.currentTracks;
      final now = controller.currentTime.value;

      final upcoming =
          tracks.where((t) => t.endAt.isAfter(now)).toList()
            ..sort((a, b) => a.startAt.compareTo(b.startAt));

      final current = upcoming.firstWhereOrNull((track) {
        return now.isAfter(track.startAt) && now.isBefore(track.endAt);
      });

      if (upcoming.isEmpty || upcoming.length == 1) {
        return Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text("${upcoming.length == 1 ? "다음 " : ""}재생할 음악 트랙 추가하기"),
            onPressed: () async {
              await controller.openTrackSearchSheet();
            },
          ),
        );
      }

      // logger.w("render");
      return ListView.builder(
        itemCount: upcoming.length,
        itemBuilder: (context, index) {
          final track = upcoming[index];
          return Obx(
            () => UpcomingTrackTile(
              track: track,
              isCurrent: current?.id == track.id,
              isFavorite: controller.isFavorite(track.videoId),
              onFavoriteToggle: () => controller.toggleFavorite(track),
            ),
          );
        },
      );
    });
  }
}
