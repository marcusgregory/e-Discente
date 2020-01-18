import 'dart:async';
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/repositories/noticias.repository.dart';

class NoticiasBloc {
  NoticiasBloc() {
    load();
  }

  StreamController<List<NoticiaModel>> _streamController = StreamController();
  bool _isLoading = false;

  toggleLoading() => _isLoading = !_isLoading;

  Stream<List<NoticiaModel>> get noticiaStream => _streamController.stream;

  load({bool isRefreshIndicator = false}) async {
    try {
      if(!isRefreshIndicator){
     _streamController.sink.add(null);
      }
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
