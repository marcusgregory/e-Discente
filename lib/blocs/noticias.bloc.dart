import 'dart:async';
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/repositories/noticias.repository.dart';

class NoticiasBloc {


  StreamController<List<NoticiaModel>> _streamController = StreamController();

  Stream<List<NoticiaModel>> get noticiaStream => _streamController.stream;

  load({bool isRefreshIndicator = false}) async {
    if (!_streamController.isClosed) {
      try {
        if (!isRefreshIndicator) {
          _streamController.sink.add(null);
        }
        List<NoticiaModel> list = await NoticiasRepository().getAll();
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
