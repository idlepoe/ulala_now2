import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
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
  String _lastUrl = 'https://ulala-now2.web.app/splash';
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      throw UnsupportedError('웹에서는 SplashWebView를 사용할 수 없습니다.');
    }

    if (!(Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      throw UnsupportedError('SplashWebView는 데스크탑 플랫폼에서만 지원됩니다.');
    }

    _initWindowAndTray();
  }

  Future<void> _initWindowAndTray() async {
    try {
      windowManager.addListener(this);

      await trayManager.setContextMenu(
        Menu(
          items: [
            MenuItem(key: 'play', label: 'play'.tr),
            MenuItem(key: 'stop', label: 'stop'.tr),
            MenuItem(key: 'show', label: 'display'.tr),
            MenuItem(key: 'exit', label: 'close'.tr),
          ],
        ),
      );

      await trayManager.setToolTip('app_name'.tr);
      await trayManager.setIcon('assets/images/icon-removebg.ico');

      trayManager.addListener(this);
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'play':
        _unmute();
        break;
      case 'stop':
        _mute();
        break;
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

  void _mute() {
    setState(() {
      _isMuted = true;
    });
  }

  void _unmute() {
    setState(() {
      _isMuted = false;
    });
  }

  @override
  void onWindowClose() async {
    final isPrevented = await windowManager.isPreventClose();
    if (isPrevented) {
      await windowManager.hide();
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
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _isMuted
                      ? Center(
                        key: const ValueKey('muted'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'muted_message'.tr,
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _unmute,
                              child: Text('resume_play'.tr),
                            ),
                          ],
                        ),
                      )
                      : InAppWebView(
                        key: const ValueKey('webview'),
                        initialUrlRequest: URLRequest(url: _url),
                        onWebViewCreated: (controller) {
                          _webViewController = controller;
                        },
                      ),
            ),
            if (!_isMuted)
              Positioned(
                bottom: 90,
                left: 16,
                child: FloatingActionButton(
                  onPressed: _mute,
                  child: const Icon(Icons.volume_off),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
