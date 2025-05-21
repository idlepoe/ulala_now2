import 'dart:math';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final RxString message = ''.obs;
  final messages = [
    '세션에 몰래 들어가는 중...',
    '참가자 수를 세고 있어요...',
    'DJ가 준비 중입니다...',
    '음악 케이블을 꽂는 중...',
    '좋은 곡을 탐색 중...',
    '리듬을 타고 있어요...',
    '서버를 깨우는 중...',
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
        final nickname = '익명$randomSuffix';

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
