import 'package:e_discente/blocs/login.bloc.dart';
import 'package:e_discente/pages/splash_carregamento_inicial.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/autenticacao.model.dart';
import '../util/toast.util.dart';

class LoginPageN extends StatefulWidget {
  const LoginPageN({Key? key}) : super(key: key);

  @override
  State<LoginPageN> createState() => _LoginPageNState();
}

class _LoginPageNState extends State<LoginPageN> {
  late LoginBloc loginBloc;
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void initState() {
    loginBloc = LoginBloc();
    loginBloc.stream.listen((event) {
      if (event is LoginErrorState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(event.message)));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D294D),
      body: SafeArea(
        child: Stack(
            alignment: Alignment.bottomCenter,
            children: [_header(context), _body(context)]),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFF0D294D),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          SvgPicture.asset('assets/svgs/book_white.svg',
              semanticsLabel: 'e-Discente Logo', height: 90),
          const SizedBox(
            height: 2,
          ),
          Text(
            'e-Discente',
            style: GoogleFonts.darkerGrotesque(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .67,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 35, right: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Material(
                elevation: 15,
                shadowColor: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: TextFormField(
                    controller: _usuarioController,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.bottom,
                    autofocus: false,

                    //  initialValue: '',
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.darkerGrotesque(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      hintText: 'Usuário',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            SizedBox(
              height: 50,
              child: Material(
                shadowColor: Colors.black,
                elevation: 15,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.bottom,
                    autofocus: false,
                    //  initialValue: '',
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.darkerGrotesque(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      hintText: 'Senha',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.lock,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            SizedBox(
              height: 50,
              child: Material(
                elevation: 15,
                shadowColor: Colors.black,
                child: StreamBuilder<LoginState>(
                    stream: loginBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data is LoginInitialState) {
                        return _loginButton();
                      }
                      if (snapshot.data is LoginLoadingState) {
                        return _loginButton(loading: true);
                      }
                      if (snapshot.data is LoginErrorState) {
                        return _loginButton();
                      }
                      if (snapshot.data is LoginSucessState) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _nextPage();
                        });
                        return _loginButton();
                      }
                      return _loginButton();
                    }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            esqueceuSenha(),
          ],
        ),
      ),
    );
  }

  Widget esqueceuSenha() {
    return TextButton(
      child: Text(
        'Esqueceu sua senha?',
        style: GoogleFonts.darkerGrotesque(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 18,
            fontWeight: FontWeight.w700),
      ),
      onPressed: () {
        _launchURL();
      },
    );
  }

  Widget _loginButton({bool loading = false}) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF0D294D)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ))),
        onPressed: loading
            ? null
            : () {
                loginBloc.inputLogin.add(AuthenticationEvent(
                    auth: AutenticacaoModel(
                        usuario: _usuarioController.text,
                        senha: _senhaController.text)));
              },
        child: Center(
            child: loading
                ? SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          ThemeData.light().canvasColor),
                      strokeWidth: 3.0,
                    ))
                : Text('Entrar',
                    style: GoogleFonts.darkerGrotesque(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700))));
  }

  _nextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const SplashCarregamentoInicialPage()),
    );
  }

  _launchURL() async {
    const url =
        'https://sigadmin.unilab.edu.br/admin/public/recuperar_senha.jsf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.showShortToast('Não foi possível abrir a url: $url');
    }
  }
}
