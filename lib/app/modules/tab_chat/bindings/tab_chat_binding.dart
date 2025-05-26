import 'package:get/get.dart';

import '../controllers/tab_chat_controller.dart';

class TabChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabChatController>(
      () => TabChatController(),
    );
  }
}
