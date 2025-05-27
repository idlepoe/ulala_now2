import 'dart:ffi' as fi;
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:win32/win32.dart' as win;
import 'package:window_manager/window_manager.dart';

import 'app/data/constants/app_translations.dart';
import 'app/data/constants/theme.dart';
import 'app/data/controllers/theme_controller.dart';
import 'app/data/utils/logger.dart';
import 'app/modules/session/widgets/mini_player_view.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

late final SimplePip pip;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  usePathUrlStrategy();
  await initializeDateFormatting('ko'); // ✅ 한국어 로케일 초기화
  final themeController = Get.put(ThemeController());
  await themeController.loadTheme();

  if (!kIsWeb && Platform.isWindows) {
    await windowManager.ensureInitialized();

    // 초기 사이즈 지정
    var initialSize = Size(475, 812);
    await windowManager.setSize(initialSize);
    await windowManager.setMinimumSize(initialSize);
    await windowManager.setMaximumSize(initialSize);
    await windowManager.setResizable(false);
    await windowManager.setTitle("울랄라: 음악 감상 커뮤니티");
    await windowManager.setIcon('assets/images/icon-removebg.ico');

    // 창 가운데로 이동
    await windowManager.center();

    windowManager.setPreventClose(true); // X 눌러도 닫히지 않게 설정

    win.CoInitializeEx(fi.nullptr, win.COINIT_APARTMENTTHREADED);
  }
  runApp(
    FlutterWebFrame(
      builder:
          (context) => GetMaterialApp(
            title: 'app_name'.tr,
            translations: AppTranslations(),
            // locale: Get.deviceLocale, // 기본 언어 (디바이스 설정 기준)
            locale: const Locale('ja', 'JP'), // 🔒 영어로 고정
            fallbackLocale: const Locale('en', 'US'), // 언어 없을 시 기본값
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.light(),
            darkTheme: AppThemes.dark(),
            themeMode: ThemeMode.system, // 또는 light / dark 강제 설정
          ),
      maximumSize: Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey.shade300,
    ),
  );
}
