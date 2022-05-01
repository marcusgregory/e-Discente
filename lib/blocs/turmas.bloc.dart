import 'dart:async';

import 'package:e_discente/models/turma.model.dart';
import 'package:e_discente/repositories/turmas.repository.dart';

class TurmasBloc {
  bool firstRun = true;

  List<TurmaModel> list = [];

  var turmasState = TurmasState.loading;

  final StreamController<TurmasState> _streamController =
      StreamController.broadcast();

  Stream<TurmasState> get turmaStream => _streamController.stream;

  load({bool isRefreshIndicator = false}) async {
    firstRun = false;
    if (!_streamController.isClosed) {
      try {
        if (!isRefreshIndicator) {
          turmasState = TurmasState.loading;
          _streamController.sink.add(turmasState);
        }
        list = await TurmasRepository().getTurmas();
        turmasState = TurmasState.ready;
        _streamController.sink.add(turmasState);
      } catch (e) {
        turmasState = TurmasState.error;
        _streamController.sink.add(turmasState);
        _streamController.addError(e);
      }
    }
  }

  dispose() {
    _streamController.close();
  }
}

enum TurmasState { loading, ready, error }
