import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' as g;
import 'package:logger/logger.dart';

import '../../routes/app_pages.dart';
import 'logger.dart';

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // logger.i("🚀 [REQUEST] ${options.method} ${options.uri}");

    // ✅ 요청 시작 시간 기록
    options.extra['startTime'] = DateTime.now();

    if (options.data != null) logger.d("Data: ${options.data}");

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final idToken = await user.getIdToken(true);
        if (idToken!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $idToken';
        } else {
          logger.w("⚠️ Firebase ID Token is empty");
        }

        handler.next(options);
      } else {
        logger.w("❌ 로그인 안 된 사용자 요청 차단");
        _redirectToLogin();
        handler.reject(
          DioException(
            requestOptions: options,
            error: 'User not authenticated',
            type: DioExceptionType.cancel,
          ),
        );
      }
    } catch (e) {
      logger.e("❌ Firebase 인증 처리 중 오류: $e");
      _redirectToLogin();
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Firebase auth token error',
          type: DioExceptionType.cancel,
        ),
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final request = response.requestOptions;
    final startTime = request.extra['startTime'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;

    final method = request.method;
    final uri = request.uri.toString();

    // 🔍 쿼리 파라미터나 body를 같이 표시
    final params = request.queryParameters.isNotEmpty
        ? 'query: ${request.queryParameters}'
        : (request.data != null ? 'body: ${request.data}' : '');

    // 🪵 통합 로깅
    // 🔍 응답 데이터 요약
    String shortResponse = '';
    try {
      final raw = response.data.toString();
      shortResponse = raw.length > 500 ? '${raw.substring(0, 500)}...' : raw;
    } catch (_) {
      shortResponse = 'Non-printable response';
    }

    logger.i("✅ [$method] $uri ($duration ms) \n$params\n↩️ $shortResponse");

    // logger.d("Response Data: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final request = err.requestOptions;
    final startTime = request.extra['startTime'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;

    final method = request.method;
    final uri = request.uri.toString();

    final params = request.queryParameters.isNotEmpty
        ? 'query: ${request.queryParameters}'
        : (request.data != null ? 'body: ${request.data}' : '');

    logger.e("❌ [$method] $uri (${err.response?.statusCode ?? 'ERR'}) ($duration ms) $params");
    logger.e("Message: ${err.message}");
    logger.e("Error Data: ${err.response?.data}");

    super.onError(err, handler);
  }

  void _redirectToLogin() {
    if (g.Get.currentRoute != Routes.SPLASH) {
      g.Get.offAllNamed(Routes.SPLASH);
    }
  }
}
