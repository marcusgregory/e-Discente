import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:uni_discente/blocs/usuario.bloc.dart';
import 'package:uni_discente/pages/boletim.page.dart';
import 'package:uni_discente/pages/login.page.dart';
import 'package:uni_discente/pages/noticias.page.dart';
import 'package:uni_discente/pages/perfil.page.dart';
import 'package:uni_discente/pages/turmas.page.dart';
import '../settings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final List<Widget> _children = [
    NoticiasPage(),
    TurmasPage(),
    BoletimPage(),
    PerfilScreen(),
  ];

  int onlineFlag = 0;

  PageController pageController = PageController();
  StreamSubscription<DataConnectionStatus> listenConnection;
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  Widget _bottomNavigationBar(int currentIndex, Function onTap) =>
      BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).accentColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.web),
              label: 'Notícias',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Turmas',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: 'Boletim',
              backgroundColor: Colors.orange),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Perfil',
              backgroundColor: Colors.red)
        ],
      );

  @override
  void initState() {
    if (kIsWeb) {
    } else {
      listenConnection =
          DataConnectionChecker().onStatusChange.listen((status) {
        scaffoldStateKey.currentState
            .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
        switch (status) {
          case DataConnectionStatus.connected:
            scaffoldStateKey.currentState
                .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
            if (onlineFlag > 0) {
              scaffoldStateKey.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Agora está online.'),
                    ],
                  ),
                ),
                // SnackBar
              );
            }
            break;
          case DataConnectionStatus.disconnected:
            onlineFlag++;
            scaffoldStateKey.currentState.showSnackBar(
              SnackBar(
                duration: Duration(seconds: 30),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('e-Discente está offline.'),
                  ],
                ),
              ), // SnackBar
            );
            break;
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    listenConnection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldStateKey,
        appBar: AppBar(
          title: AnimatedBuilder(
            animation: pageController,
            builder: (context, widget) {
              int indexPage =
                  pageController.page != null ? pageController.page.round() : 0;
              return GestureDetector(
                child: Text(
                    ['Notícias', 'Turmas', 'Boletim', 'Perfil'][indexPage]),
                onDoubleTap: () {},
              );
            },
          ),
          elevation: 1.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.brightness_6_rounded),
              onPressed: () {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
            ),
            IconButton(
              icon: Hero(
                tag: 'icon_book',
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.transparent,
                  child: CachedNetworkImage(
                    imageUrl: kIsWeb
                        ? 'https://api.allorigins.win/raw?url=' +
                            Uri.encodeComponent(
                                Settings.usuario.urlImagemPerfil)
                        : Settings.usuario.urlImagemPerfil,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Icon(
                      Icons.account_circle,
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.account_circle, color: Colors.grey[200]),
                  ),
                ),
              ),
              onPressed: () async {
                print("Tocou na foto de Perfil");
                await UsuarioBloc().deslogar();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),
          ],
        ),
        body: PageView(
          controller: pageController,
          children: _children,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: pageController,
          builder: (context, widget) {
            return _bottomNavigationBar(
                pageController.page != null ? pageController.page.round() : 0,
                _onItemTapped);
          },
        ));
  }
}
