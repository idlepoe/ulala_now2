import 'package:get/get.dart';

import '../controllers/tab_search_controller.dart';

class TabSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabSearchController>(
      () => TabSearchController(),
    );
  }
}
