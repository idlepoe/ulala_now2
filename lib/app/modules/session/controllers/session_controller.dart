import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/session.dart';
import '../../../data/models/session_track.dart';
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
    loadFavorites();
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

  final youtubeSearchResults = <SessionTrack>[].obs;
  final isSearching = false.obs;

  static const String _cacheKey = 'youtube_search_cache';

  /// 유튜브 검색 → SessionTrack으로 관리 + 캐시 활용
  Future<void> searchYoutube(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);

    // ✅ 로컬 캐시 확인
    if (raw != null) {
      final cachedMap = json.decode(raw) as Map<String, dynamic>;
      if (cachedMap.containsKey(trimmed)) {
        final cachedList = (cachedMap[trimmed] as List)
            .map((e) => SessionTrack.fromJson(e))
            .toList();
        youtubeSearchResults.value = cachedList;
        return;
      }
    }

    // 🌐 API 호출
    isSearching.value = true;
    final results = await ApiService.youtubeSearch(search: trimmed);
    isSearching.value = false;

    // ✅ 결과 저장 및 표시
    if (results.isNotEmpty) {
      youtubeSearchResults.value = results;

      final Map<String, dynamic> newMap =
      raw != null ? json.decode(raw) : {};

      newMap[trimmed] = results.map((e) => e.toJson()).toList();
      prefs.setString(_cacheKey, json.encode(newMap));
    } else {
      youtubeSearchResults.clear();
    }
  }

  attachDuration(SessionTrack track) {}

  addTrack(fullTrack) {}

  static const String _favoriteKey = 'favorite_tracks';

  final favorites = <String, SessionTrack>{}.obs; // key = videoId

  /// 즐겨찾기 초기 로딩 (앱 시작 또는 view 진입 시)
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_favoriteKey);

    if (raw == null) return;

    final Map<String, dynamic> map = json.decode(raw);
    favorites.value = {
      for (var entry in map.entries)
        entry.key: SessionTrack.fromJson(json.decode(entry.value))
    };
  }

  /// 즐겨찾기 추가/제거
  Future<void> toggleFavorite(SessionTrack track) async {
    final prefs = await SharedPreferences.getInstance();

    final updated = Map<String, SessionTrack>.from(favorites);
    if (updated.containsKey(track.videoId)) {
      updated.remove(track.videoId);
      Get.snackbar('즐겨찾기', '즐겨찾기에서 제거됨');
    } else {
      updated[track.videoId] = track;
      Get.snackbar('즐겨찾기', '즐겨찾기에 추가됨');
    }

    // 저장
    final encoded = {
      for (var entry in updated.entries)
        entry.key: json.encode(entry.value.toJson())
    };
    await prefs.setString(_favoriteKey, json.encode(encoded));
    favorites.value = updated;
  }

  /// 즐겨찾기 여부 확인
  bool isFavorite(String videoId) => favorites.containsKey(videoId);

}
