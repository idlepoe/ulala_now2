import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../../session/widgets/track_tile.dart';
import '../controllers/tab_favorite_controller.dart';

class TabFavoriteView extends GetView<SessionController> {
  const TabFavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final favs = controller.favorites.values.toList().reversed.toList();
      if (favs.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "⭐ 즐겨찾기 트랙",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.separated(
              itemCount: favs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder:
                  (_, __) => const Divider(indent: 12, endIndent: 12),
              itemBuilder: (context, index) {
                final track = favs[index];

                return TrackTile(
                  track: track,
                  isFavorite: true,
                  onFavorite: () => controller.toggleFavorite(track),
                  onAdd:
                      controller.canControlTrack()
                          ? () => controller.attachDurationAndAddTrack(track)
                          : null,
                  isDisabled: !controller.canControlTrack(),
                  bottomWidget: null, // 또는 원하는 추가 정보 위젯
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
