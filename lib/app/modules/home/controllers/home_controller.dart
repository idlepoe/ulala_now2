import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/session.dart';
import '../../../data/utils/api_service.dart';
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

  void joinSession(String sessionId) async {
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
      "소리의 정원",
      "감성 창고",
      "리듬의 거리",
      "음악의 다락방",
      "재즈 카페",
      "사운드 라운지",
      "밤의 옥상",
      "쉼표 정류장",
      "멜로디 서재",
      "비트 극장",
    ];
    final name = names[random.nextInt(names.length)];
    final number = 100 + random.nextInt(900); // 100~999
    final defaultName = "$name $number";

    final controller = TextEditingController(text: defaultName);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('세션 이름 입력', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '세션 이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                Get.back();
                final session = await ApiService.createSession(name);
                joinSession(session.id);
              },
              child: const Text('세션 만들기'),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
