// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:e_discente/repositories/register_fcmToken.repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_discente/models/autenticacao.model.dart';
import 'package:e_discente/models/usuario.model.dart';
import 'package:e_discente/repositories/conta.repository.dart';
import 'package:e_discente/settings.dart';

class UsuarioBloc {
  UsuarioModel usuario = UsuarioModel();
  UsuarioBloc() {
    usuario = null;
  }
  Future<UsuarioModel> autenticar(AutenticacaoModel autenticacao) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var repository = new ContaRepository();
      var res = await repository.autenticar(autenticacao);
      usuario = res;
      usuario.nomeDeUsuario = autenticacao.usuario.toLowerCase().trim();
      await prefs.setString('usuario', jsonEncode(usuario));
      Settings.usuario = usuario;
      if (Platform.isAndroid || Platform.isIOS) {
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
        Settings.fcmToken = await FirebaseMessaging.instance.getToken();
        if (Settings.fcmToken != null) {
          RegisterFcmTokenRepository().register(Settings.fcmToken);
        }
      }

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

  Future<UsuarioModel> loadUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 1500));
    String usuarioPref = prefs.getString('usuario') ?? '';
    if (usuarioPref != '') {
      UsuarioModel usuarioM = UsuarioModel.fromJson(jsonDecode(usuarioPref));
      usuario = usuarioM;
      Settings.usuario = usuario;
      if (Platform.isAndroid || Platform.isIOS) {
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
        Settings.fcmToken = await FirebaseMessaging.instance.getToken();
        if (Settings.fcmToken != null) {
          RegisterFcmTokenRepository().register(Settings.fcmToken);
        }
      }
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
    await FirebaseMessaging.instance.deleteToken();
    await FirebaseMessaging.instance.setAutoInitEnabled(false);
  }
}
