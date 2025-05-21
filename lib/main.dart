import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:get/get.dart';

import 'app/data/constants/theme.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  setUrlStrategy(PathUrlStrategy()); // 해시 제거
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    FlutterWebFrame(
      builder:
          (context) => GetMaterialApp(
            title: "울랄라2",
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
            theme: AppTheme.light(),
          ),
      maximumSize: Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey.shade300,
    ),

  );
}
