import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:simple_pip_mode/actions/pip_action.dart';
import 'package:simple_pip_mode/actions/pip_actions_layout.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../data/models/session_track.dart';
import '../../../data/utils/api_service.dart';
import '../../../data/utils/logger.dart';
import '../../session/controllers/session_controller.dart';
import '../../session/widgets/current_track_card.dart';
import '../../session/widgets/mini_player_view.dart';
import '../../tab_chat/views/tab_chat_view.dart';
import '../../tab_favorite/views/tab_favorite_view.dart';
import '../../tab_search/views/tab_search_view.dart';
import '../../tab_setting/views/tab_setting_view.dart';
import '../../tab_track/views/tab_track_view.dart';

class SessionTabView extends GetView<SessionController> {
  const SessionTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PipWidget(
        pipLayout: PipActionsLayout.mediaOnlyPause,
        onPipEntered: () {
          controller.sync();
        },
        onPipExited: () {
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
            if (controller.appLifecycleState == AppLifecycleState.resumed) {
              controller.sync();
            } else {
              logger.d("앱이 아직 포그라운드 아님. sync() 생략됨.");
            }
          });
        },
        onPipAction: (action) {
          switch (action) {
            case PipAction.play:
              controller.sync();
              break;
            case PipAction.pause:
              controller.youtubeController.pauseVideo();
              break;
            default:
              break;
          }
        },
        pipChild: const MiniPlayerView(),
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    height: 175,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  // 원하는 R 값
                                  child: YoutubePlayer(
                                    key: const ValueKey('persistent-player'),
                                    controller: controller.youtubeController,
                                    aspectRatio: 16 / 9,
                                  ),
                                ),
                              ),
                            ],
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
                              onSkipTrack: () async {
                                await ApiService.skipTrack(
                                  sessionId: controller.sessionId,
                                  trackId: current.id,
                                );
                                await Future.delayed(Duration(seconds: 2));
                                controller
                                    .sync(); // 또는 fetchSession() 등 갱신 로직 호출
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey, indent: 20, endIndent: 20),
              Expanded(
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: const [
                    TabTrackView(),
                    TabSearchView(),
                    TabFavoriteView(),
                    TabChatView(),
                    TabSettingView(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note),
                  label: '트랙',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
                BottomNavigationBarItem(icon: Icon(Icons.star), label: '즐겨찾기'),
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: '설정',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SessionTrack? _getCurrentTrack(List<SessionTrack> tracks) {
    final now = DateTime.now();

    return tracks.firstWhereOrNull((track) {
      final isStream = track.startAt == track.endAt && track.duration == 0;

      if (isStream) {
        // 스트리밍 트랙은 시작 후면 항상 current
        return now.isAfter(track.startAt);
      }

      final end = track.startAt.add(Duration(seconds: track.duration));
      return now.isAfter(track.startAt) && now.isBefore(end);
    });
  }
}
