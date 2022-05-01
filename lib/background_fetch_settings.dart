import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_discente/models/noticias.model.dart';
import 'notification_settings2.dart';
import 'repositories/noticias.repository.dart';

void initBackgroundFetch() {
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
