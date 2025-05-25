import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/session/bindings/session_binding.dart';
import '../modules/session/views/session_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/splash_web/bindings/splash_web_binding.dart';
import '../modules/splash_web/views/splash_web_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () {
        if (Platform.isWindows) {
          return const SplashWebView();
        } else {
          return const SplashView();
        }
      },
      binding: SplashBinding(),
    ),
    // GetPage(
    //   name: _Paths.SESSION,
    //   page: () => const SessionView(),
    //   binding: SessionBinding(),
    // ),
    GetPage(
      name: _Paths.SESSION + '/:sessionId',
      page: () => const SessionView(),
      binding: SessionBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_WEB,
      page: () => const SplashWebView(),
      binding: SplashWebBinding(),
    ),
  ];
}
