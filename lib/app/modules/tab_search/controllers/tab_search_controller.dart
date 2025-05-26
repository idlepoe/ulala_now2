import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulala_now2/app/modules/tab_track/controllers/tab_track_controller.dart';

import '../../../data/models/session_track.dart';
import '../../../data/utils/api_service.dart';
import '../../../data/utils/logger.dart';

class TabSearchController extends GetxController {
  final youtubeSearchResults = <SessionTrack>[].obs;
  final isSearching = false.obs;

  static const String _cacheKey = 'youtube_search_cache';

  static const _prefsKey = 'recent_search_keywords';
  final RxList<String> recentKeywords = <String>[].obs;

  final _prefSearchCooldownKey = 'searchCooldown'; // + uid
  final isSearchCooldown = false.obs;
  final remainingCooldown = Duration.zero.obs;

  Timer? _cooldownTimer;

  /// 유튜브 검색 → SessionTrack으로 관리 + 캐시 활용
  Future<void> searchYoutube(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty || isSearching.value) return;

    // 중복 제거 후 추가
    recentKeywords.remove(keyword);
    recentKeywords.insert(0, keyword);

    // 최대 10개 유지
    if (recentKeywords.length > 10) {
      recentKeywords.removeRange(10, recentKeywords.length);
    }

    _saveRecentKeywords(); // 저장

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);

    // ✅ 로컬 캐시 확인
    if (raw != null) {
      final prefs = await SharedPreferences.getInstance();
      final cachedMap = json.decode(raw) as Map<String, dynamic>;

      if (cachedMap.containsKey(trimmed)) {
        try {
          final cachedList =
              (cachedMap[trimmed] as List)
                  .map((e) => SessionTrack.fromJson(e))
                  .toList();

          youtubeSearchResults.value = cachedList;
          return;
        } catch (e) {
          logger.e("❌ 캐시 파싱 오류: $e");

          // 🔥 해당 키 삭제 후 캐시 저장
          cachedMap.remove(trimmed);
          await prefs.setString(_cacheKey, json.encode(cachedMap));

          logger.w("⚠️ 오류 발생한 키 [$trimmed] 캐시에서 제거함");
        }
      }
    }

    // 🌐 API 호출
    isSearching.value = true;
    final results = await ApiService.youtubeSearch(search: trimmed);
    isSearching.value = false;

    // ✅ 결과 저장 및 표시
    if (results.isNotEmpty) {
      youtubeSearchResults.value = results;

      final Map<String, dynamic> newMap = raw != null ? json.decode(raw) : {};

      newMap[trimmed] = results.map((e) => e.toJson()).toList();
      prefs.setString(_cacheKey, json.encode(newMap));

      // 검색 쿨타임 체크
      recordSearchTime();
      checkSearchCooldown();
    } else {
      youtubeSearchResults.clear();
    }
  }

  Future<void> _loadRecentKeywords() async {
    final prefs = await SharedPreferences.getInstance();
    final keywords = prefs.getStringList(_prefsKey) ?? [];
    recentKeywords.assignAll(keywords);
  }

  Future<void> _saveRecentKeywords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, recentKeywords);
  }

  Future<void> recordSearchTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefSearchCooldownKey,
      DateTime.now().toIso8601String(),
    );
  }


  Future<void> checkSearchCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _prefSearchCooldownKey;
    final savedTimeStr = prefs.getString(key);

    if (savedTimeStr == null) {
      isSearchCooldown.value = false;
      return;
    }

    final savedTime = DateTime.tryParse(savedTimeStr);
    if (savedTime == null) return;

    final now = DateTime.now();
    final diff = now.difference(savedTime);
    if (diff < const Duration(minutes: 5)) {
      final remaining = Duration(minutes: 5) - diff;
      isSearchCooldown.value = true;
      remainingCooldown.value = remaining;

      _cooldownTimer?.cancel();
      _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final newRemaining = remaining - Duration(seconds: timer.tick);
        if (newRemaining <= Duration.zero) {
          timer.cancel();
          isSearchCooldown.value = false;
          remainingCooldown.value = Duration.zero;
        } else {
          remainingCooldown.value = newRemaining;
        }
      });
    } else {
      isSearchCooldown.value = false;
    }
  }
}
