import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ulala_now2/app/modules/home/controllers/home_controller.dart';

import '../../../data/models/session.dart';
import '../../../data/models/session_track.dart';
import '../../../data/utils/logger.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../session/widgets/session_loading_view.dart';
import '../widgets/AppInfoDialog.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('울랄라'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: '앱 소개',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AppInfoDialog(),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const SessionLoadingView();
        }

        final sessions = controller.sessionList;
        if (sessions.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.fetchSessionList, // ✅ 새로고침 동작
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), // ✅ pull 가능하게
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height * 0.8, // 화면 중간 위치 정렬용
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('참여 가능한 세션이 없습니다.'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () => controller.openCreateSessionSheet(context),
                          child: const Text('세션 만들기'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchSessionList,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return ListTile(
                leading: Stack(
                  clipBehavior: Clip.none, // 바깥으로 아이콘이 삐져나오도록 허용
                  children: [
                    // 썸네일 이미지
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        session.trackList.isNotEmpty
                            ? session.trackList.first.thumbnail
                            : 'https://via.placeholder.com/55',
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // 모드 아이콘 (썸네일 바깥에 겹쳐 배치)
                    Positioned(
                      bottom: -6,
                      right: -6,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // 원형 그림자
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/mode_${session.mode.name}.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  session.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 남은 시간
                    Text(
                      '⏰ ${_formatRemainingTime(session.updatedAt)}',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    const SizedBox(height: 4),

                    if (session.trackList.isNotEmpty)
                      Row(
                        children: [
                          // // 썸네일
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(4),
                          //   child: Image.network(
                          //     session.trackList.first.thumbnail,
                          //     width: 40,
                          //     height: 40,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          // const SizedBox(width: 8),

                          // 트랙 제목 + 상태
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session.trackList.first.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _getTrackStatus(session.trackList.first),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                trailing: Text('👥 ${session.participantCount}'),
                onTap: () => controller.joinSession(session.id),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.openCreateSessionSheet(context),
        child: const Icon(Icons.add),
        tooltip: '세션 만들기',
      ),
    );
  }

  String _formatRemainingTime(DateTime updatedAt) {
    final expireAt = updatedAt.add(const Duration(days: 3));
    final now = DateTime.now();
    final diff = expireAt.difference(now);

    if (diff.isNegative) return '만료됨';

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (hours == 0) {
      return '$minutes분';
    } else {
      return '${hours}시간 ${minutes}분';
    }
  }

  String _modeLabel(SessionMode mode) {
    switch (mode) {
      case SessionMode.general:
        return '일반 모드';
      case SessionMode.dj:
        return 'DJ 모드';
      case SessionMode.shuffle:
        return '셔플 모드';
      default:
        return '';
    }
  }

  String _getTrackStatus(SessionTrack track) {
    final now = DateTime.now();

    final isStream = track.startAt == track.endAt && track.duration == 0;

    if (isStream) {
      if (now.isAfter(track.startAt)) {
        return '🔴 스트리밍 중';
      } else {
        return ''; // 아직 시작 전
      }
    }

    if (now.isAfter(track.startAt) && now.isBefore(track.endAt)) {
      return '🎶 재생 중';
    } else if (now.isAfter(track.endAt)) {
      final endedAt = DateFormat('HH:mm').format(track.endAt);
      return '🕒 종료됨: $endedAt';
    } else {
      return ''; // 예정 트랙은 표시하지 않음
    }
  }
}
