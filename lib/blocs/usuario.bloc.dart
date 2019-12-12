import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:uni_discente/models/autenticacao.model.dart';
import 'package:uni_discente/models/usuario.model.dart';
import 'package:uni_discente/repositories/conta.repository.dart';
import 'package:uni_discente/settings.dart';

class UsuarioBloc extends ChangeNotifier {
  UsuarioModel usuario = new UsuarioModel();
  UsuarioBloc() {
    usuario = null;
  }
  Future<UsuarioModel> autenticar(AutenticacaoModel autenticacao) async {
    try {
      var repository = new ContaRepository();
      var res = await repository.autenticar(autenticacao);
      usuario = res;
      Settings.usuario = usuario;
      return res;
    }catch (ex) {
       usuario = null;
       Settings.usuario = null;
       if (ex is SocketException) {
        return Future.error('Ocorreu um erro na conexão com a internet');
    }
     
      return Future.error(ex);
    }
  }
}
