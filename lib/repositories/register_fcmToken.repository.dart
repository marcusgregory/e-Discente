import 'package:e_discente/chat/app_instance.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../settings.dart';

class RegisterFcmTokenRepository {
  Future<void> register(String fcmToken) async {
    print('Registrando fcmToken no back-end...');
    print(fcmToken);
    var url = '${AppInstance.apiURL}/user/setFcmToken';
    http.Response response = await http.post(Uri.parse(url),
        body: {'fcmToken': fcmToken}, headers: {'jwt': Settings.usuario.token});
    if (response.statusCode == 200) {
      print('Registro do fcmToken foi feito com sucesso!');
      Future.value('ok');
    } else if (response.statusCode == 401) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return Future.error(json['message']);
    } else {
      return Future.error('Ocorreu um erro no servidor.');
    }
  }
}
