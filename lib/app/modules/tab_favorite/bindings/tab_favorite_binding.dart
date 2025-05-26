import 'package:get/get.dart';

import '../controllers/tab_favorite_controller.dart';

class TabFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabFavoriteController>(
      () => TabFavoriteController(),
    );
  }
}
