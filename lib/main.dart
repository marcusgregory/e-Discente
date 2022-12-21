import 'dart:io';

import 'package:e_discente/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_discente/background_fetch_settings.dart';
import 'package:e_discente/notification_settings2.dart';
import 'package:flutter/services.dart';
import 'pages/splash_screen.page.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF0D294D),
                    primary: const Color(0xFF0D294D),
                    secondary: Colors.blue),
                useMaterial3: false)
            .copyWith(primaryColor: const Color(0xFF0D294D)),
        dark: ThemeData(
            colorSchemeSeed: const Color(0xFF0D294D),
            useMaterial3: true,
            brightness: Brightness.dark),
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
            navigatorKey: MyApp.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'e-Discente',
            theme: theme,
            darkTheme: darkTheme,
            home: const SplashPage()));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  initialize();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

void initialize() {
  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      NotificationAwesome.initNotificationAwesome();
      initBackgroundFetch();
      initFirebaseMessaging();
    }
  }
}
