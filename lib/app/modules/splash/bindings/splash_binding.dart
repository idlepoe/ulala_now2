import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    if (!kIsWeb && Platform.isWindows) {
      return;
    }
    Get.put<SplashController>(SplashController());
  }
}
