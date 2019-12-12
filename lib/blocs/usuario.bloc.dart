import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:unidiscente/models/autenticacao.model.dart';
import 'package:unidiscente/models/usuario.model.dart';
import 'package:unidiscente/repositories/conta.repository.dart';
import 'package:unidiscente/settings.dart';

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
