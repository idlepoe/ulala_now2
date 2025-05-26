import 'package:get/get.dart';

import '../controllers/tab_track_controller.dart';

class TabTrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabTrackController>(
      () => TabTrackController(),
    );
  }
}
