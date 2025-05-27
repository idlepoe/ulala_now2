import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../../session/widgets/track_tile.dart';
import '../../session/widgets/upcoming_track_tile.dart';

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
                Icon(
                  Icons.favorite_border,
                  size: 48,
                  color: Colors.pink.shade200,
                ),
                const SizedBox(height: 16),
                Text(
                  'favorites_empty'.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'favorites_tip'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  'waiting_for_first_favorite'.tr,
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
            Text(
              '❤️ ' + 'favorite_tracks'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: favs.length,
                padding: const EdgeInsets.only(bottom: 16),
                itemBuilder: (context, index) {
                  final track = favs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: TrackTile(
                      track: track,
                      isFavorite: true,
                      onFavorite: () => controller.toggleFavorite(track),
                      onAdd:
                          controller.canControlTrack()
                              ? () =>
                                  controller.attachDurationAndAddTrack(track)
                              : null,
                      isDisabled: !controller.canControlTrack(),
                      bottomWidget: null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
