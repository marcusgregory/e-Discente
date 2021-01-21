import 'package:flutter/material.dart';
import 'package:uni_discente/background_fetch_settings.dart';
import 'package:uni_discente/notification_settings.dart';
import 'pages/splash_screen.page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'e-Discente',
        theme: ThemeData(
            accentColor: Colors.teal[300],
            primaryColor: Color(0xFF00396A),
            backgroundColor: Colors.white),
        home: SplashPage());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  initNotification();
  initBackgroundFetch();
}
