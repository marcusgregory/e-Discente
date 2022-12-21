import 'dart:async';
import 'dart:convert';

import 'package:e_discente/models/turma_calendario.model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/turmas_calendario.repository.dart';

class TurmasCalendarioBloc {
  bool firstRun = true;

  List<TurmaCalendario> list = [];
  bool _loadOffline = false;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  var turmasState = TurmasCalendarioState.loading;

  final StreamController<TurmasCalendarioState> _streamController =
      StreamController.broadcast();

  Stream<TurmasCalendarioState> get turmaStream => _streamController.stream;

  load({bool isRefreshIndicator = false}) async {
    var _prefs = await SharedPreferences.getInstance();
    firstRun = false;
    if (!_streamController.isClosed) {
      try {
        if (!isRefreshIndicator) {
          turmasState = TurmasCalendarioState.loading;
          _streamController.sink.add(turmasState);
        }
        Iterable i = jsonDecode(_prefs.getString('calendar') ?? '');
        var turmasCalendario =
            i.map((turma) => TurmaCalendario.fromJson(turma)).toList();
        list = turmasCalendario.where((element) {
          List<DateTime> datasAulas = [];
          for (var element in element.calendario.datasAulas) {
            datasAulas.add(formatter.parse(element));
          }
          var now = DateTime.now();
          bool result = false;
          for (var dataAula in datasAulas) {
            result = now.day == dataAula.day &&
                now.month == dataAula.month &&
                now.year == dataAula.year;
            if (result) break;
          }
          return result;
        }).toList();
        list.sort();
        _loadOffline = true;
        turmasState = TurmasCalendarioState.ready;
        _streamController.sink.add(turmasState);
        print('Carregando dados do calendario das turmas no servidor...');
        var turmasCalendar = (await TurmasCalendarioRepository().getTurmas());
        print('Carregado calendario das turmas!');
        list = turmasCalendar.where((element) {
          List<DateTime> datasAulas = [];
          for (var element in element.calendario.datasAulas) {
            datasAulas.add(formatter.parse(element));
          }
          var now = DateTime.now();
          bool result = false;
          for (var dataAula in datasAulas) {
            result = now.day == dataAula.day &&
                now.month == dataAula.month &&
                now.year == dataAula.year;
            if (result) break;
          }
          return result;
        }).toList();
        list.sort();
        await _prefs.setString('calendar', jsonEncode(turmasCalendar));
        turmasState = TurmasCalendarioState.loading;
        _streamController.sink.add(turmasState);
        turmasState = TurmasCalendarioState.ready;
        _streamController.sink.add(turmasState);
      } catch (e) {
        if (!_loadOffline) {
          turmasState = TurmasCalendarioState.error;
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

enum TurmasCalendarioState { loading, ready, error }
