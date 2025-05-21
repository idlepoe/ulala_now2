import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = track.startAt;
    final end = start.add(Duration(seconds: track.duration));
    final total = end.difference(start).inSeconds;
    final elapsed = now.difference(start).inSeconds.clamp(0, total);

    if (isCurrent) return const SizedBox.shrink(); // 🔥 건너뜀

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          leading: CachedNetworkImage(
            imageUrl: track.thumbnail,
            width: Get.width / 5,
            fit: BoxFit.cover,
          ),
          title: Text(
            track.title,
            maxLines: 1,
            style: TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCurrent
                    ? "지금 재생 중"
                    : "예정: ${start.toLocal().toString().substring(11, 16)}",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  buildAvatar(
                    url: track.addedBy.avatarUrl,
                    nickname: track.addedBy.nickname,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    track.addedBy.nickname,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : Colors.grey,
            ),
            onPressed: onFavoriteToggle,
            tooltip: '즐겨찾기',
          ),
        ),
        if (isCurrent)
          LinearProgressIndicator(
            value: total > 0 ? elapsed / total : 0,
            minHeight: 4,
          ),
      ],
    );
  }
}
