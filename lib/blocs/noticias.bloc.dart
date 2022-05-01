import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_discente/models/noticias.model.dart';
import 'package:e_discente/repositories/noticias.repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NoticiasBloc {
  NoticiasBloc() {
    load();
  }
  List<NoticiaModel> noticiasList = [];
  var noticiaState = NoticiaState.loading;

  final StreamController<NoticiaState> _streamController =
      StreamController.broadcast();

  Stream<NoticiaState> get noticiaStream => _streamController.stream;

  load({bool isRefreshIndicator = false}) async {
    if (!_streamController.isClosed) {
      if (true == true) {
        try {
          if (!isRefreshIndicator) {
            noticiaState = NoticiaState.loading;
            _streamController.sink.add(noticiaState);
          }
          noticiasList = await NoticiasRepository().getAll();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('noticias', jsonEncode(noticiasList));
          noticiaState = NoticiaState.ready;
          _streamController.sink.add(noticiaState);
        } catch (e) {
          _streamController.addError(e);
          noticiaState = NoticiaState.error;
          _streamController.sink.add(noticiaState);
        }
      } else {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String noticiasPref = prefs.getString('noticias') ?? '';
          if (noticiasPref != '') {
            Iterable noticias = jsonDecode(noticiasPref);
            noticiasList =
                noticias.map((model) => NoticiaModel.fromJson(model)).toList();
            _streamController.sink.add(NoticiaState.ready);
          } else {
            _streamController
                .addError('Não foi possível obter as noticias offline');
          }
        } catch (e) {
          _streamController.addError(e);
        }
      }
    }
  }

  dispose() {
    _streamController.close();
    _streamController.sink.close();
  }
}

enum NoticiaState { loading, ready, error }
