import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulala_now2/app/data/controllers/theme_controller.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../../../data/constants/app_colors.dart';
import '../../../data/utils/api_service.dart';
import '../../../routes/app_pages.dart';
import '../widgets/profile_edit_dialog.dart';

class SessionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSync;
  final VoidCallback onAddTrack;
  final VoidCallback onShowHistory;
  final VoidCallback onShare;
  final Key fixButtonKey;

  const SessionAppBar({
    super.key,
    required this.title,
    required this.onSync,
    required this.onAddTrack,
    required this.onShowHistory,
    required this.onShare,
    required this.fixButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style, // 전체 기본 스타일
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                color: AppColors.deepLavender,
                fontWeight: FontWeight.bold,
              ), // '세션' 강조
            ), // 기존 title
            TextSpan(
              text: ' 세션',
              style: const TextStyle(), // '세션' 강조
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _openMenu(context),
      ),
      actions: [
        TextButton.icon(
          key: fixButtonKey, // ✅ 여기에 부착
          onPressed: onSync,
          icon: Image.asset('assets/images/ic_fix.png', width: 35, height: 35),
          label: const Text(
            "뚝딱 고치기",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        GetBuilder<SessionController>(
          builder: (controller) {
            final canControl = controller.canControlTrack();

            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.playlist_add),
                  tooltip: canControl ? "트랙 추가" : "DJ만",
                  onPressed: (!canControl) ? null : onAddTrack,
                  color: canControl ? null : Colors.grey,
                ),
                if (!canControl)
                  const Positioned(
                    bottom: 4,
                    child: Text(
                      'DJ만',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _openMenu(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
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
                onShowHistory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('세션 공유하기'),
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),

            // ❌ 세션 나가기
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('세션 나가기', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onLeaveSession();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> onLeaveSession() async {
    Get.find<SessionController>().leaveSession();
  }
}
