import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'pages/home_page.dart';
import 'services/config_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigService.instance.initialize();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    runApp(const GitSwitcherApp());
  });
}

class GitSwitcherApp extends StatefulWidget {
  const GitSwitcherApp({super.key});

  @override
  State<GitSwitcherApp> createState() => _GitSwitcherAppState();
}

class _GitSwitcherAppState extends State<GitSwitcherApp>
    with WindowListener, TrayListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    trayManager.addListener(this);
    windowManager.setPreventClose(true);
    _initTray();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  void _initTray() async {
    String iconPath = Platform.isWindows
        ? 'assets/img/app_icon.ico'
        : 'assets/img/app_icon.png';
    await trayManager.setIcon(iconPath);

    List<MenuItem> items = [
      MenuItem(key: 'about_app', label: '关于'),
      MenuItem.separator(),
      MenuItem(key: 'exit_app', label: '退出'),
    ];

    await trayManager.setContextMenu(Menu(items: items));
    trayManager.setToolTip('Git Switcher');

    await trayManager.setContextMenu(Menu(items: items));
    trayManager.setToolTip('Git Switcher');
  }

  void _showAboutDialog() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final uriGithub = Uri.parse('https://github.com/voidbytes/git-switcher');
    final uriHomepage = Uri.parse('http://voidbytes.com/');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('关于 Git Switcher'),
        content: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              const TextSpan(text: '作者: voidbytes\n'),
              const TextSpan(text: '作者主页:'),
              TextSpan(
                text: 'https://voidbytes.com\n',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(uriHomepage);
                  },
              ),
              const TextSpan(text: '项目地址:'),
              TextSpan(
                text: 'https://github.com/voidbytes/git-switcher',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(uriGithub);
                  },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Git账号切换器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.comfortable,
        fontFamily: "AlibabaPuHuiTi",
        fontFamilyFallback: ["AlibabaPuHuiTi"],
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.lightBlueAccent,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }

  @override
  void onWindowClose() {
    if (ConfigService.instance.appConfig.minimizeToTray) {
      windowManager.hide();
    } else {
      windowManager.destroy();
    }
  }

  @override
  void onTrayIconMouseDown() {
    if (Platform.isWindows) {
      windowManager.show();
    } else {
      trayManager.popUpContextMenu();
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    if (Platform.isWindows) {
      trayManager.popUpContextMenu();
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_window':
        windowManager.show();
        break;
      case 'about_app':
        windowManager.show();
        _showAboutDialog();
        break;
      case 'exit_app':
        windowManager.destroy();
        break;
    }
  }
}
