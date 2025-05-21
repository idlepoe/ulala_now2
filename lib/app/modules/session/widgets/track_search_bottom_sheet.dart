import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';
import 'package:ulala_now2/app/modules/session/widgets/track_tile.dart';

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
        children: [
          const Text("YouTube에서 트랙 검색", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
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
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                controller.searchYoutube(value.trim());
              }
            },
          ),

          // 최근 검색어 목록
          Obx(() {
            final keywords = controller.recentKeywords;
            if (keywords.isEmpty) return const SizedBox.shrink();

            return Column(
              children: [
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "최근 검색어",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Row(
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
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),

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
