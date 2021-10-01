// @dart=2.9
import 'package:e_discente/repositories/register_fcmToken.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:e_discente/blocs/usuario.bloc.dart';
import 'package:e_discente/chat/app_instance.dart';
import 'package:e_discente/chat/services/socket-io.service.dart';
import 'package:e_discente/models/usuario.model.dart';

import '../settings.dart';
import 'inicio.page.dart';
import 'login.page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00396A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'icon_book',
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 45.0,
                child: Image.asset('assets/icon_init.png'),
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Text(
              'e-Discente',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.5,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  void _loadUser() async {
    UsuarioModel usuario = await UsuarioBloc().loadUsuario();
    await initializeDateFormatting('pt_Br', null);
    await Future.delayed(Duration(milliseconds: 1000));
    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InicioPage()),
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}
