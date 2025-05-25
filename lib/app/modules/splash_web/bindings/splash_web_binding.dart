import 'package:get/get.dart';

import '../controllers/splash_web_controller.dart';

class SplashWebBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashWebController>(
      () => SplashWebController(),
    );
  }
}
