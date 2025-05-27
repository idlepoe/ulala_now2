import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../../session/widgets/favorite_track_carousel.dart';
import '../../session/widgets/track_tile.dart';
import '../../session/widgets/youtube_search_input.dart';

class TabSearchView extends GetView<SessionController> {
  const TabSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단 AppBar + 검색 입력창 포함
          _buildSearchAppBar(context, searchController),

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
                  ),

                  // 검색 결과 타이틀
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Text(
                        "search_results".tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // 검색 결과 리스트
                  Obx(() {
                    if (controller.isSearching.value) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                      );
                    }

                    final results = controller.youtubeSearchResults;
                    if (results.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'no_song_found'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'search_retry_tip'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final track = results[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          child: Obx(
                            () => TrackTile(
                              track: track,
                              isFavorite: controller.isFavorite(track.videoId),
                              onFavorite:
                                  () => controller.toggleFavorite(track),
                              onAdd: () {
                                controller.attachDurationAndAddTrack(track);
                              },
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
          Obx(
            () => YoutubeSearchInput(
              controller: searchController,
              enabled:
                  (!controller.isSearchCooldown.value &&
                      !controller.isSearching.value),
              onSearch: (keyword) => controller.searchYoutube(keyword),
              cooldownMessage:
                  controller.isSearchCooldown.value
                      ? '${'search_limit_notice'.tr}: ${_formatDuration(controller.remainingCooldown.value)}'
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
