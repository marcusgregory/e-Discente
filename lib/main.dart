import 'package:flutter/material.dart';
import 'package:uni_discente/blocs/usuario.bloc.dart';
import 'package:uni_discente/ui/login.ui.dart';
import 'package:uni_discente/ui/splash_screen.ui.dart';

import 'models/usuario.model.dart';
import 'ui/inicio.ui.dart';

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
      home: FutureBuilder<UsuarioModel>(
          future: UsuarioBloc().loadUsuario(),
          builder:
              (BuildContext context, AsyncSnapshot<UsuarioModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashPage();
            }

            if (snapshot.hasData) {
              
              if (snapshot.data != null) {
                return InicioPage();
              } else {
                return LoginPage();
              } 
            }
            return LoginPage();
          }),
    );
  }
}
