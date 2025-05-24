import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/session_controller.dart';

class FavoriteTrackCarousel extends StatelessWidget {
  const FavoriteTrackCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();

    return Obx(() {
      final favs = controller.favorites.values.toList().reversed.toList();
      if (favs.isEmpty) return const SizedBox.shrink();

      final isDark = Theme.of(context).brightness == Brightness.dark;
      final bgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade100;
      final labelColor = isDark ? Colors.white : Colors.black87;
      final shadowColor =
          isDark ? Colors.transparent : Colors.black.withOpacity(0.05);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "⭐ 즐겨찾기 트랙",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: favs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final track = favs[index];

                return GestureDetector(
                  onTap: () => controller.toggleSelectedFavorite(track.videoId),
                  child: Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width:
                          controller.selectedFavoriteId.value == track.videoId
                              ? 200
                              : 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: track.thumbnail,
                                  width: 80,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _shortTitle(track.title),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white, // 어두운 배경에 고정
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (controller.selectedFavoriteId.value ==
                              track.videoId) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          color:
                                              isDark
                                                  ? Colors.redAccent
                                                  : Colors.red,
                                        ),
                                        onPressed:
                                            () => controller.toggleFavorite(
                                              track,
                                            ),
                                        tooltip: "즐겨찾기",
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.playlist_add,
                                              color:
                                                  controller.canControlTrack()
                                                      ? labelColor
                                                      : Colors.grey,
                                            ),
                                            onPressed:
                                                !controller.canControlTrack()
                                                    ? null
                                                    : () => controller
                                                        .attachDurationAndAddTrack(
                                                          track,
                                                        ),
                                            tooltip: "세션추가",
                                          ),
                                          if (!controller.canControlTrack())
                                            const Positioned(
                                              bottom: 4,
                                              child: Text(
                                                'DJ만',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  String _shortTitle(String title) {
    return title.length > 12 ? '${title.substring(0, 10)}…' : title;
  }
}
