import 'dart:math';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final RxString message = ''.obs;
  final messages = [
    'session_joining'.tr,
    'counting_participants'.tr,
    'dj_preparing'.tr,
    'connecting_cable'.tr,
    'exploring_tracks'.tr,
    'feeling_rhythm'.tr,
    'waking_up_server'.tr,
  ];

  @override
  void onInit() {
    super.onInit();
    message.value = (messages..shuffle()).first;
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      // Firebase 익명 로그인
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final user = userCredential.user;

      // SharedPreferences or Firestore 확인
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('sessionId');

      // 닉네임 할당이 안된 경우 → 랜덤 닉네임 부여
      if (user != null &&
          (user.displayName == null || user.displayName!.isEmpty)) {
        final randomSuffix = (10000 + Random().nextInt(89999)).toString();
        final nickname = '${'anonymous'.tr}$randomSuffix';

        await user.updateDisplayName(nickname);
        await user.reload(); // 정보 갱신
      }

      // 라우팅
      if (sessionId != null) {
        Get.offAllNamed(Routes.SESSION + '/$sessionId');
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (_) {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
