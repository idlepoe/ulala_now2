import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/models/session_track.dart';
import 'build_avatar.dart';

class UpcomingTrackTile extends StatelessWidget {
  final SessionTrack track;
  final bool isCurrent;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const UpcomingTrackTile({
    super.key,
    required this.track,
    required this.isCurrent,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  String getFormattedDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainSeconds = seconds % 60;

    final parts = <String>[];

    if (hours > 0) parts.add("$hours시간");
    if (minutes > 0) parts.add("$minutes분");
    if (remainSeconds > 0 || parts.isEmpty) {
      parts.add("$remainSeconds초"); // ✅ padLeft 제거
    }

    return parts.join(' ');
  }



  @override
  Widget build(BuildContext context) {
    if (isCurrent) return const SizedBox.shrink();

    final start = track.startAt;
    final formattedTime =
        "${start.hour}시 ${start.minute.toString().padLeft(2, '0')}분";

    final durationText = getFormattedDuration(track.duration);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: track.thumbnail,
                width: 80,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // 정보 + 좋아요 버튼 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목 + 좋아요 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              track.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),

                            Row(
                              children: [
                                const Icon(
                                  Icons.music_note,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  durationText,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.redAccent : Colors.grey,
                        ),
                        onPressed: onFavoriteToggle,
                        tooltip: '즐겨찾기',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // 시작 시각 + 등록자 정보 (좌우 정렬)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "시작: $formattedTime",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 12),
                          buildAvatar(
                            url: track.addedBy.avatarUrl,
                            nickname: track.addedBy.nickname,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            track.addedBy.nickname,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
