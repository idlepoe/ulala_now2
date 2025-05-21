import 'package:flutter/material.dart';

import '../../../data/models/session_track.dart';

import 'package:intl/intl.dart'; // 시간 포맷용

class CurrentTrackCard extends StatelessWidget {
  final SessionTrack track;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final DateTime now;

  const CurrentTrackCard({
    super.key,
    required this.track,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final start = track.startAt;
    final end = track.endAt;
    final total = end.difference(start).inSeconds;
    final elapsed = now.difference(start).inSeconds.clamp(0, total);

    final endTimeFormatted = DateFormat.Hms().format(end); // 종료시간 포맷

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 제목 + 즐겨찾기 버튼
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  track.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
            ],
          ),
          const SizedBox(height: 4),
          // 설명
          Text(
            track.description,
            style: const TextStyle(color: Colors.black54),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // 진행 바
          LinearProgressIndicator(
            value: total > 0 ? elapsed / total : 0,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 4),
          // 종료 시간 텍스트
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '종료 예정: $endTimeFormatted',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
