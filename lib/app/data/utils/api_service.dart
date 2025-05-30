import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';
import '../models/added_by.dart';
import '../models/session.dart';
import '../models/session_track.dart';
import '../models/youtube/youtube_item.dart';
import 'app_utils.dart';
import 'dio.dart';
import 'logger.dart';

class ApiService {
  static Future<String> uploadFileToStorage({required XFile xFile}) async {
    logger.d(xFile.toString());

    String result = "";
    try {
      Reference reference = FirebaseStorage.instance.ref().child(
        "uploads/${DateTime.now().millisecondsSinceEpoch.toString()}_${xFile.name}",
      );
      await reference.putData(await xFile.readAsBytes());
      result = await reference.getDownloadURL();
      logger.d(result);
    } catch (e) {
      logger.e(e);
      logger.e(e.toString());
      return e.toString();
    }

    return result;
  }

  static Future<List<SessionTrack>> youtubeSearch({
    required String search,
  }) async {
    try {
      if (search.trim().isEmpty) {
        throw Exception('검색어를 입력해주세요.');
      }

      final response = await Dio().get(
        'https://www.googleapis.com/youtube/v3/search',
        queryParameters: {
          "q": search,
          "part": "snippet",
          "maxResults": "50",
          "key": "AIzaSyAeJOrIdbWb7Gg78f56tBBnJN-snpH2CIg",
          "order": "relevance",
        },
      );

      final user = FirebaseAuth.instance.currentUser;
      final now = DateTime.now();

      final List<SessionTrack> results = [];

      for (final item in response.data["items"]) {
        final videoId = item["id"]?["videoId"];
        final snippet = item["snippet"];

        if (videoId != null && snippet != null) {
          results.add(
            SessionTrack(
              id: videoId,
              videoId: videoId,
              title:
                  snippet["title"] == null
                      ? ""
                      : HtmlUnescape().convert(snippet["title"]),
              description:
                  snippet["description"] == null
                      ? ""
                      : HtmlUnescape().convert(snippet["description"]),
              thumbnail: snippet["thumbnails"]?["medium"]?["url"] ?? '',
              duration: 0,
              // ▶️ 추후 getYoutubeLength로 갱신
              startAt: now,
              endAt: now,
              createdAt: now,
              addedBy: AddedBy(
                uid: user?.uid ?? '',
                nickname: user?.displayName ?? '익명',
                avatarUrl: user?.photoURL ?? '',
              ),
            ),
          );
        }
      }

      return results;
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        logger.e('Status Code: $statusCode');
        logger.e('Response Data: $data');

        String message = '알 수 없는 오류가 발생했습니다.';

        final errorReason = data?['error']?['errors']?[0]?['reason'];
        if (errorReason == 'quotaExceeded') {
          message = 'YouTube API 사용 한도를 초과했습니다.\n잠시 후 다시 시도해주세요.';
        } else if (data?['error']?['message'] != null) {
          message = data['error']['message'];
        }

        Get.snackbar('오류', message);
      } else {
        Get.snackbar('오류', '네트워크 오류 또는 서버에 연결할 수 없습니다.');
      }
    } catch (e) {
      logger.e(e);
      Get.snackbar('오류', e.toString());
    }

    return [];
  }

  static const _key = 'favorite_youtube_ids';

  static Future<Set<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? {};
  }

  static Future<void> saveFavorites(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }

  static Future<int?> getYoutubeLength({required String videoId}) async {
    try {
      final response = await Dio().get(
        'https://youtube.googleapis.com/youtube/v3/videos?part=contentDetails&id=',
        queryParameters: {
          "part": "contentDetails",
          "id": videoId,
          "fields": "items(contentDetails(duration))",
          "key": "AIzaSyAeJOrIdbWb7Gg78f56tBBnJN-snpH2CIg",
        },
      );

      final isoDuration =
          response.data['items'][0]['contentDetails']['duration'];
      return AppUtils.convertTime(isoDuration); // ISO 8601 → 초 단위
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  /// ✅ 세션 생성
  static Future<Session> createSession(
    String name, {
    required bool isPrivate,
        required SessionMode mode, // ✅ 모드 추가
      }) async {
    final user = FirebaseAuth.instance.currentUser;
    final nickname = user?.displayName ?? "익명";
    final avatarUrl = user?.photoURL ?? "";

    final response = await dio.post(
      ApiConstants.createSession,
      data: {
        "name": name,
        "nickname": nickname,
        "avatarUrl": avatarUrl,
        "isPrivate": isPrivate,
        "mode": mode.name, // ✅ 문자열로 전달
      },
    );

    final data = response.data;
    if (data["success"] == true) {
      return Session.fromJson(data["data"]);
    } else {
      throw Exception(data["message"] ?? "세션 생성 실패");
    }
  }

  /// ✅ 세션 참여
  static Future<void> joinSession(String sessionId) async {
    final user = FirebaseAuth.instance.currentUser;
    final nickname = user?.displayName ?? "익명";
    final avatarUrl = user?.photoURL ?? "";

    final response = await dio.post(
      "${ApiConstants.baseUrl}${ApiConstants.joinSession}",
      data: {
        "sessionId": sessionId,
        "nickname": nickname,
        "avatarUrl": avatarUrl,
      },
    );

    final data = response.data;
    if (data["success"] != true) {
      throw Exception(data["message"] ?? "세션 참가 실패");
    }
  }

  /// ✅ 세션 나가기
  static Future<void> leaveSession(String sessionId) async {
    final response = await dio.post(
      "${ApiConstants.baseUrl}${ApiConstants.leaveSession}",
      data: {"sessionId": sessionId},
    );

    final data = response.data;
    if (data["success"] != true) {
      throw Exception(data["message"] ?? "세션 나가기 실패");
    }
  }

  /// ✅ 세션 목록 조회 (에러 시 빈 리스트)
  static Future<List<Session>> getSessionList() async {
    try {
      final response = await dio.get(
        "${ApiConstants.baseUrl}${ApiConstants.getSessionList}",
      );

      final data = response.data;
      if (data["success"] != true || data["data"] == null) {
        return []; // 실패 시 빈 리스트 반환
      }

      final List<dynamic> rawList = data["data"];
      return rawList.map((e) => Session.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// ✅ 특정 세션 조회 (에러 시 null)
  static Future<Session?> getSessionById(String sessionId) async {
    try {
      final response = await dio.get(
        ApiConstants.getSessionById,
        queryParameters: {"sessionId": sessionId},
      );

      final data = response.data;
      if (data["success"] != true || data["data"] == null) {
        return null; // 실패 시 null 반환
      }

      return Session.fromJson(data["data"]);
    } catch (e) {
      return null;
    }
  }

  /// ✅ 트랙 추가
  static Future<SessionTrack?> addTrack({
    required String sessionId,
    required SessionTrack track,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.addTrack,
        data: {"sessionId": sessionId, "track": track.toJson()},
      );

      final data = response.data;
      if (data["success"] == true && data["data"] != null) {
        return SessionTrack.fromJson(data["data"]);
      }
    } catch (_) {}
    return null;
  }

  /// ✅ 트랙 스킵
  static Future<bool> skipTrack({
    required String sessionId,
    required String trackId,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.skipTrack,
        data: {"sessionId": sessionId, "trackId": trackId},
      );

      final data = response.data;
      return data["success"] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<List<SessionTrack>> getPlayedTracks({
    required String sessionId,
    int limit = 20,
    DateTime? lastEndAt,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.getPlayedTracks,
        queryParameters: {
          'sessionId': sessionId,
          'limit': '$limit',
          if (lastEndAt != null) 'lastEndAt': lastEndAt.toIso8601String(),
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => SessionTrack.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('getPlayedTracks error: $e');
      return [];
    }
  }
}
