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
  PageController pageController = PageController();
  var listenConnection;

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
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
              backgroundColor: Colors.green),
          new BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('Turmas'),
              backgroundColor: Colors.blue),
          new BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              title: Text('Boletim'),
              backgroundColor: Colors.orange),
          new BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('Perfil'),
              backgroundColor: Colors.red)
        ],
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    listenConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AnimatedBuilder(
            animation: pageController,
            builder: (context, widget) {
              int indexPage = pageController.page!=null ? pageController.page.round() : 0;
              return Text(
                  ['Notícias', 'Turmas', 'Boletim', 'Perfil'][indexPage]);
            },
          ),
          elevation: 1.0,
          actions: <Widget>[
            IconButton(
              icon: Hero(
                tag: 'icon_book',
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.transparent,
                  child: CachedNetworkImage(
                    imageUrl: Settings.usuario.urlImagemPerfil,
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
            )
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          listenConnection =
              DataConnectionChecker().onStatusChange.forEach((status) {
            switch (status) {
              case DataConnectionStatus.connected:
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Você está online.'),
                  ), // SnackBar
                );
                break;
              case DataConnectionStatus.disconnected:
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Você está offline.'),
                  ), // SnackBar
                );
                break;
            }
          });
          return PageView(
            controller: pageController,
            children: _children,
            physics: NeverScrollableScrollPhysics(),
          );
        }),
        bottomNavigationBar: AnimatedBuilder(
          animation: pageController,
          builder: (context, widget) {
            return _bottomNavigationBar(pageController.page!=null ? pageController.page.round() : 0, _onItemTapped);
          },
        ));
  }
}
