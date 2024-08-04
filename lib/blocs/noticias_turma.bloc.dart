import 'dart:async';

import 'package:e_discente/repositories/noticias_turma.repository.dart';

import '../models/noticia_turma.model.dart';

class NoticiasTurmaBloc {
  final String idTurma;
  NoticiasTurmaBloc(this.idTurma) {
    load();
  }
  List<NoticiaTurmaModel> noticiasList = [];
  var noticiaState = NoticiaTurmaState.initial;

  final StreamController<NoticiaTurmaState> _streamController =
      StreamController.broadcast();

  Stream<NoticiaTurmaState> get stream => _streamController.stream;

  Future<void> load() async {
    noticiaState = NoticiaTurmaState.loading;
    _streamController.sink.add(noticiaState);
    try {
      noticiasList = await NoticiasTurmaRepository().getNoticiasTurma(idTurma);
      noticiaState = NoticiaTurmaState.ready;
      _streamController.sink.add(noticiaState);
    } catch (e) {
      noticiaState = NoticiaTurmaState.error;
      _streamController.sink.add(noticiaState);
    }
  }

  dispose() {
    _streamController.close();
    _streamController.sink.close();
  }
}

enum NoticiaTurmaState { initial, loading, ready, error }
