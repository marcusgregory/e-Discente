// @dart=2.9
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_discente/chat/app_instance.dart';
import 'package:e_discente/chat/pages/chats.page.dart';
import 'package:e_discente/chat/stores/socket_io.store.dart';
import 'package:e_discente/pages/boletim.page.dart';
import 'package:e_discente/pages/noticias.page.dart';
import 'package:e_discente/pages/perfil.page.dart';
import 'package:e_discente/pages/turmas.page.dart';
import 'package:e_discente/pages/widgets/dialog_account.widget.dart';
import 'package:flutter/services.dart';
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
    ChatsPage(),
    PerfilScreen(),
  ];

  int onlineFlag = 0;
  Flushbar flush = Flushbar();

  PageController pageController = PageController();
  //StreamSubscription<DataConnectionStatus> listenConnection;
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  Widget _bottomNavigationBar(int currentIndex, Function onTap) =>
      BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? Icon(CupertinoIcons.news_solid)
                  : Icon(Icons.web),
              label: 'Notícias',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? Icon(CupertinoIcons.square_stack_3d_down_right_fill)
                  : Icon(Icons.school),
              label: 'Turmas',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? Icon(CupertinoIcons.graph_square_fill)
                  : Icon(Icons.timeline),
              label: 'Boletim',
              backgroundColor: Colors.orange),
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? Icon(CupertinoIcons.chat_bubble_2_fill)
                  : Icon(Icons.chat),
              label: 'Conversas',
              backgroundColor: Colors.orange),
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? Icon(CupertinoIcons.person_alt_circle_fill)
                  : Icon(Icons.account_circle),
              label: 'Perfil',
              backgroundColor: Colors.red)
        ],
      );

  @override
  void initState() {
    var socket = SocketIOStore();
    AppInstance.socketStore = socket;
    socket.initSocket();
    // if (kIsWeb) {
    // } else {
    //   listenConnection =
    //       DataConnectionChecker().onStatusChange.listen((status) {
    //     flush.dismiss();
    //     switch (status) {
    //       case DataConnectionStatus.connected:
    //         if (onlineFlag > 0) {
    //           flush = Flushbar(
    //             message: 'Agora está online.',
    //             backgroundColor: Colors.green,
    //             icon: Container(
    //               width: 7,
    //               height: 7,
    //               decoration: BoxDecoration(
    //                   color: Colors.green, shape: BoxShape.circle),
    //             ),
    //             duration: Duration(seconds: 3),
    //             isDismissible: true,
    //             flushbarStyle: FlushbarStyle.GROUNDED,
    //             flushbarPosition: FlushbarPosition.TOP,
    //           )..show(context);
    //         }
    //         break;
    //       case DataConnectionStatus.disconnected:
    //         onlineFlag++;
    //         flush = Flushbar(
    //           message: 'e-Discente está offline.',
    //           icon: Container(
    //             width: 7,
    //             height: 7,
    //             decoration:
    //                 BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    //           ),
    //           duration: Duration(seconds: 30),
    //           isDismissible: true,
    //           flushbarStyle: FlushbarStyle.GROUNDED,
    //           flushbarPosition: FlushbarPosition.TOP,
    //         )..show(context);
    //         break;
    //     }
    //   });
    // }

    super.initState();
  }

  @override
  void dispose() {
    //listenConnection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldStateKey,
        appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          title: AnimatedBuilder(
            animation: pageController,
            builder: (context, widget) {
              int indexPage =
                  pageController.page != null ? pageController.page.round() : 0;
              return GestureDetector(
                child: Text([
                  'Notícias',
                  'Turmas',
                  'Boletim',
                  'Conversas',
                  'Perfil'
                ][indexPage]),
                onDoubleTap: () {},
              );
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
                // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                //   return DialogAccount();
                // }));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: DialogAccount());
                  },
                );
                // showModalBottomSheet(
                //     isScrollControlled: true,
                //     context: context,
                //     builder: (_) {
                //       return DialogAccount();
                //     });
                //     print("Tocou na foto de Perfil");
                //     await UsuarioBloc().deslogar();
                //     Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(
                //             builder: (BuildContext context) => LoginPage()));
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
