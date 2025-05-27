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
      isLoading.value = true;
      await ApiService.joinSession(sessionId);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sessionId', sessionId);

      Get.offAllNamed(Routes.SPLASH);
    } catch (e) {
      Get.snackbar('오류', '세션 참가에 실패했습니다.');
    } finally {
      isLoading.value = false;
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
    final Rx<SessionMode> selectedMode = SessionMode.general.obs; // ✅ 모드 상태 추가

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'create_session'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        mode: selectedMode.value,
                      );
                      await joinSession(session.id);
                    } catch (e) {
                      logger.e(e);
                    } finally {
                      isLoading.value = false;
                    }
                  },
                  child:  Text('create_session'.tr),
                ),
              ],
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
            const SizedBox(height: 24),
            const Text('세션 모드', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    SessionMode.values.map((mode) {
                      final isSelected = selectedMode.value == mode;
                      return GestureDetector(
                        onTap: () => selectedMode.value = mode,
                        child: Container(
                          width: 90,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.blue.shade50 : Colors.white,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/mode_${mode.name}.png',
                                width: 32,
                                height: 32,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mode.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelected ? Colors.blue : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 12),
            Obx(
              () => Text(
                getSessionModeLabel(selectedMode.value),
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24),

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
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  String getSessionModeLabel(SessionMode mode) {
    switch (mode) {
      case SessionMode.general:
        return "🎵 일반 모드: 모두가 트랙을 추가하고 스킵할 수 있어요.";
      case SessionMode.dj:
        return "🎧 DJ 모드: 호스트만 트랙을 추가하고 조작할 수 있어요.";
    }
  }
}
