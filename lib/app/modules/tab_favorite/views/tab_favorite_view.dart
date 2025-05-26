import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../../session/widgets/track_tile.dart';

class TabFavoriteView extends GetView<SessionController> {
  const TabFavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final favs = controller.favorites.values.toList().reversed.toList();
      if (favs.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 48, color: Colors.pink.shade200),
                const SizedBox(height: 16),
                const Text(
                  "텅 비었네요 💔",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "좋아하는 트랙에 하트를 눌러\n나만의 즐겨찾기를 만들어보세요!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                const Text(
                  "첫 번째 ❤️ 를 기다리고 있어요",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "❤️ 즐겨찾기 트랙",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              itemCount: favs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const Divider(indent: 12, endIndent: 12),
              itemBuilder: (context, index) {
                final track = favs[index];
                return TrackTile(
                  track: track,
                  isFavorite: true,
                  onFavorite: () => controller.toggleFavorite(track),
                  onAdd: controller.canControlTrack()
                      ? () => controller.attachDurationAndAddTrack(track)
                      : null,
                  isDisabled: !controller.canControlTrack(),
                  bottomWidget: null,
                );
              },
            ),
          ],
        ),
      );
    });
  }

}
