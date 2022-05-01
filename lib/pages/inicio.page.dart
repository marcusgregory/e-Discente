import 'package:animations/animations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_discente/blocs/noticias.bloc.dart';
import 'package:e_discente/blocs/turmas.bloc.dart';
import 'package:e_discente/chat/app_instance.dart';
import 'package:e_discente/chat/models/chat_item.model.dart';
import 'package:e_discente/stores/perfil.store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_discente/chat/pages/chats.page.dart';
import 'package:e_discente/chat/stores/socket_io.store.dart';
import 'package:e_discente/pages/boletim.page.dart';
import 'package:e_discente/pages/noticias.page.dart';
import 'package:e_discente/pages/perfil.page.dart';
import 'package:e_discente/pages/turmas.page.dart';
import 'package:e_discente/pages/widgets/dialog_account.widget.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import '../chat/pages/chat.page.dart';
import '../chat/stores/chats.store.dart';
import '../main.dart';
import '../settings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../stores/boletim.store.dart';
import 'inicio_controller.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  late NoticiasBloc noticiasBloc;
  late TurmasBloc turmasBloc;
  late Boletim boletimStore;
  late PerfilStore perfilStore;

  final List<Widget> _children = [];

  int onlineFlag = 0;

  var controller = InicioPageController();
  //StreamSubscription<DataConnectionStatus> listenConnection;
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  var bucket = PageStorageBucket();
  _onItemTapped(int value) {
    controller.setPageIndex(value);
  }

  Widget _bottomNavigationBar(int currentIndex, Function(int) onTap) =>
      BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.news_solid)
                  : const Icon(Icons.web),
              label: 'Notícias',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.square_stack_3d_down_right_fill)
                  : const Icon(Icons.school),
              label: 'Turmas',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.graph_square_fill)
                  : const Icon(Icons.timeline),
              label: 'Boletim',
              backgroundColor: Colors.orange),
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.chat_bubble_2_fill)
                  : const Icon(Icons.chat),
              label: 'Conversas',
              backgroundColor: Colors.orange),
          BottomNavigationBarItem(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.person_alt_circle_fill)
                  : const Icon(Icons.account_circle),
              label: 'Perfil',
              backgroundColor: Colors.red)
        ],
      );

  Widget _bottomNavigationBarAndroid(int currentIndex, Function(int) onTap) =>
      NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        )),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: onTap,
          selectedIndex: currentIndex,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.newspaper),
                selectedIcon: Icon(Icons.newspaper_outlined),
                label: 'Notícias'),
            NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: 'Turmas'),
            NavigationDestination(
                icon: Icon(Icons.timeline),
                selectedIcon: Icon(Icons.timeline_outlined),
                label: 'Boletim'),
            NavigationDestination(
                icon: Icon(Icons.chat_outlined),
                selectedIcon: Icon(Icons.chat),
                label: 'Conversas'),
            NavigationDestination(
                icon: Icon(Icons.account_circle_outlined),
                selectedIcon: Icon(Icons.account_circle),
                label: 'Perfil'),
          ],
        ),
      );
  @override
  void initState() {
    GetIt.I<SocketIOStore>().initSocket();
    noticiasBloc = NoticiasBloc();
    turmasBloc = TurmasBloc();
    boletimStore = Boletim();
    perfilStore = PerfilStore();

    _children.addAll([
      NoticiasPage(
        noticiasBloc: noticiasBloc,
      ),
      TurmasPage(turmasBloc: turmasBloc),
      BoletimPage(
        boletimStore: boletimStore,
      ),
      const ChatsPage(),
      PerfilScreen(
        perfilStore: perfilStore,
      ),
    ]);

    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      var payload = receivedNotification.payload;
      controller.setPageIndex(3);
      if (payload != null) {
        if (payload.isNotEmpty) {
          switch (payload['type']) {
            case 'new_message':
              var chatsStore = GetIt.I<ChatsStore>();
              if (chatsStore.chatsState == ChatsState.LOADING) {
                _onLoading();
              }
              when((_) => chatsStore.chatsState == ChatsState.READY, () {
                if (payload['gid'] != AppInstance.currentPageLastOpenedId) {
                  MyApp.navigatorKey.currentState
                      ?.popUntil((route) => route.isFirst);
                  MyApp.navigatorKey.currentState
                      ?.push(MaterialPageRoute(builder: (BuildContext context) {
                    return ChatPage(
                      gid: (payload['gid'] ?? '').trim(),
                      groupName: (payload['groupName'] ?? '').trim(),
                    );
                  }));
                }
              });

              break;
            default:
          }
        }
      }
    });
    super.initState();
  }

  void _onLoading() {
    when((_) => GetIt.I<ChatsStore>().chatsState != ChatsState.LOADING, () {
      Navigator.of(context).pop();
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Carregando conversas...')
                ],
              ),
            ));
      },
    );
  }

  @override
  void dispose() {
    noticiasBloc.dispose();
    turmasBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldStateKey,
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          title: StreamBuilder(
            stream: controller.stream,
            builder: (context, snapshot) {
              int indexPage = controller.pageIndex;
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
                                Settings.usuario!.urlImagemPerfil!)
                        : Settings.usuario!.urlImagemPerfil!,
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
                        // ignore: prefer_const_constructors
                        child: DialogAccount());
                  },
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: StreamBuilder(
              stream: controller.stream,
              builder: (context, snapshot) {
                return PageView(
                  children: [
                    PageTransitionSwitcher(
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                      ) {
                        return FadeThroughTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          child: child,
                        );
                      },
                      child: _children[controller.pageIndex],
                    )
                  ],
                );
              }),
        ),
        bottomNavigationBar: SafeArea(
          child: StreamBuilder(
            stream: controller.stream,
            builder: (context, widget) {
              return Theme.of(context).platform == TargetPlatform.iOS
                  ? _bottomNavigationBar(controller.pageIndex, _onItemTapped)
                  : _bottomNavigationBarAndroid(
                      controller.pageIndex, _onItemTapped);
            },
          ),
        ));
  }
}
