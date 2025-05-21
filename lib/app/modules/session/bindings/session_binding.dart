import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import '../controllers/session_controller.dart';

class SessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionController>(
      () => SessionController(),
    );
    Get.put(ChatController());
  }
}
