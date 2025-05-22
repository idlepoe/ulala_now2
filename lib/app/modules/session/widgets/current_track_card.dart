import 'package:flutter/material.dart';

import '../../../data/models/session_track.dart';

import 'package:intl/intl.dart'; // 시간 포맷용

class CurrentTrackCard extends StatelessWidget {
  final SessionTrack track;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onSkipTrack; // ✅ 스킵 콜백 추가
  final DateTime now;

  const CurrentTrackCard({
    super.key,
    required this.track,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onSkipTrack, // ✅ 필수
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final start = track.startAt;
    final end = track.endAt;
    final total = end.difference(start).inSeconds;
    final elapsed = now.difference(start).inSeconds.clamp(0, total);

    // 종료 예정 시각 포맷 (오전/오후 포함)
    final endTimeFormatted = DateFormat('a h:mm', 'ko').format(end);
    final durationFormatted = getFormattedDuration(total);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔼 제목 + 즐겨찾기 + 스킵
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  track.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriteToggle,
                tooltip: '즐겨찾기',
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.grey),
                onPressed: onSkipTrack,
                tooltip: '현재 트랙 스킵',
              ),
            ],
          ),
          const SizedBox(height: 4),

          // 🔽 설명
          Text(
            track.description,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // 🔵 진행 바
          LinearProgressIndicator(
            value: total > 0 ? elapsed / total : 0,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          const SizedBox(height: 4),

          // ⏰ 종료 시간
          Row(
            children: [
              const Icon(Icons.music_note, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                durationFormatted,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '종료 예정: $endTimeFormatted',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String getFormattedDuration(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainSeconds = seconds % 60;

  final parts = <String>[];
  if (hours > 0) parts.add("$hours시간");
  if (minutes > 0) parts.add("$minutes분");
  if (remainSeconds > 0 || parts.isEmpty) {
    parts.add("$remainSeconds초");
  }

  return parts.join(' ');
}
