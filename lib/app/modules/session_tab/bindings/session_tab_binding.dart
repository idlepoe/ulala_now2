import 'package:get/get.dart';

import '../../session/controllers/chat_controller.dart';
import '../../session/controllers/session_controller.dart';

class SessionTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SessionController>(SessionController());
    Get.put<ChatController>(ChatController());
  }
}
