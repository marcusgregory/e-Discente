import 'package:http/http.dart' as http;
import 'dart:convert';

import '../settings.dart';

class SubscribeToTopicWebRepository {
  Future<void> subscribe(String fcmToken, String topic) async {
    print('Se increvendo no tópico "$topic" com token "$fcmToken');
    var url = '${Settings.apiURL}/subscribe';
    http.Response response = await http.post(Uri.parse(url), body: {
      'topic': topic,
      'token': fcmToken
    }).timeout(const Duration(seconds: 60));
    if (response.statusCode == 200) {
      print('Inscrição no tópico $topic feito com sucesso!');
      Future.value('ok');
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return Future.error(json['message']);
    } else {
      return Future.error('Ocorreu um erro no servidor.');
    }
  }
}
