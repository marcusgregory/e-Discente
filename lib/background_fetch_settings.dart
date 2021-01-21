import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_discente/models/noticias.model.dart';

import 'notification_settings.dart';
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
      backgroundFetchHeadlessTask);
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] evento recebido.');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<NoticiaModel> noticiasAtuais = await NoticiasRepository().getAll();
  String noticiasPref = prefs.getString('noticias');
  List<NoticiaModel> noticiasNovas = [];
  if (noticiasPref != null) {
    Iterable noticias = jsonDecode(noticiasPref);
    List<NoticiaModel> noticiasAntigas =
        noticias.map((model) => NoticiaModel.fromJson(model)).toList();
    noticiasAntigas.forEach(noticiasAtuais.remove);
    noticiasNovas = noticiasAtuais;
  }
  print(noticiasNovas.length);
  if (noticiasNovas.length > 0) {
    print('[BackgroundFetch] novas noticias.');
    showNotification(noticiasNovas.length);
  }

  BackgroundFetch.finish(taskId);
}
