import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_pip_mode/simple_pip.dart';

import '../../../data/models/session_track.dart';
import '../../../data/utils/logger.dart';
import '../controllers/session_controller.dart';

class MiniPlayerView extends StatefulWidget {
  const MiniPlayerView({super.key});

  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  @override
  void initState() {
    super.initState();
    logger.d("miniplayer");
    // _ensurePipMode();
  }

  Future<void> _ensurePipMode() async {
    final isPipActivated = await SimplePip.isPipActivated;
    final isAvailable = await SimplePip.isPipAvailable;

    // 진입 시점에서 PiP가 꺼져 있다면 수동으로 진입
    if (isAvailable && !isPipActivated) {
      // await pip.enterPipMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();

    return Obx(() {
      final track = _getCurrentTrack(controller.currentTracks);
      final now = controller.currentTime.value;

      if (track == null) return const SizedBox.expand();

      final isPlaying = _isTrackCurrentlyPlaying(track, now);
      final isStream = track.duration == 0 && track.startAt == track.endAt;
      final total = track.endAt.difference(track.startAt).inSeconds;
      final elapsed = now.difference(track.startAt).inSeconds.clamp(0, total);

      final endFormatted =
          isStream
              ? '스트리밍 중'
              : '종료 예정: ${DateFormat('a h:mm', 'ko').format(track.endAt)}';

      return _buildMiniPlayerBody(
        track,
        isPlaying,
        elapsed,
        total,
        endFormatted,
        controller,
      );
    });
  }

  Widget _buildMiniPlayerBody(
    SessionTrack track,
    bool isPlaying,
    int elapsed,
    int total,
    String endFormatted,
    SessionController controller,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 썸네일 배경
          Image.network(track.thumbnail, fit: BoxFit.cover),

          // 🔹 하단 정보 + 진행 바
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black54, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  track.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  track.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  endFormatted,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: total > 0 ? elapsed / total : 0,
                  minHeight: 5,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SessionTrack? _getCurrentTrack(List<SessionTrack> tracks) {
    final now = DateTime.now();
    return tracks.firstWhereOrNull((track) {
      final isStream = track.duration == 0 && track.startAt == track.endAt;
      if (isStream) return now.isAfter(track.startAt);
      final end = track.startAt.add(Duration(seconds: track.duration));
      return now.isAfter(track.startAt) && now.isBefore(end);
    });
  }

  bool _isTrackCurrentlyPlaying(SessionTrack? track, DateTime now) {
    if (track == null) return false;
    final isStream = track.duration == 0 && track.startAt == track.endAt;
    if (isStream) return now.isAfter(track.startAt);
    final end = track.startAt.add(Duration(seconds: track.duration));
    return now.isAfter(track.startAt) && now.isBefore(end);
  }
}
