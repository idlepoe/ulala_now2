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
    logger.i("🚀 [REQUEST] ${options.method} ${options.uri}");
    // logger.d("Headers: ${options.headers}");
    if (options.data != null) logger.d("Data: ${options.data}");

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final idToken = await user.getIdToken(true);

        if (idToken!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $idToken';
          // logger.i('Bearer $idToken');
        } else {
          logger.w("⚠️ Firebase ID Token is empty");
        }

        handler.next(options); // 유저 + 토큰 정상 → 계속 진행
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

  void _redirectToLogin() {
    // 기존 라우트 모두 제거하고 로그인 화면으로 이동
    if (g.Get.currentRoute != Routes.SPLASH) {
      g.Get.offAllNamed(Routes.SPLASH);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
      "✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}",
    );
    logger.d("Response Data: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    logger.e("❌ [ERROR] ${err.response?.statusCode} ${err.requestOptions.uri}");
    logger.e("Message: ${err.message}");
    logger.e("Error Data: ${err.response?.data}");

    // 🔥 401 Unauthorized 에러 처리 추가
    if (err.response?.statusCode == 401) {
      logger.w("⚠️ Unauthorized! Signing out...");
      // await FirebaseAuth.instance.signOut();
      // if (g.Get.currentRoute != Routes.LOGIN) {
      //   g.Get.offAllNamed(Routes.LOGIN); // 로그인 화면으로 보내기 (라우트는 네 앱에 맞게 수정)
      // }
    }

    super.onError(err, handler);
  }
}
