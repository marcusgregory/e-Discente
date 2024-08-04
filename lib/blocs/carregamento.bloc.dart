import 'dart:async';
import 'dart:convert';

import 'package:e_discente/repositories/perfil.repository.dart';
import 'package:e_discente/repositories/turmas.repository.dart';
import 'package:e_discente/repositories/turmas_calendario.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chat/repositories/list-chat.repository.dart';
import '../models/portal.model.dart';
import '../repositories/portal.repository.dart';

class CarregamentoBloc {
  final StreamController<CarregamentoState> _streamController =
      StreamController.broadcast();
  Stream<CarregamentoState> get carregamentoStream => _streamController.stream;
  var carregamentoState = CarregamentoState.initial;
  late SharedPreferences _prefs;

  load() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      await Future.wait([_loadData(), _loadTasks()]);

      carregamentoState = CarregamentoState.ready;
      _streamController.sink.add(carregamentoState);
    } catch (e) {
      carregamentoState = CarregamentoState.error;
      _streamController.sink.add(carregamentoState);
    }
  }

  Future<void> _loadData() async {
    await _loadProfile();
    await _loadClasses();
    await _loadChats();
    await _loadCalendar();
  }

  Future<void> _loadProfile() async {
    if (!(_prefs.containsKey('profile'))) {
      carregamentoState = CarregamentoState.loadingProfile;
      _streamController.sink.add(carregamentoState);
      PerfilRepository perfilRepository = PerfilRepository();
      var perfil = await perfilRepository.getPerfil();
      await _prefs.setString('profile', jsonEncode(perfil));
    }
  }

  Future<void> _loadClasses() async {
    if (!(_prefs.containsKey('classes'))) {
      carregamentoState = CarregamentoState.loadingClasses;
      _streamController.sink.add(carregamentoState);
      TurmasRepository turmasRep = TurmasRepository();
      var turmas = await turmasRep.getTurmas();
      await _prefs.setString('classes', jsonEncode(turmas));
    }
  }

  Future<void> _loadCalendar() async {
    if (!(_prefs.containsKey('calendar'))) {
      carregamentoState = CarregamentoState.loadingCalendar;
      _streamController.sink.add(carregamentoState);
      TurmasCalendarioRepository turmasCalRep = TurmasCalendarioRepository();
      var turmasCal = await turmasCalRep.getTurmas();
      await _prefs.setString('calendar', jsonEncode(turmasCal));
    }
  }

  Future<void> _loadTasks() async {
    if (!(_prefs.containsKey('tasks'))) {
      Portal portal = (await PortalRepository().getAtualizacoesPortal());
      await _prefs.setString('tasks', jsonEncode(portal));
    }
  }

  Future<void> _loadChats() async {
    if (!(_prefs.containsKey('chats'))) {
      carregamentoState = CarregamentoState.loadingChats;
      _streamController.sink.add(carregamentoState);
      ListChatRepository chatsRep = ListChatRepository();
      var chats = await chatsRep.getChats();
      await _prefs.setString('chats', jsonEncode(chats));
    }
  }
}

enum CarregamentoState {
  initial,
  loadingProfile,
  loadingClasses,
  loadingCalendar,
  loadingTasks,
  loadingChats,
  ready,
  error
}
