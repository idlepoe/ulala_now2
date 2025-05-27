import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../../../data/models/session_track.dart';

import 'package:intl/intl.dart'; // 시간 포맷용

class CurrentTrackCard extends StatelessWidget {
  final SessionTrack track;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onSkipTrack; // ✅ 스킵 콜백 추가
  final DateTime now;
  final GlobalKey fixButtonKey;

  const CurrentTrackCard({
    super.key,
    required this.track,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onSkipTrack, // ✅ 필수
    required this.now,
    required this.fixButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    final isStream = track.startAt == track.endAt && track.duration == 0;
    final start = track.startAt;
    final end = track.endAt;
    final total = end.difference(start).inSeconds;
    final elapsed = now.difference(start).inSeconds.clamp(0, total);

    final endTimeFormatted = DateFormat('a h:mm').format(end);
    final durationFormatted =
        isStream ? 'streaming'.tr : getFormattedDuration(total);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                tooltip: 'favorite'.tr,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.grey),
                onPressed: onSkipTrack,
                tooltip: 'skip_current_track'.tr,
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

          // 🔵 or 🔴 진행 바
          LinearProgressIndicator(
            value: isStream ? 1.0 : (total > 0 ? elapsed / total : 0),
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            color: isStream ? Colors.redAccent : Colors.blueAccent,
            borderRadius: BorderRadius.circular(15),
          ),

          const SizedBox(height: 4),

          // 🎵 재생 시간
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.music_note,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        durationFormatted,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // ⏰ 종료 예정 (스트림은 생략)
                  if (!isStream)
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ending_soon'.tr + ': $endTimeFormatted',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Expanded(
                child: TextButton.icon(
                  key: fixButtonKey,
                  onPressed: Get.find<SessionController>().sync,
                  icon: Image.asset(
                    'assets/images/ic_fix.png',
                    width: 22,
                    height: 22,
                  ),
                  label: Text(
                    'no_sound_tip'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // ✅ 패딩 제거
                    minimumSize: Size(0, 0), // ✅ 최소 크기 제한도 제거
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // ✅ 터치 영역 최소화
                  ),
                ),
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
  if (hours > 0) parts.add("$hours${'hour'.tr}");
  if (minutes > 0) parts.add("$minutes${'minute'.tr}");
  if (remainSeconds > 0 || parts.isEmpty) {
    parts.add("$remainSeconds${'second'.tr}");
  }

  return parts.join(' ');
}
