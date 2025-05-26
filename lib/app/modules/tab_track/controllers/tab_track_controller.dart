import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../data/models/session.dart';
import '../../../data/models/session_participant.dart';
import '../../../data/models/session_track.dart';
import '../../../data/utils/api_service.dart';
import '../../../data/utils/logger.dart';
import '../../../routes/app_pages.dart';

class TabTrackController extends GetxController {
  final RxInt currentIndex = 0.obs;
  late final PageController pageController;


  final session = Rxn<Session>();
  late final String sessionId;

  late YoutubePlayerController youtubeController;
  StreamSubscription? _trackSub;
  final currentTracks = <SessionTrack>[].obs;
  final currentPlayerState = Rx<PlayerState>(PlayerState.unknown);

  final currentTime = DateTime.now().obs;

  final favorites = <String, SessionTrack>{}.obs; // key = videoId

  final noTrackMessages = [
    // "지금은 무음 모드입니다. 첫 번째 트랙을 추가해보세요 🎶",
    // "우주가 고요합니다... 첫 음악을 울려 퍼지게 해주세요 🌌",
    // "스피커가 심심해하고 있어요. 들려줄 노래가 필요해요!",
    "별빛이 고요하네요... 누군가 음악을 틀어줄 시간이에요.",
    // "은하수에 음악이 비었어요. 첫 곡을 채워주세요 ⭐",
    // "지금은 정적 타임... 음악 한 곡 어때요?",
  ];

  static const String _favoriteKey = 'favorite_tracks';

  static const _durationCacheKey = 'youtube_duration_cache';

  @override
  Future<void> onInit() async {
    pageController = PageController(initialPage: currentIndex.value);
    youtubeController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
      ),
    );
    super.onInit();
    sessionId = Get.parameters['sessionId']!;
    if (sessionId.isEmpty) {
      _handleInvalidSession();
      return;
    }

    await fetchSession();
    loadFavorites();


    // 1초마다 상태 체크
    Timer.periodic(const Duration(seconds: 1), (_) async {
      final state = await youtubeController.playerState;
      currentPlayerState.value = state;
      currentTime.value = DateTime.now(); // 매초 갱신
    });

    _subscribeToTracks();
  }

  void changeTab(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
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

  void _handleInvalidSession() async {
    Get.snackbar("오류", "세션 정보를 불러올 수 없습니다.");
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionId');
    Get.offAllNamed(Routes.SPLASH);
  }

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

    if (current == null) return;

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
      await youtubeController.loadVideoById(
        videoId: current.videoId,
        startSeconds: offset,
      );
    } else {
      final ids = upcoming.map((e) => e.videoId).toList();
      final index = upcoming.indexOf(current);

      await youtubeController.loadPlaylist(
        list: ids,
        listType: ListType.playlist,
        index: index,
        startSeconds: offset,
      );
    }

    // 플레이 강제 재생
    Future.delayed(const Duration(seconds: 1), () async {
      final state = await youtubeController.playerState;
      logger.w(state);
      if (state != PlayerState.playing) {
        youtubeController.playVideo();
      }
    });
  }

  bool isFavorite(String videoId) => favorites.containsKey(videoId);

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

  final selectedFavoriteId = RxnString(); // Rx<String?>
  void toggleSelectedFavorite(String videoId) {
    logger.i("toggleSelectedFavorite");
    selectedFavoriteId.value =
    selectedFavoriteId.value == videoId ? null : videoId;
  }

  bool canControlTrack({SessionParticipant? participants}) {
    if (session.value!.mode != SessionMode.dj) return true;

    final djUid = getDjUid(session.value!.participants);
    return djUid ==
        (participants == null
            ? FirebaseAuth.instance.currentUser!.uid
            : participants.uid);
  }

  String? getDjUid(List<SessionParticipant> participants) {
    if (participants.isEmpty) return null;

    final sorted =
    participants.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return sorted.first.uid;
  }

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

  Future<void> sync() async {
    fetchSession();
    _syncWithYoutubePlayer(currentTracks);
  }
}
