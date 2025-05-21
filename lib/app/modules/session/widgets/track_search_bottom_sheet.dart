import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';
import 'package:ulala_now2/app/modules/session/widgets/track_tile.dart';

import 'favorite_track_carousel.dart';

class TrackSearchBottomSheet extends StatelessWidget {
  const TrackSearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();
    final searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔼 타이틀 + 닫기 버튼
          Row(
            children: [
              const Expanded(
                child: Text(
                  "YouTube에서 트랙 검색",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 1),

          const SizedBox(height: 12),

          // 🔍 검색 입력창
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "노래 제목 또는 아티스트 입력",
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  final keyword = searchController.text.trim();
                  if (keyword.isNotEmpty) {
                    controller.searchYoutube(keyword);
                  }
                },
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                controller.searchYoutube(value.trim());
              }
            },
          ),

          // 🕓 최근 검색어
          Obx(() {
            final keywords = controller.recentKeywords;
            if (keywords.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "최근 검색어",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children:
                        keywords.map((keyword) {
                          return ActionChip(
                            label: Text(keyword),
                            onPressed: () {
                              searchController.text = keyword;
                              controller.searchYoutube(keyword);
                            },
                          );
                        }).toList(),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          // ⭐ 즐겨찾기 트랙 목록
          FavoriteTrackCarousel(),
          const SizedBox(height: 8),

          const Text("검색결과", style: TextStyle(fontWeight: FontWeight.bold)),

          // 🔽 검색 결과 리스트
          Obx(() {
            if (controller.isSearching.value) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final results = controller.youtubeSearchResults;
            if (results.isEmpty) {
              return const Expanded(child: Center(child: Text("검색 결과가 없습니다.")));
            }

            return Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final track = results[index];
                  return Obx(
                    () => TrackTile(
                      track: track,
                      isFavorite: controller.isFavorite(track.videoId),
                      onFavorite: () => controller.toggleFavorite(track),
                      onAdd: () => controller.attachDurationAndAddTrack(track),
                      isDisabled: controller.isSearching.value,
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
