import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_discente/models/autenticacao.model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.model.dart';
import '../repositories/conta.repository.dart';
import '../repositories/register_fcm_token.repository.dart';
import '../settings.dart';

class LoginBloc {
  var repository = ContaRepository();

  final StreamController<LoginEvent> _inputLoginController =
      StreamController.broadcast();
  final StreamController<LoginState> _outputLoginController =
      StreamController.broadcast();

  Sink<LoginEvent> get inputLogin => _inputLoginController.sink;

  Stream<LoginState> get stream => _outputLoginController.stream;

  LoginBloc() {
    _outputLoginController.add(LoginInitialState());
    _inputLoginController.stream.listen(_mapEventToState);
  }

  _mapEventToState(LoginEvent event) {
    UsuarioModel? usuario;
    if (event is AuthenticationEvent) {
      _outputLoginController.add(LoginLoadingState());
      repository.autenticar(event.auth).then((value) async {
        usuario = value;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        usuario?.nomeDeUsuario = event.auth.usuario!.toLowerCase().trim();
        await prefs.setString('usuario', jsonEncode(usuario));
        Settings.usuario = usuario;
        registerTokenInitFirebase();
        _outputLoginController.add(LoginSucessState(usuario: usuario));
      }).onError((error, stackTrace) {
        _outputLoginController.add(LoginErrorState(message: error.toString()));
      });
    }
    if (event is DeauthenticationEvent) {
      deslogar();
    }
  }

  Future<void> registerTokenInitFirebase() async {
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
        Settings.fcmToken = await FirebaseMessaging.instance.getToken();
        if (Settings.fcmToken != null) {
          RegisterFcmTokenRepository().register(Settings.fcmToken!);
        }
      }
    } else {
      Settings.fcmToken = await FirebaseMessaging.instance.getToken(
              vapidKey:
                  'BGEfEWSlW911r314_XEFQ8CjZ0d3AUK4xHq4-Q3fwjwz3icOyFxAJsn_58chvVO9h3Cf9VOGJM4e8Q3Z58pu3eE') ??
          '';
      RegisterFcmTokenRepository().register(Settings.fcmToken!);
    }
  }

// faça uma função de deslogar e chame ela no logout do menu  e no login do usuario

  Future<void> deslogar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');
    await prefs.clear();
    Settings.usuario = null;
    await prefs.clear();

    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        await FirebaseMessaging.instance.deleteToken();
        await FirebaseMessaging.instance.setAutoInitEnabled(false);
      }
    }
  }
}

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginSucessState extends LoginState {
  UsuarioModel? usuario;
  LoginSucessState({required this.usuario});
}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  String message;
  LoginErrorState({required this.message});
}

abstract class LoginEvent {}

class AuthenticationEvent extends LoginEvent {
  AutenticacaoModel auth;

  AuthenticationEvent({required this.auth});
}

class DeauthenticationEvent extends LoginEvent {}
