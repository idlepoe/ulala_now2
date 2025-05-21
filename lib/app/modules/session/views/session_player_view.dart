import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:ulala_now2/app/data/models/session_track.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';
import 'package:ulala_now2/app/modules/session/widgets/upcoming_trak_list.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../widgets/current_track_card.dart';

class SessionPlayerView extends GetView<SessionController> {
  const SessionPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tracks = controller.currentTracks;
      final current = _getCurrentTrack(tracks);
      return Scaffold(
        body: Column(
          children: [
            // ▶️ 상단 YouTube 플레이어
            Obx(() {
              final _ = controller.playerRefreshTrigger.value; // ✅ trigger 감시
              return YoutubePlayer(
                controller: controller.youtubeController,
                aspectRatio: 16 / 9,
              );
            }),
            const SizedBox(height: 12),

            // 🎵 현재 재생 중인 트랙 정보
            if (current != null) ...[
              CurrentTrackCard(
                track: current,
                isFavorite: controller.isFavorite(current.videoId),
                onFavoriteToggle: () => controller.toggleFavorite(current),
                now: controller.currentTime.value,
              ),
            ] else ...[
              // 현재 재생 중이 아닐 경우
            ],

            const SizedBox(height: 12),
            if (current != null) const Divider(),

            // 🔜 앞으로 재생될 리스트
            Expanded(child: UpcomingTrackList()),
          ],
        ),
      );
    });
  }

  SessionTrack? _getCurrentTrack(List<SessionTrack> tracks) {
    final now = DateTime.now();
    return tracks.firstWhereOrNull((track) {
      final end = track.startAt.add(Duration(seconds: track.duration));
      return now.isAfter(track.startAt) && now.isBefore(end);
    });
  }
}
