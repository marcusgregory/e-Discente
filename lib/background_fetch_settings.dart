import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:e_discente/blocs/usuario.bloc.dart';
import 'package:e_discente/repositories/portal.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_discente/models/noticias.model.dart';
import 'models/portal.model.dart';
import 'notification_settings2.dart';
import 'repositories/noticias.repository.dart';

void initBackgroundFetch() {
  backgroundFetchTask('123');
  BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          startOnBoot: true,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY),
      backgroundFetchTask);
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

void backgroundFetchTask(String taskId) async {
  print('[BackgroundFetch] evento recebido.');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Future.wait([getNews(prefs), getTasksUpdate(prefs)]);
  BackgroundFetch.finish(taskId);
}

void backgroundFetchHeadlessTask(HeadlessTask task) {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print("[BackgroundFetch] Headless event received: $taskId");
  backgroundFetchTask(taskId);
}

Future<void> getNews(SharedPreferences prefs) async {
  List<NoticiaModel> noticiasAtuais = await NoticiasRepository().getAll();
  String? noticiasPref = prefs.getString('noticias');
  await prefs.setString('noticias', jsonEncode(noticiasAtuais));
  List<NoticiaModel> noticiasNovas = [];
  if (noticiasPref != null) {
    Iterable noticias = jsonDecode(noticiasPref);
    List<NoticiaModel> noticiasAntigas =
        noticias.map((model) => NoticiaModel.fromJson(model)).toList();
    noticiasAntigas.forEach(noticiasAtuais.remove);
    noticiasNovas = noticiasAtuais;
  }
  print(noticiasNovas.length);
  if (noticiasNovas.isNotEmpty) {
    print('[BackgroundFetch] novas noticias.');
    for (var noticia in noticiasNovas) {
      NotificationAwesome.createNotificationBigPictureNoticia(noticia);
    }
  }
}

Future<void> getTasksUpdate(SharedPreferences prefs) async {
  var usuario = await UsuarioBloc().loadUsuario(delayed: false);
  if (usuario != null) {
    if (usuario.token != null) {
      if ((prefs.containsKey('tasks'))) {
        Portal portalAtual = (await PortalRepository()
            .getAtualizacoesPortal(token: usuario.token ?? ''));
        Portal portalAntigo = portalFromJson(prefs.getString('tasks') ?? '');
        await prefs.setString('tasks', jsonEncode(portalAtual));
        List<Atividade> atividadesNovas = [];
        portalAntigo.atividades.forEach(portalAtual.atividades.remove);
        atividadesNovas = portalAtual.atividades;
        if (atividadesNovas.isNotEmpty) {
          print('[BackgroundFetch] novas atividades.');
          for (var atividade in atividadesNovas) {
            NotificationAwesome.createNotificationNewTask(atividade);
          }
        }
        List<AtualizacoesTurma> atualizacoesTurmasNovas = [];
        portalAntigo.atualizacoesTurmas
            .forEach(portalAtual.atualizacoesTurmas.remove);
        atualizacoesTurmasNovas = portalAtual.atualizacoesTurmas;
        if (atualizacoesTurmasNovas.isNotEmpty) {
          print('[BackgroundFetch] novas atualizacoes das turmas.');
          for (var atualizacaoTurma in atualizacoesTurmasNovas) {
            NotificationAwesome.createNotificationNewUpdatePortal(
                atualizacaoTurma);
          }
        }
      }
    }
  }
}
