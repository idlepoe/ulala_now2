import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../data/models/chat_message.dart';
import '../../../data/models/session.dart';
import '../../../data/models/session_participant.dart';
import '../../../data/models/session_track.dart';
import '../../../data/models/youtube/youtube_item.dart';
import '../../../data/utils/api_service.dart';
import '../../../data/utils/logger.dart';
import '../../../routes/app_pages.dart';
import '../widgets/track_search_bottom_sheet.dart';
import 'chat_controller.dart';

class SessionController extends GetxController {
  final session = Rxn<Session>();
  late final String sessionId;

  late YoutubePlayerController youtubeController;
  StreamSubscription? _trackSub;
  final currentTracks = <SessionTrack>[].obs;
  final currentPlayerState = Rx<PlayerState>(PlayerState.unknown);

  final currentTime = DateTime.now().obs;

  void onSessionLoaded() {
    Get.find<ChatController>().startListening(sessionId);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    sessionId = Get.parameters['sessionId']!;
    if (sessionId.isEmpty) {
      _handleInvalidSession();
      return;
    }

    await fetchSession();
    loadFavorites();
    onSessionLoaded();
    _loadRecentKeywords();
    checkSearchCooldown();

    youtubeController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
      ),
    );

    // 1초마다 상태 체크
    Timer.periodic(const Duration(seconds: 1), (_) async {
      final state = await youtubeController.playerState;
      currentPlayerState.value = state;
      currentTime.value = DateTime.now(); // 매초 갱신
    });

    _subscribeToTracks();
  }

  void _handleInvalidSession() async {
    Get.snackbar("오류", "세션 정보를 불러올 수 없습니다.");
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionId');
    Get.offAllNamed(Routes.SPLASH);
  }

  Future<void> fetchSession() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
    final user = FirebaseAuth.instance.currentUser;

    final data = await ApiService.getSessionById(sessionId);

    if (data != null) {
      final alreadyJoined = data.participants.any((p) => p.uid == user!.uid);

      // ✅ 아직 참여하지 않은 경우 자동 참가 처리
      if (!alreadyJoined) {
        await ApiService.joinSession(sessionId);

        // 참가 이후 정보 다시 불러오기
        final updated = await ApiService.getSessionById(sessionId);
        session.value = updated;
      } else {
        session.value = data;
      }
    } else {
      _handleInvalidSession();
    }
  }

  final youtubeSearchResults = <SessionTrack>[].obs;
  final isSearching = false.obs;

  static const String _cacheKey = 'youtube_search_cache';

  static const _prefsKey = 'recent_search_keywords';
  final RxList<String> recentKeywords = <String>[].obs;

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

  static const _durationCacheKey = 'youtube_duration_cache';

  Future<void> attachDurationAndAddTrack(SessionTrack track) async {
    if (track.duration > 0) {
      await addTrack(track);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_durationCacheKey);
    final Map<String, dynamic> cache = raw != null ? json.decode(raw) : {};

    int? duration = cache[track.videoId];

    if (duration == null) {
      // 📡 YouTube API 호출
      duration = await ApiService.getYoutubeLength(videoId: track.videoId);

      if (duration == null) {
        Get.snackbar('오류', '영상 길이 조회에 실패했습니다.');
        return;
      }

      // 🧠 SharedPreferences에 저장
      cache[track.videoId] = duration;
      await prefs.setString(_durationCacheKey, json.encode(cache));
    }

    final fullTrack = track.copyWith(duration: duration);
    await addTrack(fullTrack);
  }

  Future<void> addTrack(SessionTrack track) async {
    final response = await ApiService.addTrack(
      sessionId: session.value!.id,
      track: track,
    );
    logger.w(response);

    if (response != null) {
      // 0.5초 후에 BottomSheet 닫기
      Get.back(result: true);
    } else {
      Get.snackbar('오류', '트랙 추가에 실패했습니다.');
    }
  }

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
        entry.key: SessionTrack.fromJson(json.decode(entry.value)),
    };
  }

  /// 즐겨찾기 추가/제거
  Future<void> toggleFavorite(SessionTrack track) async {
    final prefs = await SharedPreferences.getInstance();

    final updated = Map<String, SessionTrack>.from(favorites);
    if (updated.containsKey(track.videoId)) {
      updated.remove(track.videoId);
      if (!Get.isSnackbarOpen) Get.snackbar('즐겨찾기', '즐겨찾기에서 제거됨');
    } else {
      updated[track.videoId] = track;
      if (!Get.isSnackbarOpen) Get.snackbar('즐겨찾기', '즐겨찾기에 추가됨');
    }

    // 저장
    final encoded = {
      for (var entry in updated.entries)
        entry.key: json.encode(entry.value.toJson()),
    };
    await prefs.setString(_favoriteKey, json.encode(encoded));
    favorites.value = updated;
  }

  /// 즐겨찾기 여부 확인
  bool isFavorite(String videoId) => favorites.containsKey(videoId);

  void _subscribeToTracks() {
    _trackSub?.cancel();

    _trackSub = FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .collection('tracks')
        .orderBy('startAt', descending: false)
        .snapshots()
        .listen((snapshot) {
          final newTracks =
              snapshot.docs
                  .map((e) => SessionTrack.fromJson(e.data()))
                  .toList();

          if (_areTracksEqual(currentTracks, newTracks)) return;

          currentTracks.assignAll(newTracks);
          session.value = session.value?.copyWith(trackList: newTracks);
          _syncWithYoutubePlayer(newTracks);
        });
  }

  bool _areTracksEqual(List<SessionTrack> a, List<SessionTrack> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id ||
          a[i].startAt != b[i].startAt ||
          a[i].endAt != b[i].endAt) {
        return false;
      }
    }
    return true;
  }

  Future<void> _syncWithYoutubePlayer(List<SessionTrack> tracks) async {
    logger.i("_syncWithYoutubePlayer");
    logger.i(tracks);
    final now = DateTime.now();
    final current = tracks.firstWhereOrNull((track) {
      final isStream = track.duration == 0 && track.startAt == track.endAt;

      if (isStream) {
        // stream 트랙은 startAt 이후면 항상 현재 재생 중으로 간주
        return now.isAfter(track.startAt);
      } else {
        final end = track.startAt.add(Duration(seconds: track.duration));
        return now.isAfter(track.startAt) && now.isBefore(end);
      }
    });

    logger.w("11111111111");
    if (current == null) return;

    logger.w("2222222");
    final offset =
        now
            .difference(current.startAt)
            .inSeconds
            .clamp(0, current.duration)
            .toDouble();

    final upcoming =
        tracks.where((t) => t.endAt.isAfter(now) || t == current).toList()
          ..sort((a, b) => a.startAt.compareTo(b.startAt));

    if (upcoming.length == 1) {
      logger.w("3333333");
      await youtubeController.loadVideoById(
        videoId: current.videoId,
        startSeconds: offset,
      );
    } else {
      logger.w("44444444");
      final ids = upcoming.map((e) => e.videoId).toList();
      final index = upcoming.indexOf(current);

      await youtubeController.loadPlaylist(
        list: ids,
        listType: ListType.playlist,
        index: index,
        startSeconds: offset,
      );
    }

    logger.w("5555555555");
    // 플레이 강제 재생
    Future.delayed(const Duration(seconds: 1), () async {
      final state = await youtubeController.playerState;
      logger.w(state);
      if (state != PlayerState.playing) {
        youtubeController.playVideo();
        logger.w("66666666666");
      }
    });
  }

  @override
  void onClose() {
    _trackSub?.cancel();
    youtubeController.close();
    super.onClose();
  }

  Future<void> sync() async {
    // youtubeController = YoutubePlayerController(
    //   params: const YoutubePlayerParams(
    //     showControls: true,
    //     showFullscreenButton: false,
    //   ),
    // );
    // var result =
    //     await FirebaseFirestore.instance
    //         .collection('sessions')
    //         .doc(sessionId)
    //         .collection('tracks')
    //         .orderBy('startAt', descending: false)
    //         .get();
    // logger.d(result);
    // youtubeController.close();
    // currentTracks.clear();
    fetchSession();
    _syncWithYoutubePlayer(currentTracks);
    triggerPlayerRefresh(); // ✅ 리렌더링 유도
    // _syncWithYoutubePlayer(currentTracks);
    // logger.d(currentTracks);
    // logger.d(await youtubeController.playerState);
    // youtubeController.playVideo();
  }

  final playerRefreshTrigger = 0.obs;

  void triggerPlayerRefresh() {
    playerRefreshTrigger.value++; // 값 변경 시 Obx 감지
  }

  Future<void> openTrackSearchSheet() async {
    final result = await Get.bottomSheet(
      const TrackSearchBottomSheet(),
      isScrollControlled: true,
    );
    if (result == true) {
      sync(); // ✅ 성공한 경우만 새로고침
    }
  }

  final selectedFavoriteId = RxnString(); // Rx<String?>
  void toggleSelectedFavorite(String videoId) {
    logger.i("toggleSelectedFavorite");
    selectedFavoriteId.value =
        selectedFavoriteId.value == videoId ? null : videoId;
  }

  final _searchCooldownKeyPrefix = 'searchCooldown'; // + uid
  final isSearchCooldown = false.obs;
  final remainingCooldown = Duration.zero.obs;

  Timer? _cooldownTimer;

  Future<void> checkSearchCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _searchCooldownKeyPrefix;
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

  Future<void> recordSearchTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _searchCooldownKeyPrefix,
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> leaveSession() async {
    final confirm = await showDialog<bool>(
      context: Get.context!,
      builder:
          (context) => AlertDialog(
            title: const Text('세션 나가기'),
            content: const Text('정말로 이 세션에서 나가시겠습니까?'),
            actions: [
              TextButton(
                child: const Text('취소'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text('나가기', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('sessionId');

      await ApiService.leaveSession(sessionId);

      Get.offAllNamed(Routes.SPLASH);
    } catch (e) {
      Get.snackbar('오류', '세션 나가기 중 문제가 발생했습니다.');
    }
  }

  final noTrackMessages = [
    // "지금은 무음 모드입니다. 첫 번째 트랙을 추가해보세요 🎶",
    // "우주가 고요합니다... 첫 음악을 울려 퍼지게 해주세요 🌌",
    // "스피커가 심심해하고 있어요. 들려줄 노래가 필요해요!",
    "별빛이 고요하네요... 누군가 음악을 틀어줄 시간이에요.",
    // "은하수에 음악이 비었어요. 첫 곡을 채워주세요 ⭐",
    // "지금은 정적 타임... 음악 한 곡 어때요?",
  ];

  String? getDjUid(List<SessionParticipant> participants) {
    if (participants.isEmpty) return null;

    final sorted =
        participants.toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return sorted.first.uid;
  }

  bool canControlTrack({SessionParticipant? participants}) {
    if (session.value!.mode != SessionMode.dj) return true;

    final djUid = getDjUid(session.value!.participants);
    return djUid ==
        (participants == null
            ? FirebaseAuth.instance.currentUser!.uid
            : participants.uid);
  }
}
