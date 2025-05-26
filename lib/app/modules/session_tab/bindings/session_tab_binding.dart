import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/tab_track/controllers/tab_track_controller.dart';

import '../../session/controllers/chat_controller.dart';
import '../../session/controllers/session_controller.dart';
import '../../tab_chat/controllers/tab_chat_controller.dart';
import '../../tab_favorite/controllers/tab_favorite_controller.dart';
import '../../tab_search/controllers/tab_search_controller.dart';
import '../../tab_setting/controllers/tab_setting_controller.dart';

class SessionTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SessionController>(SessionController());
    Get.put<ChatController>(ChatController());

    // Get.lazyPut<TabChatController>(() => TabChatController());
    // Get.lazyPut<TabFavoriteController>(() => TabFavoriteController());
    // Get.lazyPut<TabSearchController>(() => TabSearchController());
    // Get.lazyPut<TabSettingController>(() => TabSettingController());
  }
}
