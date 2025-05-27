import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ulala_now2/app/modules/session/widgets/upcoming_track_tile.dart';

import '../../../data/utils/logger.dart';
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

      // 다음 곡이 없거나 현재 곡 하나만 있을 경우
      final isLastTrack =
          (current != null && upcoming.length <= 1) || upcoming.isEmpty;

      if (isLastTrack) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.queue_music, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'no_next_track'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'add_track_tip'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.changeTab(1);
                  },
                  icon: const Icon(Icons.add),
                  label: Text('add_track'.tr),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // 일반적으로 여러 트랙이 있는 경우
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
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
