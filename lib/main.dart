import 'package:flutter/material.dart';
import 'package:uni_discente/ui/splash_screen.ui.dart';


Future<void> main() async => runApp(MyApp());

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
         
      home: SplashPage()
    );
  }
}
