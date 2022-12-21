import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_discente/models/usuario.model.dart';
import 'package:e_discente/settings.dart';

class UsuarioBloc {
  UsuarioModel? usuario = UsuarioModel();
  UsuarioBloc() {
    usuario = null;
  }

  Future<UsuarioModel?> loadUsuario({bool delayed = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (delayed) {
      await Future.delayed(const Duration(milliseconds: 1500));
    }
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
}
