import 'package:flutter/material.dart';
import 'package:uni_discente/background_fetch_settings.dart';
import 'package:uni_discente/notification_settings.dart';
import 'pages/splash_screen.page.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;
  const MyApp({Key key, this.savedThemeMode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
            accentColor: Colors.teal[300],
            primaryColor: Color(0xFF00396A),
            backgroundColor: Colors.white),
        dark: ThemeData.dark(),
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
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
  initNotification();
  initBackgroundFetch();
}
