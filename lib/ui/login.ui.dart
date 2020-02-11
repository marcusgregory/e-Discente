import 'package:flutter/material.dart';
import 'package:uni_discente/blocs/usuario.bloc.dart';
import 'package:uni_discente/models/autenticacao.model.dart';
import 'package:uni_discente/models/usuario.model.dart';
import 'package:uni_discente/util/toast.util.dart';
import 'package:url_launcher/url_launcher.dart';

import 'inicio.ui.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ScrollController _scrollController = new ScrollController();

  TextEditingController _txtController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  bool _isLogging = false;
  UsuarioBloc bloc = new UsuarioBloc();

  @override
  initState() {
    super.initState();
  }

  _nextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InicioPage()),
    );
  }

  _launchURL() async {
    const url =
        'https://sigadmin.unilab.edu.br/admin/public/recuperar_senha.jsf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.showToast('Não foi possível abrir a url: $url');
    }
  }

  Padding loginButton(bool progressIndicator) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          setState(() {
            _isLogging = true;
          });
          //Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(13),
        color: Color(0xff1a4972),
        child: progressIndicator
            ? SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3.0,
                ))
            : Text('Entrar',
                style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _onWidgetDidBuild(Function callback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        callback();
      });
    }

    _txtController.addListener(() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    });
    final logo = Hero(
      tag: 'icon_book',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 55.0,
        child: Image.asset('assets/book.png'),
      ),
    );

    final email = TextFormField(
        controller: _txtController,
        keyboardType: TextInputType.text,
        autofocus: false,
        //  initialValue: '',
        decoration: InputDecoration(
          hintText: 'Usuário',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.all(0.0),
            child: Icon(
              Icons.person,
              color: Colors.grey,
            ),
          ),
        ));

    final password = TextFormField(
        controller: _senhaController,
        autofocus: false,
        //initialValue: '',
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Senha',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.all(0.0),
            child: Icon(
              Icons.vpn_key,
              color: Colors.grey,
            ),
          ),
        ));

    var forgotLabel = FlatButton(
      child: Text(
        'Esqueceu sua senha?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        _launchURL();
      },
    );
    _scrollController = ScrollController(initialScrollOffset: 100.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            children: <Widget>[
              SizedBox(height: 100.0),
              logo,
              SizedBox(height: 48.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              Container(
                height: 80,
                child: _isLogging
                    ? new FutureBuilder<UsuarioModel>(
                        future: bloc.autenticar(new AutenticacaoModel(
                            usuario: email.controller.text,
                            senha: password.controller.text)),
                        builder: (BuildContext context,
                            AsyncSnapshot<UsuarioModel> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return loginButton(false);
                              break;
                            case ConnectionState.waiting:
                              return loginButton(true);
                              break;
                            case ConnectionState.active:
                              break;
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                print('Erro: ${snapshot.error}');
                                ToastUtil.showToast('${snapshot.error}');

                                _isLogging = false;

                                return loginButton(false);
                              } else {
                                _isLogging = false;
                                _onWidgetDidBuild(() {
                                  _nextPage();
                                });
                                return loginButton(false);
                              }

                              break;
                          }
                          return null;
                        })
                    : loginButton(false),
              ),
              forgotLabel
            ],
          ),
        ),
      ),
    );
  }
}
