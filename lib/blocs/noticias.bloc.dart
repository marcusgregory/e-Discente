import 'dart:async';
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/repositories/noticias.repository.dart';

class NoticiasBloc {
  NoticiasBloc() {
    load();
  }

  StreamController<List<NoticiaModel>> _streamController = StreamController();

  Stream<List<NoticiaModel>> get noticiaStream => _streamController.stream;

  load() async {
    try {
      List<NoticiaModel> list = await NoticiasRepository().getAll();
      _streamController.sink.add(list);
    } catch (e) {
      _streamController.addError(e);
    }
  }

  dispose() {
    _streamController.close();
  }
}
