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
      Get.snackbar('error'.tr, 'session_join_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  void openCreateSessionSheet(BuildContext context) {
    final random = Random();
    final names = [
      'session_name_1'.tr,
      'session_name_2'.tr,
      'session_name_3'.tr,
      'session_name_4'.tr,
      'session_name_5'.tr,
      'session_name_6'.tr,
      'session_name_7'.tr,
      'session_name_8'.tr,
      'session_name_9'.tr,
      'session_name_10'.tr,
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
                  child: Text('create_session'.tr),
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
              child: Text(
                'session_description'.tr,
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'session_name_label'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'session_example'.tr,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'session_mode'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                      title: Text('session_private'.tr),
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

            Text(
              'session_private_hint'.tr,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
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
        return 'session_mode_desc_general'.tr;
      case SessionMode.dj:
        return 'session_mode_desc_dj'.tr;
    }
  }
}
