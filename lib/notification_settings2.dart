import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:e_discente/models/noticias.model.dart';

import 'chat/models/message.model.dart';
import 'models/portal.model.dart';

class NotificationAwesome {
  static const Map<String, String> _payloadDefault = {};

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
              groupAlertBehavior: GroupAlertBehavior.Children,
              playSound: true,
              defaultColor: Colors.white,
              ledColor: const Color(0xFF00396A)),
          NotificationChannel(
              channelKey: 'news_channel',
              channelName: 'Notícias',
              channelDescription: 'Notícias',
              defaultPrivacy: NotificationPrivacy.Public,
              importance: NotificationImportance.High,
              defaultColor: const Color(0xFF00396A),
              ledColor: const Color(0xFF00396A)),
          NotificationChannel(
              channelKey: 'tasks_channel',
              channelName: 'Atividades',
              channelDescription: 'Atividades',
              channelShowBadge: true,
              enableVibration: true,
              defaultPrivacy: NotificationPrivacy.Public,
              importance: NotificationImportance.Max,
              playSound: true,
              defaultColor: const Color(0xFF00396A),
              ledColor: const Color(0xFF00396A)),
          NotificationChannel(
              channelKey: 'portal_updates_channel',
              channelName: 'Atualizacções das Turmas',
              channelDescription: 'Atualizacções das Turmas',
              channelShowBadge: true,
              enableVibration: true,
              defaultPrivacy: NotificationPrivacy.Public,
              importance: NotificationImportance.Max,
              playSound: true,
              defaultColor: const Color(0xFF00396A),
              ledColor: const Color(0xFF00396A))
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
          groupKey: message.gid,
          defaultPrivacy: NotificationPrivacy.Private,
          playSound: true,
          defaultColor: const Color(0xFF00396A),
          ledColor: const Color(0xFF00396A)),
    );
    String nomeGrupo = groupName;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: Random().nextInt(100000),
          channelKey: "chat_channel",
          title: nomeGrupo,
          body: '${message.sendBy}: ${message.messageText.trim()}',
          largeIcon: showLargeIcon ? message.profilePicUrl : '',
          ticker: "Nova mensagem",
          summary: 'Nova mensagem',
          category: NotificationCategory.Message,
          roundedLargeIcon: true,
          notificationLayout: NotificationLayout.MessagingGroup,
          payload: {
            'type': 'new_message',
            'gid': message.gid,
            'groupName': nomeGrupo
          }),
    );
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
          groupAlertBehavior: GroupAlertBehavior.Children,
          playSound: true,
          defaultColor: const Color(0xFF00396A),
          ledColor: const Color(0xFF00396A)),
    );

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: Random().nextInt(100000),
            channelKey: "chat_channel",
            title: title,
            body: body,
            largeIcon: largeIcon,
            ticker: "Nova mensagem",
            notificationLayout: NotificationLayout.Messaging,
            payload: {'uuid': 'uuid-test'}));
  }

  static void createNotificationBigPictureNoticia(NoticiaModel noticia) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: noticia.id ?? 0,
            channelKey: "news_channel",
            hideLargeIconOnExpand: true,
            title: noticia.titulo,
            body: noticia.resumo,
            largeIcon: noticia.imagem,
            bigPicture: noticia.imagem,
            summary: 'Noticia',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'uuid': 'uuid-test'}));
  }

  static void createNotificationNewTask(Atividade atividade) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: atividade.idAtividade.hashCode,
            channelKey: "tasks_channel",
            title: 'Nova Tarefa: ' + atividade.nomeDisciplina,
            body: atividade.conteudo,
            summary: 'Nova Tarefa',
            notificationLayout: NotificationLayout.Default,
            payload: {
          'type': 'new_task',
          'idAtividade': atividade.idAtividade,
          'idTurma': atividade.idTurma
        }));
  }

  static void createNotificationNewUpdatePortal(
      AtualizacoesTurma atualizacaoTurma) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: atualizacaoTurma.hashCode,
            channelKey: "portal_updates_channel",
            title: 'Nova Atualização: ${atualizacaoTurma.nomeDisciplina}',
            body: atualizacaoTurma.conteudo,
            summary: 'Nova Atualização da Turma',
            notificationLayout: NotificationLayout.Default,
            payload: {
          'type': 'new_portal_update',
          'idTurma': atualizacaoTurma.idTurma,
        }));
  }
}
