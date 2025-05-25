import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import '../../../data/utils/logger.dart';

class SplashWebView extends StatefulWidget {
  const SplashWebView({super.key});

  @override
  State<SplashWebView> createState() => _SplashWebViewState();
}

class _SplashWebViewState extends State<SplashWebView>
    with WindowListener, TrayListener {
  late InAppWebViewController _webViewController;
  final WebUri _url = WebUri.uri(
    Uri.parse('https://ulala-now2.web.app/splash'),
  );

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      throw UnsupportedError('웹에서는 SplashWebView를 사용할 수 없습니다.');
    }

    if (!(Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      throw UnsupportedError('SplashWebView는 데스크탑 플랫폼에서만 지원됩니다.');
    }

    // 트레이 및 윈도우 초기 설정
    _initWindowAndTray();
  }

  Future<void> _initWindowAndTray() async {
    try {
      windowManager.addListener(this);

      await trayManager.setContextMenu(
        Menu(
          items: [
            MenuItem(key: 'show', label: '표시'),
            MenuItem(key: 'exit', label: '닫기'),
          ],
        ),
      );

      await trayManager.setToolTip('울랄라 나우'); // 마우스 오버 텍스트
      await trayManager.setIcon(
        'assets/images/icon-removebg.ico', // 트레이 아이콘 경로
      );

      trayManager.addListener(this);
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'show':
        await windowManager.show();
        await windowManager.focus();
        break;
      case 'exit':
        trayManager.removeListener(this);
        windowManager.removeListener(this);
        await windowManager.destroy();
        break;
    }
  }

  @override
  void onWindowClose() async {
    final isPrevented = await windowManager.isPreventClose();
    if (isPrevented) {
      await windowManager.hide(); // 창 숨기기
    }
  }

  @override
  void onTrayIconMouseDown() async {
    if (Platform.isMacOS) {
      await trayManager.popUpContextMenu();
    } else {
      logger.d("windowManager.show()");
      await windowManager.show();
      await windowManager.focus();
    }
  }
  
  @override
  void onTrayIconRightMouseDown() {
    logger.d("onTrayIconRightMouseDown");
    trayManager.popUpContextMenu();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: _url),

          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
        ),
      ),
    );
  }
}
