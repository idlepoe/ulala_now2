import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../../../data/controllers/theme_controller.dart';
import '../../session/widgets/played_track_bottom_sheet.dart';
import '../../session/widgets/profile_edit_dialog.dart';
import '../controllers/tab_setting_controller.dart';

class TabSettingView extends GetView<SessionController> {
  const TabSettingView({super.key});
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage:
            user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : null,
            child: user?.photoURL == null ? const Icon(Icons.person) : null,
          ),
          title: Text(
            user?.displayName ?? '익명 사용자',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Obx(() {
            return IconButton(
              icon: Icon(
                Get.find<ThemeController>().isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: Get.find<ThemeController>().toggleTheme,
              tooltip: '테마 전환',
            );
          }),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('프로필 변경'),
          onTap: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => const ProfileEditDialog(),
            );

            if (result == true) {
              // 프로필이 실제로 변경되었을 때만 처리
              Get.find<SessionController>().fetchSession();
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('재생된 트랙 목록'),
          onTap: () {
            Navigator.pop(context); // 먼저 BottomSheet 닫고
            _onShowHistory();
          },
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('세션 공유하기'),
          onTap: () {
            Navigator.pop(context);
            _shareSessionLink();
          },
        ),

        // ❌ 세션 나가기
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('세션 나가기', style: TextStyle(color: Colors.red)),
          onTap: () {
            _onLeaveSession();
          },
        ),
      ],
    );
  }

  void _shareSessionLink() {
    final sessionId = controller.session.value?.id;
    if (sessionId == null) return;

    final url = 'https://ulala-now2.web.app/session/$sessionId';
    final context = Get.context!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "세션 공유",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              QrImageView(data: url, version: QrVersions.auto, size: 200.0),
              const SizedBox(height: 16),
              SelectableText(
                url,
                style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Share.share(url);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text("링크 공유"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: url));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('링크가 복사되었습니다')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text("복사"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onShowHistory() {
    // 조금 기다렸다가 새로운 BottomSheet 열기
    Future.delayed(const Duration(milliseconds: 200), () {
      showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (_) =>
            PlayedTrackBottomSheet(sessionId: controller.session.value!.id),
      );
    });
  }

  Future<void> _onLeaveSession() async {
    Get.find<SessionController>().leaveSession();
  }
}
