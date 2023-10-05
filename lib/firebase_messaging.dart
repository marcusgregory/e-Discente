import 'dart:convert';
import 'dart:developer';

import 'package:e_discente/chat/models/message.model.dart';
import 'package:e_discente/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/app_instance.dart';
import 'models/usuario.model.dart';
import 'notification_awesome.dart';
import 'repositories/subscribe_to_topic_web.repository.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<AuthorizationStatus> initFirebaseMessaging() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  registerOnFirebase();
  return Future.value(settings.authorizationStatus);
}

registerOnFirebase() async {
  if (!kIsWeb) {
    messaging.subscribeToTopic('all');
    messaging.subscribeToTopic('news');
  } else {
    SubscribeToTopicWebRepository().subscribe(Settings.fcmToken ?? '', 'all');
    SubscribeToTopicWebRepository().subscribe(Settings.fcmToken ?? '', 'news');
  }

  // messaging.onTokenRefresh.listen((token) {
  //   RegisterFcmTokenRepository().register(token);
  // });
  // messaging.getToken().then((token) {
  //   Settings.fcmToken = token;
  //   print(token);
  // });
  messaging.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('_messaging onMessageOpenedApp: $message');
  });
  FirebaseMessaging.onMessage.listen((message) {
    print('_messaging onMessage: $message');
    if (message.data.containsKey('type')) {
      switch (message.data['type'] as String) {
        case 'ATUALIZACAO_ATIVIDADE':
          NotificationAwesome.createNotificationTarefa(
              message.notification?.title ?? '',
              message.notification?.body ?? '');
          break;
        case 'ATUALIZACAO_TURMA':
          NotificationAwesome.createNotificationAtualizacaoTurma(
              message.notification?.title ?? '',
              message.notification?.body ?? '');
          break;
        case 'ATUALIZACAO_NOTICIA':
          NotificationAwesome.createNotificationNewNoticia(
              message.notification?.title ?? '',
              message.notification?.body ?? '',
              message.notification?.android?.imageUrl ?? '');
          break;
        default:
          NotificationAwesome.createBasicNotification(
            message.notification?.title ?? '',
            message.notification?.body ?? '',
          );
          break;
      }
    } else if (message.data.containsKey('message')) {
      var messageModel = MessageModel.fromJson(message.data['message']);
      var groupName = message.data['groupName'] ?? '';
      String messageTo = message.data['messageTo'] ?? '';
      if (messageTo.toLowerCase().trim() ==
          Settings.usuario!.nomeDeUsuario.trim()) {
        if (messageModel.gid.trim() !=
            AppInstance.currentChatPageOpenId.trim()) {
          NotificationAwesome.createNotificationLargeIconMessage(
              messageModel, groupName,
              showLargeIcon: false);
        }
      }
    }
  });
}

Future<void> subscribeToTopic(String topic) async {
  if (kIsWeb) {
    SubscribeToTopicWebRepository()
        .subscribe(Settings.fcmToken ?? '', topic.trim());
  } else {
    log(topic);
    print(topic);
    await messaging.subscribeToTopic(topic.trim());
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  String usuarioPref = prefs.getString('usuario') ?? '';
  print(usuarioPref);
  if (usuarioPref != '') {
    UsuarioModel usuarioM = UsuarioModel.fromJson(jsonDecode(usuarioPref));
    if (!kIsWeb) {
      NotificationAwesome.initNotificationAwesome();
    }

    var messageModel = MessageModel.fromJson(message.data['message']);
    String groupName = message.data['groupName'] ?? '';
    String messageTo = message.data['messageTo'] ?? '';
    if (usuarioM.nomeDeUsuario.toLowerCase().trim() ==
        messageTo.toLowerCase().trim()) {
      NotificationAwesome.createNotificationLargeIconMessage(
          messageModel, groupName,
          showLargeIcon: false);
    }
  }
}
