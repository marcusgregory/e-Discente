import 'dart:convert';
import 'dart:io';
import 'package:e_discente/chat/stores/chats.store.dart';
import 'package:e_discente/chat/stores/socket_io.store.dart';
import 'package:e_discente/repositories/register_fcmToken.repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_discente/models/autenticacao.model.dart';
import 'package:e_discente/models/usuario.model.dart';
import 'package:e_discente/repositories/conta.repository.dart';
import 'package:e_discente/settings.dart';

class UsuarioBloc {
  UsuarioModel? usuario = UsuarioModel();
  UsuarioBloc() {
    usuario = null;
  }
  Future<UsuarioModel> autenticar(AutenticacaoModel autenticacao) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var repository = ContaRepository();
      var res = await repository.autenticar(autenticacao);
      usuario = res;
      usuario!.nomeDeUsuario = autenticacao.usuario!.toLowerCase().trim();
      await prefs.setString('usuario', jsonEncode(usuario));
      Settings.usuario = usuario;
      if (!kIsWeb) {
        if (Platform.isAndroid || Platform.isIOS) {
          await FirebaseMessaging.instance.setAutoInitEnabled(true);
          Settings.fcmToken = await FirebaseMessaging.instance.getToken();
          if (Settings.fcmToken != null) {
            RegisterFcmTokenRepository().register(Settings.fcmToken!);
          }
        }
      } else {
        // if (FirebaseMessaging.instance.isSupported()) {
        //   await FirebaseMessaging.instance.setAutoInitEnabled(true);
        //   Settings.fcmToken = await FirebaseMessaging.instance.getToken();
        //   if (Settings.fcmToken != null) {
        //     RegisterFcmTokenRepository().register(Settings.fcmToken!);
        //   }
        // }
      }
      registerSingletons();
      return res;
    } catch (ex) {
      usuario = null;
      Settings.usuario = null;
      if (ex is SocketException) {
        return Future.error('Ocorreu um erro na conexão com a internet');
      }

      return Future.error(ex);
    }
  }

  Future<UsuarioModel?> loadUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 1500));
    String usuarioPref = prefs.getString('usuario') ?? '';
    if (usuarioPref != '') {
      UsuarioModel usuarioM = UsuarioModel.fromJson(jsonDecode(usuarioPref));
      usuario = usuarioM;
      Settings.usuario = usuario;
      if (!kIsWeb) {
        if (Platform.isAndroid || Platform.isIOS) {
          await FirebaseMessaging.instance.setAutoInitEnabled(true);
          Settings.fcmToken = await FirebaseMessaging.instance.getToken();
          if (Settings.fcmToken != null) {
            RegisterFcmTokenRepository().register(Settings.fcmToken!);
          }
        }
      } else {
        // await FirebaseMessaging.instance.setAutoInitEnabled(true);
        // Settings.fcmToken = await FirebaseMessaging.instance.getToken();
        // if (Settings.fcmToken != null) {
        //   RegisterFcmTokenRepository().register(Settings.fcmToken!);
        // }
      }
      registerSingletons();
      return usuario;
    } else {
      usuario = null;
      Settings.usuario = null;
      return null;
    }
  }

  Future<void> deslogar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', '');
    usuario = null;
    Settings.usuario = null;
    GetIt.I.unregister<ChatsStore>(
      disposingFunction: (p0) => p0.dispose(),
    );
    GetIt.I.unregister<SocketIOStore>(
      disposingFunction: (p0) => p0.dispose(),
    );

    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        await FirebaseMessaging.instance.deleteToken();
        await FirebaseMessaging.instance.setAutoInitEnabled(false);
      }
    } else {
      // await FirebaseMessaging.instance.deleteToken();
      // await FirebaseMessaging.instance.setAutoInitEnabled(false);
    }
  }

  void registerSingletons() {
    if (GetIt.I.isRegistered<SocketIOStore>(instance: SocketIOStore())) {
      GetIt.I.unregister<SocketIOStore>(
        disposingFunction: (p0) => p0.dispose(),
      );
    }
    GetIt.I.registerSingleton<SocketIOStore>(SocketIOStore());

    if (GetIt.I.isRegistered<ChatsStore>(instance: ChatsStore())) {
      GetIt.I.unregister<ChatsStore>(
        disposingFunction: (p0) => p0.dispose(),
      );
    }

    GetIt.I.registerLazySingleton(() => ChatsStore());
  }
}
