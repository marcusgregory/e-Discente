// @dart=2.9
import 'dart:async';

import 'package:uni_discente/models/turma.model.dart';
import 'package:uni_discente/repositories/turmas.repository.dart';

class TurmasBloc {
  TurmasBloc() {
    load();
  }

  StreamController<List<TurmaModel>> _streamController = StreamController();

  Stream<List<TurmaModel>> get turmaStream => _streamController.stream;

  load({bool isRefreshIndicator = false}) async {
    if (!_streamController.isClosed) {
      try {
        if (!isRefreshIndicator) {
          _streamController.sink.add(null);
        }
        List<TurmaModel> list = await TurmasRepository().getTurmas();
        _streamController.sink.add(list);
      } catch (e) {
        _streamController.addError(e);
      }
    }
  }

  dispose() {
    _streamController.close();
  }
}
