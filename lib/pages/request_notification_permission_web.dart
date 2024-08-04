import 'package:e_discente/blocs/notification_permission.bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:e_discente/util/toast.util.dart';

import '../blocs/usuario.bloc.dart';
import '../firebase_messaging.dart';
import '../models/usuario.model.dart';
import 'login_page.dart';
import 'splash_carregamento_inicial.page.dart';

class RequestNotificationPermissionWeb extends StatefulWidget {
  const RequestNotificationPermissionWeb({super.key});

  @override
  State<RequestNotificationPermissionWeb> createState() =>
      _RequestNotificationPermissionWebState();

  static Future<void> loadUser(BuildContext context) async {
    UsuarioModel? usuario = await UsuarioBloc().loadUsuario();
    await initializeDateFormatting('pt_Br', '');
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

class _RequestNotificationPermissionWebState
    extends State<RequestNotificationPermissionWeb> {
  AuthorizationStatus? autorizationStatus;
  late NotificationPermissionBloc notPermissionBloc;
  @override
  void initState() {
    notPermissionBloc = NotificationPermissionBloc();
    notPermissionBloc.checkPermission();
    notPermissionBloc.stream.listen((event) {
      switch (notPermissionBloc.state) {
        case PermissionState.initial:
          break;
        case PermissionState.loading:
          break;
        case PermissionState.authorized:
          pushToNextScreen();
          break;
        case PermissionState.denied:
          pushToNextScreen();
          break;
        case PermissionState.provisional:
          pushToNextScreen();
          break;
        case PermissionState.notDetermined:
          break;
        case PermissionState.notSupported:
          pushToNextScreen();
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
              child: StreamBuilder(
                  stream: notPermissionBloc.stream,
                  builder: (context, snapshot) {
                    switch (notPermissionBloc.state) {
                      case PermissionState.initial:
                        return const CircularProgressIndicator.adaptive();

                      case PermissionState.loading:
                        return const CircularProgressIndicator.adaptive();

                      case PermissionState.authorized:
                        return const CircularProgressIndicator.adaptive();
                      case PermissionState.denied:
                        return const CircularProgressIndicator.adaptive();
                      case PermissionState.provisional:
                        return const CircularProgressIndicator.adaptive();

                      case PermissionState.notDetermined:
                        return Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  height: 250,
                                  child:
                                      Image.asset('assets/animated-bell.gif')),
                              const Column(
                                children: [
                                  Text(
                                    'Precisamos da sua permissão para mostrar notificações', //"Precisamos da sua localização",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Louis-george',
                                        fontSize: 19,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 35, right: 35),
                                    child: Text(
                                      "O e-Discente usa as notificações para mostrar dados relevantes sobre novas notícias, atualizações das turmas e conversas em grupo.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Louis-george',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xFF0D294D)),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ))),
                                          onPressed: () async {
                                            notPermissionBloc
                                                .requestPermission();
                                          },
                                          child: Center(
                                              child: Text(
                                                  'Requisitar permissão',
                                                  style:
                                                      GoogleFonts.darkerGrotesque(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight
                                                              .w700)))),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );

                      case PermissionState.notSupported:
                        return const CircularProgressIndicator.adaptive();
                    }
                  })),
        ),
      ),
    );
  }

  Future<void> _loadAutorization() async {
    print('load autorization');
    bool isSuported = await FirebaseMessaging.instance.isSupported();
    ToastUtil.showLongToast("è suportado: $isSuported");
    if (isSuported) {
      autorizationStatus =
          (await FirebaseMessaging.instance.getNotificationSettings())
              .authorizationStatus;

      requestNotificationPermission(autorizationStatus);
    } else {
      pushToNextScreen();
    }
  }

  Future<void> requestNotificationPermission(
      AuthorizationStatus? autorizationStatus) async {
    if (autorizationStatus != null) {
      switch (autorizationStatus) {
        case AuthorizationStatus.authorized:
          await initFirebaseMessaging();
          pushToNextScreen();
          break;
        case AuthorizationStatus.denied:
          pushToNextScreen();
          break;
        case AuthorizationStatus.notDetermined:
          setState(() {
            // loading = false;
          });
          break;
        case AuthorizationStatus.provisional:
          pushToNextScreen();
          break;
      }
    } else {
      pushToNextScreen();
    }
  }

  Future<void> pushToNextScreen() async {
    await RequestNotificationPermissionWeb.loadUser(context);
  }
}
