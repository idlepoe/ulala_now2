import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../widgets/build_avatar.dart';
import 'session_player_view.dart';
import '../widgets/track_search_bottom_sheet.dart';

class SessionView extends GetView<SessionController> {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.session.value;

      if (session == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final tracks = controller.currentTracks;

      return Scaffold(
        appBar: GFAppBar(
          title: Text(session.name),
          actions: [
            GFButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              text: "싱크",
              onPressed: () {
                controller.sync();
              },
            ),
            SizedBox(width: 10),
            GFIconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _openTrackSearchSheet(),
              tooltip: "트랙 추가",
            ),
            SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            if (tracks.isEmpty)
              Expanded(
                child: Center(
                  child: GFButton(
                    icon: const Icon(Icons.add),
                    text: "재생할 음악 트랙 추가하기",
                    onPressed: () => _openTrackSearchSheet(),
                  ),
                ),
              )
            else
              const Expanded(child: SessionPlayerView()),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    session.participants.map((p) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildAvatar(
                              url: p.avatarUrl,
                              nickname: p.nickname,
                              size: 32,
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

  Future<void> _openTrackSearchSheet() async {
    final result = await Get.bottomSheet(
      const TrackSearchBottomSheet(),
      isScrollControlled: true,
    );
    if (result == true) {
      controller.sync(); // ✅ 성공한 경우만 새로고침
    }
  }
}
