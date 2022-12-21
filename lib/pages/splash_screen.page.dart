import 'package:e_discente/pages/login_page.dart';
import 'package:e_discente/pages/splash_carregamento_inicial.page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:e_discente/blocs/usuario.bloc.dart';
import 'package:e_discente/models/usuario.model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

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
      backgroundColor: const Color(0xFF0D294D),
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
            const SizedBox(
              height: 13,
            ),
            const Text(
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
    UsuarioModel? usuario = await UsuarioBloc().loadUsuario();
    await initializeDateFormatting('pt_Br', null);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SplashCarregamentoInicialPage()),
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPageN()));
    }
  }
}
