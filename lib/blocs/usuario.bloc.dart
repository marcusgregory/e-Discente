import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_discente/models/autenticacao.model.dart';
import 'package:uni_discente/models/usuario.model.dart';
import 'package:uni_discente/repositories/conta.repository.dart';
import 'package:uni_discente/settings.dart';

class UsuarioBloc {
  UsuarioModel usuario = new UsuarioModel();
  UsuarioBloc() {
    usuario = null;
  }
  Future<UsuarioModel> autenticar(AutenticacaoModel autenticacao) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var repository = new ContaRepository();
      var res = await repository.autenticar(autenticacao);
      usuario = res;
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
    String usuarioPref = prefs.getString('usuario');
    if (usuarioPref != null) {
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
    await prefs.setString('usuario', null);
    usuario = null;
    Settings.usuario = null;
    
  }
}
