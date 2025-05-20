import 'package:get/get.dart';

import '../../../data/models/session.dart';
import '../../../data/models/youtube/youtube_item.dart';
import '../../../data/utils/api_service.dart';

class SessionController extends GetxController {
  final session = Rxn<Session>();

  late final String sessionId;

  @override
  void onInit() {
    super.onInit();
    sessionId = Get.arguments as String;
    fetchSession();
  }

  Future<void> fetchSession() async {
    final data = await ApiService.getSessionById(sessionId);
    if (data != null) {
      session.value = data;
    } else {
      Get.snackbar("오류", "세션 정보를 불러올 수 없습니다.");
      Get.offAllNamed("/home");
    }
  }

  final youtubeSearchResults = <YoutubeItem>[].obs;
  final isSearching = false.obs;

  Future<void> searchYoutube(String keyword) async {
    isSearching.value = true;
    final result = await ApiService.youtubeSearch(search: keyword);
    youtubeSearchResults.value = result ?? [];
    isSearching.value = false;
  }

}
