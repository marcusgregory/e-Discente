import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:unidiscente/models/noticias.model.dart';
import 'package:unidiscente/repositories/noticias.repository.dart';

class NoticiasBloc extends ChangeNotifier {
  List<NoticiaModel> noticias = new List<NoticiaModel>();
  Noticias() {
    noticias = null;
  }
  Future<List<NoticiaModel>> getAll() async {
    try {
      var repository = new NoticiasRepository();
      var res = await repository.getAll();
      noticias = res;
     print(noticias[0].titulo);
      return noticias;
    }catch (ex) {
       noticias = null;
       if (ex is SocketException) {
        return Future.error('Ocorreu um erro na conexão com a internet');
    }
      return Future.error(ex);
    }
  }
}
