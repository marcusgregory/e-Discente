import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:e_discente/chat/models/message.model.dart';
import '../app_instance.dart';

class MessagesRepository {
  Future<List<MessageModel>> getMessages(String gid) async {
    try {
      var url = '${AppInstance.apiURL}/messages/$gid';
      http.Response response = await http.get(Uri.parse(url),
          headers: {'jwt': AppInstance.token}).timeout(Duration(seconds: 50));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        Iterable chats = json['data'];
        return chats
            .map((model) =>
                MessageModel.fromMap(model)..state = MessageState.SENDED)
            .toList();
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else if (response.statusCode == 500) {
        return Future.error('Ocorreu um erro no Servidor');
      } else {
        return Future.error('Ocorreu um erro ao obter as Mensagens');
      }
    } catch (ex) {
      if (ex is SocketException) {
        return Future.error('Ocorreu um erro na conexão com a internet');
      }
      if (ex is TimeoutException) {
        return Future.error('O tempo limite de conexão foi atingido');
      }

      return Future.error(ex);
    }
  }
}
