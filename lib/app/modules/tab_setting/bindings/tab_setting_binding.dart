import 'package:get/get.dart';

import '../controllers/tab_setting_controller.dart';

class TabSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabSettingController>(
      () => TabSettingController(),
    );
  }
}
