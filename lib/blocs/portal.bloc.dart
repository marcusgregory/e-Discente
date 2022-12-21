import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/portal.model.dart';
import '../repositories/portal.repository.dart';

class PortalBloc {
  bool _loadOffline = false;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  Portal? portal;
  var portalState = PortalState.initial;

  final StreamController<PortalState> _streamController =
      StreamController.broadcast();

  Stream<PortalState> get portalStream => _streamController.stream;

  load() async {
    var _prefs = await SharedPreferences.getInstance();
    try {
      if (!_streamController.isClosed) {
        portal = Portal.fromJson(jsonDecode(_prefs.getString('tasks') ?? ''));
        _loadOffline = true;
        portalState = PortalState.ready;
        _streamController.sink.add(portalState);
        print('Carregando dados do portal no servidor...');
        var portalLoaded = (await PortalRepository().getAtualizacoesPortal());
        print('Carregado dados do portal!');
        await _prefs.setString('tasks', jsonEncode(portalLoaded));
        portal = portalLoaded;
        portalState = PortalState.ready;
        _streamController.sink.add(portalState);
      }
    } catch (e) {
      if (!_loadOffline) {
        portalState = PortalState.error;
        _streamController.sink.add(portalState);
        _streamController.addError(e);
        _loadOffline = false;
      }
    }
  }

  dispose() {
    _streamController.close();
  }
}

enum PortalState { initial, loading, ready, error }
