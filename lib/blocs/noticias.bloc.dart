// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/repositories/noticias.repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NoticiasBloc {
  // NoticiasBloc._();

  // static NoticiasBloc _instance;

  // static NoticiasBloc get instance {
  //   return _instance ??= NoticiasBloc._();
  // }

  StreamController<List<NoticiaModel>> _streamController = StreamController();

  Stream<List<NoticiaModel>> get noticiaStream => _streamController.stream;

  load({bool isRefreshIndicator = false}) async {
    if (!_streamController.isClosed) {
      bool result = false;
      if (kIsWeb) {
        result = true;
      } else {
        result = await DataConnectionChecker().hasConnection;
      }

      if (result == true) {
        try {
          if (!isRefreshIndicator) {
            _streamController.sink.add(null);
          }
          List<NoticiaModel> list = await NoticiasRepository().getAll();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('noticias', jsonEncode(list));
          _streamController.sink.add(list);
        } catch (e) {
          _streamController.addError(e);
        }
      } else {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String noticiasPref = prefs.getString('noticias') ?? '';
          if (noticiasPref != '') {
            Iterable noticias = jsonDecode(noticiasPref);
            List<NoticiaModel> noticiasList =
                noticias.map((model) => NoticiaModel.fromJson(model)).toList();
            _streamController.sink.add(noticiasList);
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
