// @dart=2.9
import 'dart:io';

import 'package:e_discente/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_discente/background_fetch_settings.dart';
import 'package:e_discente/notification_settings2.dart';
import 'package:flutter/services.dart';
import 'pages/splash_screen.page.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;
  const MyApp({Key key, this.savedThemeMode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Color(0xFF00396A),
            secondary: Colors.blue,
            background: Colors.white,
          ),
        ),
        dark: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
                primary: ThemeData.dark().colorScheme.secondary)),
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'e-Discente',
            theme: theme,
            darkTheme: darkTheme,
            home: SplashPage()));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      NotificationAwesome.initNotificationAweSome();
      initBackgroundFetch();
      initFirebaseMessaging();
    }
  }
}
