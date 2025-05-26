import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/session/bindings/session_binding.dart';
import '../modules/session/views/session_view.dart';
import '../modules/session_tab/bindings/session_tab_binding.dart';
import '../modules/session_tab/views/session_tab_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/splash_web/bindings/splash_web_binding.dart';
import '../modules/splash_web/views/splash_web_view.dart';
import '../modules/tab_chat/bindings/tab_chat_binding.dart';
import '../modules/tab_chat/views/tab_chat_view.dart';
import '../modules/tab_favorite/bindings/tab_favorite_binding.dart';
import '../modules/tab_favorite/views/tab_favorite_view.dart';
import '../modules/tab_search/bindings/tab_search_binding.dart';
import '../modules/tab_search/views/tab_search_view.dart';
import '../modules/tab_setting/bindings/tab_setting_binding.dart';
import '../modules/tab_setting/views/tab_setting_view.dart';
import '../modules/tab_track/bindings/tab_track_binding.dart';
import '../modules/tab_track/views/tab_track_view.dart';

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
      page: () => const SessionTabView(),
      binding: SessionTabBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_WEB,
      page: () => const SplashWebView(),
      binding: SplashWebBinding(),
    ),
    GetPage(
      name: _Paths.SESSION_TAB,
      page: () => const SessionTabView(),
      binding: SessionTabBinding(),
    ),
    GetPage(
      name: _Paths.TAB_TRACK,
      page: () => const TabTrackView(),
      binding: TabTrackBinding(),
    ),
    GetPage(
      name: _Paths.TAB_SEARCH,
      page: () => const TabSearchView(),
      binding: TabSearchBinding(),
    ),
    GetPage(
      name: _Paths.TAB_FAVORITE,
      page: () => const TabFavoriteView(),
      binding: TabFavoriteBinding(),
    ),
    GetPage(
      name: _Paths.TAB_CHAT,
      page: () => const TabChatView(),
      binding: TabChatBinding(),
    ),
    GetPage(
      name: _Paths.TAB_SETTING,
      page: () => const TabSettingView(),
      binding: TabSettingBinding(),
    ),
  ];
}
