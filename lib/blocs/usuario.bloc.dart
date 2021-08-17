// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_discente/models/autenticacao.model.dart';
import 'package:uni_discente/models/usuario.model.dart';
import 'package:uni_discente/repositories/conta.repository.dart';
import 'package:uni_discente/settings.dart';

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
      return usuario;
    } else {
      usuario = null;
      Settings.usuario = null;
      return null;
    }
  }

  deslogar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', '');
    usuario = null;
    Settings.usuario = null;
  }
}
