import 'dart:async';
import 'dart:convert';

import 'package:e_discente/firebase_messaging.dart';
import 'package:e_discente/models/turma.model.dart';
import 'package:e_discente/repositories/turmas.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TurmasBloc {
  bool firstRun = true;

  List<TurmaModel> list = [];
  bool _loadOffline = false;

  var turmasState = TurmasState.loading;

  final StreamController<TurmasState> _streamController =
      StreamController.broadcast();

  Stream<TurmasState> get turmaStream => _streamController.stream;

  Future<void> load({bool isRefreshIndicator = false}) async {
    var prefs = await SharedPreferences.getInstance();
    firstRun = false;
    if (!_streamController.isClosed) {
      try {
        if (!isRefreshIndicator) {
          turmasState = TurmasState.loading;
          _streamController.sink.add(turmasState);
        }
        Iterable i = jsonDecode(prefs.getString('classes') ?? '');
        list = i.map((turma) => TurmaModel.fromJson(turma)).toList();
        list.sort();
        turmasState = TurmasState.ready;
        _loadOffline = true;
        _streamController.sink.add(turmasState);
        list = await TurmasRepository().getTurmas();
        await prefs.setString('classes', jsonEncode(list));
        list.sort();
        for (var element in list) {
          await subscribeToTopic(element.idTurma ?? '');
        }
        turmasState = TurmasState.ready;
        _streamController.sink.add(turmasState);
      } catch (e) {
        if (!_loadOffline) {
          turmasState = TurmasState.error;
          _streamController.sink.add(turmasState);
          _streamController.addError(e);
          _loadOffline = false;
        }
      }
    }
  }

  dispose() {
    _streamController.close();
  }
}

enum TurmasState { loading, ready, error }
