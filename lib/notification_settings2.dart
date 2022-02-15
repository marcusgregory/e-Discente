import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/src/enumerators/group_alert_behaviour.dart'
    as Notifications;
import 'package:e_discente/models/noticias.model.dart';

import 'chat/app_instance.dart';
import 'chat/models/message.model.dart';

class NotificationAwesome {
  static void initNotificationAwesome() {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/ic_notification_default_large',
        //null,
        [
          NotificationChannel(
              channelKey: 'chat_channel',
              channelName: 'Conversas',
              channelDescription: 'Conversas',
              importance: NotificationImportance.Max,
              channelShowBadge: true,
              enableVibration: true,
              groupKey: 'chat',
              defaultPrivacy: NotificationPrivacy.Public,
              groupAlertBehavior: Notifications.GroupAlertBehavior.Children,
              playSound: true,
              defaultColor: Colors.white,
              ledColor: Color(0xFF00396A)),
          NotificationChannel(
              channelKey: 'news_channel',
              channelName: 'Notícias',
              channelDescription: 'Notícias',
              defaultPrivacy: NotificationPrivacy.Public,
              importance: NotificationImportance.High,
              defaultColor: Color(0xFF00396A),
              ledColor: Color(0xFF00396A))
        ]);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static void createNotificationLargeIconMessage(
      MessageModel message, String groupName,
      {bool showLargeIcon = false}) async {
    AwesomeNotifications().setChannel(
        NotificationChannel(
            channelKey: 'chat_channel',
            channelName: 'Conversas',
            channelDescription: 'Conversas',
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            enableVibration: true,
            //groupKey: 'chat',
            defaultPrivacy: NotificationPrivacy.Public,
            groupAlertBehavior: Notifications.GroupAlertBehavior.Children,
            playSound: true,
            defaultColor: Color(0xFF00396A),
            ledColor: Color(0xFF00396A)),
        forceUpdate: true);
    String nomeGrupo = groupName;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: new Random().nextInt(100000),
            channelKey: "chat_channel",
            title: '$nomeGrupo',
            body: '${message.sendBy}: ${message.messageText.trim()}',
            largeIcon: showLargeIcon ? message.profilePicUrl : '',
            ticker: "Nova mensagem",
            notificationLayout: NotificationLayout.Messaging,
            payload: {'uuid': 'uuid-test'}));
  }

  static void createNotificationLargeIconMessageData(
      String body, String title, String largeIcon) async {
    AwesomeNotifications().setChannel(
        NotificationChannel(
            channelKey: 'chat_channel',
            channelName: 'Conversas',
            channelDescription: 'Conversas',
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            enableVibration: true,
            // groupKey: 'chat',
            defaultPrivacy: NotificationPrivacy.Public,
            groupAlertBehavior: Notifications.GroupAlertBehavior.Children,
            playSound: true,
            defaultColor: Color(0xFF00396A),
            ledColor: Color(0xFF00396A)),
        forceUpdate: true);

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: new Random().nextInt(100000),
            channelKey: "chat_channel",
            title: '$title',
            body: body,
            largeIcon: largeIcon,
            ticker: "Nova mensagem",
            notificationLayout: NotificationLayout.Messaging,
            payload: {'uuid': 'uuid-test'}));
  }

  static void createNotificationBigPictureNoticia(NoticiaModel noticia) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: noticia.id,
            channelKey: "news_channel",
            hideLargeIconOnExpand: true,
            title: noticia.titulo,
            body: noticia.resumo,
            largeIcon: noticia.imagem,
            bigPicture: noticia.imagem,
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'uuid': 'uuid-test'}));
  }
}
