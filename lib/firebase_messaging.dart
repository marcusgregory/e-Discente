import 'dart:convert';

import 'package:e_discente/chat/models/message.model.dart';
import 'package:e_discente/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/app_instance.dart';
import 'models/usuario.model.dart';
import 'notification_settings2.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<void> initFirebaseMessaging() async {
  await Firebase.initializeApp();
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
}

registerOnFirebase() async {
  messaging.subscribeToTopic('all');
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
    var messageModel = MessageModel.fromJson(message.data['message']);
    var groupName = message.data['groupName'] ?? '';
    String messageTo = message.data['messageTo'] ?? '';
    if (messageTo.toLowerCase().trim() ==
        Settings.usuario!.nomeDeUsuario!.trim()) {
      if (messageModel.gid.trim() != AppInstance.currentChatPageOpenId.trim()) {
        NotificationAwesome.createNotificationLargeIconMessage(
            messageModel, groupName,
            showLargeIcon: false);
      }
    }
  });
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  String usuarioPref = prefs.getString('usuario') ?? '';
  print(usuarioPref);
  if (usuarioPref != '') {
    UsuarioModel usuarioM = UsuarioModel.fromJson(jsonDecode(usuarioPref));
    NotificationAwesome.initNotificationAwesome();
    var messageModel = MessageModel.fromJson(message.data['message']);
    String groupName = message.data['groupName'] ?? '';
    String messageTo = message.data['messageTo'] ?? '';
    if (usuarioM.nomeDeUsuario!.toLowerCase().trim() ==
        messageTo.toLowerCase().trim()) {
      NotificationAwesome.createNotificationLargeIconMessage(
          messageModel, groupName,
          showLargeIcon: false);
    }
  }
}
