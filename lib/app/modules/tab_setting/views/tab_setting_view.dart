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
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null ? const Icon(Icons.person) : null,
          ),
          title: Text(
            user?.displayName ?? 'anonymous_user'.tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          trailing: Obx(() {
            return IconButton(
              icon: Icon(
                Get.find<ThemeController>().isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: Get.find<ThemeController>().toggleTheme,
              tooltip: 'toggle_theme'.tr,
            );
          }),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text('edit_profile'.tr),
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
          title: Text('played_track_list'.tr),
          onTap: () {
            _onShowHistory();
          },
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: Text('share_session'.tr),
          onTap: () {
            _shareSessionLink();
          },
        ),

        // ❌ 세션 나가기
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text('leave_session'.tr, style: TextStyle(color: Colors.red)),
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
              Text(
                'share_session'.tr,
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
                    label: Text('link_share'.tr),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: url));
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('link_copied'.tr)));
                    },
                    icon: const Icon(Icons.copy),
                    label: Text('copy'.tr),
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
