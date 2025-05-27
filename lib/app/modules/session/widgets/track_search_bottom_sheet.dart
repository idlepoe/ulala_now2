import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';
import 'package:ulala_now2/app/modules/session/widgets/track_tile.dart';
import 'package:ulala_now2/app/modules/session/widgets/youtube_search_input.dart';

import 'favorite_track_carousel.dart';

class TrackSearchBottomSheet extends StatelessWidget {
  const TrackSearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();
    final searchController = TextEditingController();

    return Container(
      height: MediaQuery.of(context).size.height * (kIsWeb ? 0.6 : 0.8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단 AppBar + 검색 입력창 포함
          _buildSearchAppBar(context, controller, searchController),

          // 나머지 콘텐츠 스크롤 영역
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  // 최근 검색어
                  SliverToBoxAdapter(
                    child: Obx(() {
                      final keywords = controller.recentKeywords;
                      if (keywords.isEmpty) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'recent_searches'.tr,
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
                  ),

                  // 즐겨찾기
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: FavoriteTrackCarousel(),
                    ),
                  ),

                  // 검색 결과 타이틀
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Text(
                        'search_results'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // 검색 결과 리스트
                  Obx(() {
                    if (controller.isSearching.value) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final results = controller.youtubeSearchResults;
                    if (results.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(child: Text('no_search_result'.tr)),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final track = results[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Obx(
                            () => TrackTile(
                              track: track,
                              // isFavorite: controller.isFavorite(track.videoId),
                              // onFavorite:
                              //     () => controller.toggleFavorite(track),
                              // onAdd: () {
                              //   controller.attachDurationAndAddTrack(track);
                              // },
                              isDisabled: controller.isSearching.value,
                            ),
                          ),
                        );
                      }, childCount: results.length),
                    );
                  }),
                  SliverToBoxAdapter(child: SizedBox(height: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAppBar(
    BuildContext context,
    SessionController controller,
    TextEditingController searchController,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀 + 닫기 버튼
          Row(
            children: [
              Expanded(
                child: Text(
                  'search_youtube'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Obx(
            () => YoutubeSearchInput(
              controller: searchController,
              enabled:
                  (!controller.isSearchCooldown.value &&
                      !controller.isSearching.value),
              onSearch: (keyword) => controller.searchYoutube(keyword),
              cooldownMessage:
                  controller.isSearchCooldown.value
                      ? 'search_limit_notice'.tr +
                          ': ${_formatDuration(controller.remainingCooldown.value)}'
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
