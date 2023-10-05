import 'package:animations/animations.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:e_discente/blocs/noticias.bloc.dart';
import 'package:e_discente/blocs/turmas.bloc.dart';
import 'package:e_discente/chat/pages/chats.page.dart';
import 'package:e_discente/chat/stores/socket_io.store.dart';
import 'package:e_discente/pages/home.page.dart';
import 'package:e_discente/pages/noticias.page.dart';
import 'package:e_discente/pages/perfil.page.dart';
import 'package:e_discente/pages/turmas.page.dart';
import 'package:e_discente/stores/perfil.store.dart';

import '../chat/stores/chats.store.dart';
import '../repositories/register_fcm_token.repository.dart';
import '../stores/boletim.store.dart';
import 'inicio_controller.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

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
                  ? const Icon(CupertinoIcons.home)
                  : const Icon(Icons.home),
              label: 'Inicio',
              backgroundColor: Colors.green),
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
              icon: MyBadge(
                child: (Theme.of(context).platform == TargetPlatform.iOS
                    ? const Icon(CupertinoIcons.chat_bubble_2_fill)
                    : const Icon(Icons.chat)),
              ),
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
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Início'),
            NavigationDestination(
                icon: Icon(Icons.newspaper),
                selectedIcon: Icon(Icons.newspaper_outlined),
                label: 'Notícias'),
            NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: 'Turmas'),
            NavigationDestination(
                icon: MyBadge(child: Icon(Icons.chat_outlined)),
                selectedIcon: MyBadge(child: Icon(Icons.chat)),
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
    registerSingletons();
    registerFirebaseToken();
    noticiasBloc = NoticiasBloc();
    turmasBloc = TurmasBloc();
    perfilStore = PerfilStore();
    _children.addAll([
      HomePage(),
      NoticiasPage(
        noticiasBloc: noticiasBloc,
      ),
      TurmasPage(turmasBloc: turmasBloc),
      const ChatsPage(),
      PerfilScreen(
        perfilStore: perfilStore,
      ),
    ]);

    super.initState();
  }

  void registerSingletons() {
    if (GetIt.I.isRegistered<SocketIOStore>(instance: SocketIOStore())) {
      GetIt.I.unregister<SocketIOStore>(
        disposingFunction: (p0) => p0.dispose(),
      );
    }
    GetIt.I.registerSingleton<SocketIOStore>(SocketIOStore());
    GetIt.I<SocketIOStore>().initSocket();

    if (GetIt.I.isRegistered<ChatsStore>(instance: ChatsStore())) {
      GetIt.I.unregister<ChatsStore>(
        disposingFunction: (p0) => p0.dispose(),
      );
    }

    GetIt.I.registerLazySingleton(() => ChatsStore());
  }

  void unregisterSingletons() {
    GetIt.I.unregister<ChatsStore>(
      disposingFunction: (p0) => p0.dispose(),
    );
    GetIt.I.unregister<SocketIOStore>(
      disposingFunction: (p0) => p0.dispose(),
    );
  }

  @override
  void dispose() {
    noticiasBloc.dispose();
    turmasBloc.dispose();
    controller.dispose();
    unregisterSingletons();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldStateKey,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.primary,
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
              // return Theme.of(context).platform == TargetPlatform.iOS
              //     ? _bottomNavigationBar(controller.pageIndex, _onItemTapped)
              //     : _bottomNavigationBarAndroid(
              //         controller.pageIndex, _onItemTapped);
              return _bottomNavigationBar(controller.pageIndex, _onItemTapped);
            },
          ),
        ));
  }
}

Future<void> registerFirebaseToken() async {
  late String fcmToken;
  if (kIsWeb) {
    fcmToken = await FirebaseMessaging.instance.getToken(
            vapidKey:
                'BGEfEWSlW911r314_XEFQ8CjZ0d3AUK4xHq4-Q3fwjwz3icOyFxAJsn_58chvVO9h3Cf9VOGJM4e8Q3Z58pu3eE') ??
        '';
  } else {
    fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
  }

  if (fcmToken.isNotEmpty) {
    RegisterFcmTokenRepository().register(fcmToken);
  }
}

class MyBadge extends StatelessWidget {
  final Widget child;

  const MyBadge({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
        badgeStyle: badges.BadgeStyle(
          shape: badges.BadgeShape.square,
          borderRadius: BorderRadius.circular(5),
          padding: const EdgeInsets.all(2),
          badgeGradient: const badges.BadgeGradient.linear(
            colors: [
              Colors.purple,
              Colors.blue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        position: badges.BadgePosition.topEnd(top: -12, end: -20),
        badgeContent: const Text(
          'PREVIEW',
          style: TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        showBadge: true,
        child: child);
  }
}
