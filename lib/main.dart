
import 'package:flutter/material.dart';
import 'pages/splash_screen.page.dart';

const myTask = "syncWithTheBackEnd";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UniDiscente',
        theme: ThemeData(
            accentColor: Colors.teal[300],
            primaryColor: Color(0xFF00396A),
            backgroundColor: Colors.white),
        home: SplashPage());
  }
}
