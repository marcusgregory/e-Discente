import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:uni_discente/blocs/usuario.bloc.dart';
import 'package:uni_discente/ui/login.ui.dart';
import 'package:uni_discente/ui/noticias.ui.dart';
import 'package:uni_discente/ui/turmas.ui.dart';
import 'package:uni_discente/ui/widgets/turma.widget.dart';

import '../settings.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _currentIndex = 0;
  String _title;
  final List<Widget> _children = [
    NoticiasPage(),
    TurmasPage(),
    Center(child: Text("Página 3")),
    Center(child: Text("Página 4")),
  ];
  PageController pageController = PageController();
  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'Notícias';
          }
          break;
        case 1:
          {
            _title = 'Turmas';
          }
          break;
        case 2:
          {
            _title = 'Página 3';
          }
          break;
        case 3:
          {
            _title = 'Página 4';
          }
          break;
      }
    });
  }

  Widget _bottomNavigationBar(int currentIndex, Function onTap) =>
      BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.web),
            title: Text('Notícias'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('Turmas'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.filter_3),
            title: Text('Página 3'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.filter_4), title: Text('Página 4'))
        ],
      );

  @override
  void initState() {
    _title = "Notícias";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          elevation: 1.0,
          actions: <Widget>[
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AdvancedNetworkImage(Settings.usuario.urlImagemPerfil,
                fallbackAssetImage:'assets/round_account_circle.png',
                useDiskCache: true,
                cacheRule: CacheRule(maxAge: const Duration(days: 7))
                ),
                radius: 15,
              ),
              onPressed: () async {
                print("Tocou na foto de Perfil");
               await UsuarioBloc().deslogar();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            )
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged,
          children: _children,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar:
            _bottomNavigationBar(_currentIndex, _onItemTapped));
  }
}
