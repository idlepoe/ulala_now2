import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ulala_now2/app/modules/home/controllers/home_controller.dart';

import '../../../data/models/session.dart';
import '../../../data/models/session_track.dart';
import '../../../data/utils/logger.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../session/widgets/session_loading_view.dart';
import '../widgets/app_info_dialog.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'app_intro_title'.tr,
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
                        Text('no_session_available'.tr),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () => controller.openCreateSessionSheet(context),
                          child: Text('create_session'.tr),
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
                      child: CachedNetworkImage(
                        imageUrl:
                            session.trackList.isNotEmpty
                                ? session.trackList.first.thumbnail
                                : 'https://via.placeholder.com/85',
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              width: 85,
                              height: 85,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              width: 85,
                              height: 85,
                              color: Colors.grey.shade300,
                              child: Center(
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Image.asset(
                                    'assets/images/broken_image.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: 'create_session'.tr,
            child: Obx(
              () => FloatingActionButton(
                heroTag: 'create_session',
                onPressed:
                    controller.isLoading.value
                        ? null
                        : () => controller.openCreateSessionSheet(context),
                elevation: 6,
                backgroundColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.white,
                shape: const CircleBorder(),
                child: ClipOval(
                  child: Image.asset(
                    controller.isLoading.value
                        ? 'assets/images/ic_session_make_grey.png'
                        : 'assets/images/ic_session_make.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'create_session'.tr,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _formatRemainingTime(DateTime updatedAt) {
    final expireAt = updatedAt.add(const Duration(days: 3));
    final now = DateTime.now();
    final diff = expireAt.difference(now);

    if (diff.isNegative) return 'expired'.tr;

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (hours == 0) {
      return '$minutes${'minute'.tr}';
    } else {
      return '${hours}${'hour'.tr} ${minutes}${'minute'.tr}';
    }
  }

  String _getTrackStatus(SessionTrack track) {
    final now = DateTime.now();
    final isStream = track.startAt == track.endAt && track.duration == 0;

    if (isStream) {
      if (now.isAfter(track.startAt)) {
        return '🔴 ' + 'streaming'.tr;
      } else {
        return '';
      }
    }

    if (now.isAfter(track.startAt) && now.isBefore(track.endAt)) {
      return '🎶 ' + 'now_playing'.tr;
    } else if (now.isAfter(track.endAt)) {
      final diff = now.difference(track.endAt).inDays;

      if (diff == 0) {
        final endedAt = DateFormat('HH:mm').format(track.endAt);
        return '🕒 ' + 'ended'.tr + ': $endedAt';
      } else if (diff == 1) {
        return '🕒 ' + 'ended'.tr + ': ' + 'yesterday'.tr;
      } else if (diff == 2) {
        return '🕒 ' + 'ended'.tr + ': ' + 'two_days_ago'.tr;
      } else {
        final formatted = DateFormat('M/d HH:mm').format(track.endAt);
        return '🕒 ' + 'ended'.tr + ': $formatted';
      }
    }

    return '';
  }
}
