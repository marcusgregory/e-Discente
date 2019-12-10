import 'package:flutter/widgets.dart';
import 'package:unidiscente/models/autenticacao.model.dart';
import 'package:unidiscente/models/usuario.model.dart';
import 'package:unidiscente/repositories/conta.repository.dart';

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
      return res;
    } catch (ex) {
      usuario = null;
      return Future.error(ex);
    }
  }
}
