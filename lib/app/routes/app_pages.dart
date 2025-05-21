import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/session/bindings/session_binding.dart';
import '../modules/session/views/session_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

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
      page: () => const SplashView(),
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
  ];
}
