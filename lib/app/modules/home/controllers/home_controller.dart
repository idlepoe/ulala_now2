import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/session.dart';
import '../../../data/utils/api_service.dart';
import '../../../data/utils/logger.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final sessionList = <Session>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSessionList();
  }

  Future<void> fetchSessionList() async {
    isLoading.value = true;
    sessionList.value = await ApiService.getSessionList();
    isLoading.value = false;
  }

  Future<void> joinSession(String sessionId) async {
    try {
      await ApiService.joinSession(sessionId);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sessionId', sessionId);

      Get.offAllNamed(Routes.SPLASH);
    } catch (e) {
      Get.snackbar('오류', '세션 참가에 실패했습니다.');
    }
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  void openCreateSessionSheet(BuildContext context) {
    final random = Random();
    final names = [
      "은하 라운지",
      "코스믹 스테이션",
      "별빛 오페라",
      "달빛 극장",
      "우주 주파수",
      "타임캡슐 채널",
      "별의 회랑",
      "드림 오케스트라",
      "성운 카페",
      "미드나잇 리듬",
    ];
    final name = names[random.nextInt(names.length)];
    final number = 100 + random.nextInt(900); // 100~999
    final defaultName = "$name $number";

    final controller = TextEditingController(text: defaultName);
    final RxBool isPrivate = false.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '세션 만들기',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 🔹 회색 안내 박스
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '세션은 친구들과 함께 음악을 공유하고 감상할 수 있는 공간입니다.\n'
                '- 유튜브에서 노래를 검색하고 추가할 수 있어요\n'
                '- 즐겨찾기나 재생 이력을 통해 트랙을 쉽게 다시 들을 수 있어요\n'
                '- 세션은 URL로 간단히 공유할 수 있어 친구를 초대하기 좋아요',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 16),

            const Text('세션 이름', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '예: 별빛 오페라, 성운 라운지...',
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('비공개 세션'),
                      value: isPrivate.value,
                      onChanged: (val) {
                        if (val != null) isPrivate.value = val;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final name = controller.text.trim();
                      if (name.isEmpty) return;
                      isLoading.value = true;
                      Get.back();

                      final session = await ApiService.createSession(
                        name,
                        isPrivate: isPrivate.value,
                      );

                      await joinSession(session.id);
                    } catch (e) {
                      logger.e(e);
                    } finally {
                      isLoading.value = false;
                    }
                  },
                  child: const Text('세션 만들기'),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
