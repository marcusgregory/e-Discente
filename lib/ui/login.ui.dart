import 'package:flutter/material.dart';
import 'package:unidiscente/blocs/usuario.bloc.dart';
import 'package:unidiscente/models/autenticacao.model.dart';
import 'package:unidiscente/models/usuario.model.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
ScrollController _scrollController;
TextEditingController _txtController;
TextEditingController _senhaController;


  @override
  Widget build(BuildContext context) {
    _scrollController = new ScrollController();
    _txtController = TextEditingController(text: "");
    _senhaController = TextEditingController(text: "");
    _txtController.addListener((){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, curve: Curves.easeOut, duration: const Duration(milliseconds: 500),);
   })
;   final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 55.0,
        child: Image.asset('assets/book.png'),
      ),
    );

    final email =TextFormField(
      controller: _txtController,
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
    //  initialValue: '',
      decoration: InputDecoration(
        hintText: 'Usuário' ,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: _senhaController,
      autofocus: false,
      //initialValue: '',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Senha',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {  
          try{      
        UsuarioBloc bloc = new UsuarioBloc();
        UsuarioModel autenticar = await bloc.autenticar(new AutenticacaoModel(usuario:email.controller.text,senha: password.controller.text));
        print(autenticar.nome);
          }catch(ex){
            print(ex.toString());
          }
         //Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(13),
        color: Colors.lightBlueAccent,
        child: Text('Entrar', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Esqueceu sua senha?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );
 _scrollController = ScrollController(initialScrollOffset: 100.0);
     return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            children: <Widget>[
              SizedBox(height: 100.0),
              logo,
              SizedBox(height: 48.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              forgotLabel
            ],
          ),
        ),
      ),
    );
  }
}