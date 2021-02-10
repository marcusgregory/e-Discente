import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtil {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'event_geral', 'Geral', 'Notificação de e-Discente',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'Notificação de e-Discente');
  static var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  static var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  static Future<void> showNotification(int id, String title, String body,
      {String payload}) async {
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics,
        payload: payload ?? '');
  }

  static Future<void> showScheduleNotification(
      int id, String title, String body, DateTime dateTime,
      {String payload}) async {
    await flutterLocalNotificationsPlugin.schedule(
        id, title, body, dateTime, platformChannelSpecifics,
        payload: payload ?? '');
  }
}
