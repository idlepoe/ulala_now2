import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../widgets/track_search_bottom_sheet.dart';
import '../widgets/track_tile.dart';

class SessionView extends GetView<SessionController> {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.session.value;

      if (session == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        appBar: GFAppBar(
          title: Text(session.name),
          actions: [
            GFIconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _openTrackSearchSheet(context),
              tooltip: "트랙 추가",
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            if (session.trackList.isEmpty)
              Expanded(
                child: Center(
                  child: GFButton(
                    icon: const Icon(Icons.add),
                    text: "재생할 음악 트랙 추가하기",
                    onPressed: () => _openTrackSearchSheet(context),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: session.trackList.length,
                  itemBuilder: (context, index) {
                    final track = session.trackList[index];
                    return TrackTile(
                      track: track,
                      isFavorite: controller.isFavorite(track.videoId),
                      onFavorite: () => controller.toggleFavorite(track),
                      onAdd: () => controller.attachDurationAndAddTrack(track),

                    );
                  },
                ),
              ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: session.participants.map((p) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GFAvatar(
                          size: 24,
                          backgroundImage: CachedNetworkImageProvider(p.avatarUrl),
                          shape: GFAvatarShape.circle,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          p.nickname,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _openTrackSearchSheet(BuildContext context) {
    Get.bottomSheet(const TrackSearchBottomSheet(), isScrollControlled: true);
  }
}
