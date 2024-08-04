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

  Future<void> load() async {
    var prefs = await SharedPreferences.getInstance();
    try {
      if (!_streamController.isClosed) {
        portal = Portal.fromJson(jsonDecode(prefs.getString('tasks') ?? ''));
        _loadOffline = true;
        portalState = PortalState.synchronizing;
        _streamController.sink.add(portalState);
        print('Carregando dados do portal no servidor...');
        PortalRepository().getAtualizacoesPortal().then((portalLoaded) async {
          print('Carregado dados do portal!');
          await prefs.setString('tasks', jsonEncode(portalLoaded));
          portal = portalLoaded;
          portalState = PortalState.ready;
          _streamController.sink.add(portalState);
        }).onError((error, stackTrace) {
          portalState = PortalState.syncError;
          _streamController.sink.add(portalState);
        });
      }
    } catch (e) {
      print("Ocorreu um erro ao carregar o portal!");
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

enum PortalState { initial, loading, synchronizing, syncError, ready, error }
