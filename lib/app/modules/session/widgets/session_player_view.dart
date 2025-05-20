import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:ulala_now2/app/data/models/session_track.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SessionPlayerView extends GetView<SessionController> {
  const SessionPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tracks = controller.prevTracks;
      final current = _getCurrentTrack(tracks);
      final upcoming = _getUpcomingTracks(tracks);

      return Scaffold(
        appBar: AppBar(title: const Text("현재 재생 중")),
        body: Column(
          children: [
            // ▶️ 상단 YouTube 플레이어
            YoutubePlayer(
              controller: controller.youtubeController,
              aspectRatio: 16 / 9,
            ),
            const SizedBox(height: 12),

            // 🎵 현재 재생 중인 트랙 정보
            if (current != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      current.description,
                      style: const TextStyle(color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            const Divider(),

            // 🔜 앞으로 재생될 리스트
            Expanded(
              child: ListView.builder(
                itemCount: upcoming.length,
                itemBuilder: (context, index) {
                  final track = upcoming[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: track.thumbnail,
                      width: 60,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    title: Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text("예정: ${track.startAt.toLocal().toString().substring(11, 16)}"),
                  );
                },
              ),
            ),
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

  List<SessionTrack> _getUpcomingTracks(List<SessionTrack> tracks) {
    final now = DateTime.now();
    return tracks
        .where((t) => t.startAt.isAfter(now))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }
}
