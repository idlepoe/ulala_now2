import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔽 앱 로고 이미지
              Image.asset(
                'assets/images/icon-removebg.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 32),

              // 🔽 고정 안내 문구
              Text(
                'checking_session_state'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              // 🔽 재치 있는 랜덤 문구
              Text(
                controller.message.value,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // 🔽 로딩 인디케이터
              const CircularProgressIndicator(strokeCap: StrokeCap.round),
            ],
          ),
        ),
      ),
    );
  }
}
