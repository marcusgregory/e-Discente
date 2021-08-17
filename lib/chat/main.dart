import 'package:flutter/material.dart';
import 'pages/chats.page.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(primaryColor: Colors.blue[900]),
      home: ChatsPage(),
    );
  }
}
