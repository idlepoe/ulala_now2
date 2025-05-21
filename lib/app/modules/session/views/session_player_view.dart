import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_now2/app/data/models/session_track.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';
import 'package:ulala_now2/app/modules/session/widgets/upcoming_trak_list.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../widgets/current_track_card.dart';

class SessionPlayerView extends GetView<SessionController> {
  const SessionPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tracks = controller.currentTracks;
      final current = _getCurrentTrack(tracks);

      return Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // 상단 고정 영역
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverPlayerDelegate(
                minExtent: 160,
                maxExtent: 160,
                builder: (context, shrinkOffset, overlapsContent) {
                  return Container(
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: YoutubePlayer(
                            key: const ValueKey('persistent-player'),
                            // ✅ 고정된 key로 상태 유지
                            controller: controller.youtubeController,
                            aspectRatio: 16 / 9,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: Obx(() {
                            final current = _getCurrentTrack(
                              controller.currentTracks,
                            );
                            if (current == null) {
                              final message =
                                  controller.noTrackMessages[DateTime.now()
                                          .millisecond %
                                      controller.noTrackMessages.length];
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    message,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return CurrentTrackCard(
                              track: current,
                              isFavorite: controller.isFavorite(
                                current.videoId,
                              ),
                              onFavoriteToggle:
                                  () => controller.toggleFavorite(current),
                              now: controller.currentTime.value,
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            if (current != null) const SliverToBoxAdapter(child: Divider()),

            // 앞으로 재생될 트랙 리스트
            SliverFillRemaining(child: UpcomingTrackList()),
          ],
        ),
      );
    });
  }

  SessionTrack? _getCurrentTrack(List<SessionTrack> tracks) {
    final now = DateTime.now();
    return tracks.firstWhereOrNull((track) {
      final end = track.startAt.add(Duration(seconds: track.duration));
      return now.isAfter(track.startAt) && now.isBefore(end);
    });
  }
}

class PlayerHeader extends StatelessWidget {
  final Widget Function() buildPlayer;
  final Widget? currentTrack;
  final double shrinkOffset;

  const PlayerHeader({
    super.key,
    required this.buildPlayer,
    required this.shrinkOffset,
    this.currentTrack,
  });

  @override
  Widget build(BuildContext context) {
    final isShrunk = shrinkOffset > 120;
    final player = buildPlayer(); // ✅ 재사용 보장

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child:
          currentTrack == null
              ? player
              : isShrunk
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: player),
                  const SizedBox(width: 12),
                  Expanded(flex: 3, child: currentTrack!),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [player, const SizedBox(height: 12), currentTrack!],
              ),
    );
  }
}

class _SliverPlayerDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget Function(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  )
  builder;

  _SliverPlayerDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.builder,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  @override
  bool shouldRebuild(covariant _SliverPlayerDelegate oldDelegate) {
    return true;
  }
}
