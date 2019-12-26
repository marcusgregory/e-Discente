import 'package:flutter/material.dart';
import 'package:uni_discente/ui/login.ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniDiscente',
      theme: ThemeData(
           accentColor: Colors.teal[300],
           primaryColor:Color(0xFF00396A),
           backgroundColor: Colors.white 
      ),
      home: LoginPage(title: 'Login'),
    );
  }
}

