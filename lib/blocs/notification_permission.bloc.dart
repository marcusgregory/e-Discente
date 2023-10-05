import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../firebase_messaging.dart';

enum PermissionState {
  initial,
  loading,
  authorized,
  denied,
  provisional,
  notDetermined,
  notSupported
}

class NotificationPermissionBloc {
  final StreamController<PermissionState> _streamController =
      StreamController.broadcast();

  Stream<PermissionState> get stream => _streamController.stream;

  var state = PermissionState.initial;

  checkPermission() async {
    state = PermissionState.loading;
    _streamController.sink.add(state);
    bool isSuported = await FirebaseMessaging.instance.isSupported();
    if (!isSuported) {
      state = PermissionState.notSupported;
      _streamController.sink.add(state);
    } else {
      AuthorizationStatus autorizationStatus =
          (await FirebaseMessaging.instance.getNotificationSettings())
              .authorizationStatus;
      switch (autorizationStatus) {
        case AuthorizationStatus.authorized:
          await initFirebaseMessaging();
          state = PermissionState.authorized;
          _streamController.sink.add(state);
          break;
        case AuthorizationStatus.denied:
          state = PermissionState.denied;
          _streamController.sink.add(state);
          break;
        case AuthorizationStatus.notDetermined:
          state = PermissionState.notDetermined;
          _streamController.sink.add(state);
          break;
        case AuthorizationStatus.provisional:
          state = PermissionState.provisional;
          _streamController.sink.add(state);
          break;
      }
    }
  }

  requestPermission() async {
    state = PermissionState.loading;
    _streamController.sink.add(state);
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    checkPermission();
  }
}
