import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:ulala_now2/app/modules/session/widgets/track_tile.dart';

import '../../../data/models/session_track.dart';
import '../../../data/utils/api_service.dart';
import '../controllers/session_controller.dart';

class PlayedTrackBottomSheet extends StatelessWidget {
  final String sessionId;

  const PlayedTrackBottomSheet({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();
    return FractionallySizedBox(
      heightFactor: 0.5, // 화면의 절반 높이
      child: Column(
        children: [
          // 🔼 헤더: 제목 + 닫기 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'played_track_list'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 🔽 콘텐츠 영역 (FutureBuilder)
          Expanded(
            child: FutureBuilder<List<SessionTrack>>(
              future: ApiService.getPlayedTracks(sessionId: sessionId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tracks = snapshot.data!;
                if (tracks.isEmpty) {
                  return Center(child: Text('no_played_tracks'.tr));
                }

                // 날짜별 그룹화
                final grouped = <String, List<SessionTrack>>{};
                for (final track in tracks) {
                  final key = DateFormat('yyyy.MM.dd').format(track.endAt);
                  grouped.putIfAbsent(key, () => []).add(track);
                }

                return ListView(
                  padding: const EdgeInsets.all(12),
                  children:
                      grouped.entries.expand((entry) {
                        final dateTitle = _friendlyDateLabel(entry.key);

                        return [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              dateTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ...entry.value.map(
                            (track) => Obx(
                              () => TrackTile(
                                track: track,
                                isFavorite: controller.isFavorite(
                                  track.videoId,
                                ),
                                onFavorite:
                                    () => controller.toggleFavorite(track),
                                onAdd:
                                    () => controller.attachDurationAndAddTrack(
                                      track,
                                    ),
                                isDisabled: controller.isSearching.value,
                                bottomWidget: _buildTrackInfoWidget(track),
                              ),
                            ),
                          ),
                        ];
                      }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _friendlyDateLabel(String dateKey) {
    final now = DateTime.now();
    final today = DateFormat('yyyy.MM.dd').format(now);
    final yesterday = DateFormat(
      'yyyy.MM.dd',
    ).format(now.subtract(const Duration(days: 1)));

    if (dateKey == today) return 'today'.tr;
    if (dateKey == yesterday) return 'yesterday'.tr;
    return dateKey;
  }

  Widget _buildTrackInfoWidget(SessionTrack track) {
    final playedAt = DateFormat('HH:mm').format(track.startAt);
    final duration = track.endAt.difference(track.startAt);

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    final parts = <String>[];
    if (hours > 0) parts.add('$hours${'hour'.tr}');
    if (minutes > 0) parts.add('$minutes${'minute'.tr}');
    if (seconds > 0 || parts.isEmpty) parts.add('$seconds${'second'.tr}');

    final formattedDuration = parts.join(' ');

    return Row(
      children: [
        const Icon(Icons.schedule, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          playedAt,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.music_note, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          formattedDuration,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
