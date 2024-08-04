import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_discente/chat/models/message_strategy/i_message.strategy.dart';
import 'package:http/http.dart' as http;

import 'package:e_discente/chat/models/i_message.dart';
import 'package:e_discente/chat/models/message_strategy/message_text.strategy.dart';

import '../app_instance.dart';

class MessagesRepository {
  Future<List<IMessage>> getMessages(String gid, {int page = 1}) async {
    try {
      var url = '${AppInstance.apiURL}/messages/$gid?page=$page';
      http.Response response = await http.get(Uri.parse(url), headers: {
        'jwt': AppInstance.token
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        Iterable chats = json['data'];
        return chats.map((model) => _createMessage(model)).toList();
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else if (response.statusCode == 404) {
        return Future.value([]);
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

  // Future<List<IMessage>> getMessages(String gid) async {
  //   var messages = '''
  //   {
  //   "status": 200,
  //   "message": "OK",
  //   "data": [
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T22:45:46.551Z",
  //           "_id": "61105e9ab6d7c30015708cdc",
  //           "mid": "5ee2dc70-f89a-11eb-938a-c96f2d264dbc",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "gabrielamota",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T22:45:49.055Z",
  //           "_id": "61105e9cb6d7c30015708cde",
  //           "mid": "6060f0f0-f89a-11eb-938a-c96f2d264dbc",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "gabrielamota",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T22:45:51.265Z",
  //           "_id": "61105e9eb6d7c30015708ce0",
  //           "mid": "61b22910-f89a-11eb-938a-c96f2d264dbc",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "gabrielamota",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T22:45:53.873Z",
  //           "_id": "61105ea2b6d7c30015708ce4",
  //           "mid": "63401c10-f89a-11eb-9b69-97c521c3df11",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "marcus_gregory",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T22:45:58.399Z",
  //           "_id": "61105ea7b6d7c30015708ce8",
  //           "mid": "65f2b8f0-f89a-11eb-9b69-97c521c3df11",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "marcus_gregory",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T22:46:01.491Z",
  //           "_id": "61105eaab6d7c30015708cea",
  //           "mid": "67ca8630-f89a-11eb-9b69-97c521c3df11",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "marcus_gregory",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:17:03.323Z",
  //           "_id": "611065f0b6d7c30015708d00",
  //           "mid": "bd878ab0-f89e-11eb-a529-2b8d304c7dfe",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "marcus_gregory",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:18:59.835Z",
  //           "_id": "61106663b6d7c30015708d06",
  //           "mid": "02fa03c0-f89f-11eb-938a-c96f2d264dbc",
  //           "gid": "1",
  //           "messageText": "Oi vih do futuro",
  //           "sendBy": "gabrielamota",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:19:23.855Z",
  //           "_id": "6110667bb6d7c30015708d0a",
  //           "mid": "114b2d00-f89f-11eb-938a-c96f2d264dbc",
  //           "gid": "1",
  //           "messageText": "N consigo falar no futuro",
  //           "sendBy": "gabrielamota",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:20:27.600Z",
  //           "_id": "611066bcb6d7c30015708d0c",
  //           "mid": "374a3230-f89f-11eb-a52a-2b8d304c7dfe",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "marcus_gregory",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:20:43.417Z",
  //           "_id": "611066cbb6d7c30015708d0e",
  //           "mid": "40b73890-f89f-11eb-938a-c96f2d264dbc",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "gabrielamota",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:20:50.597Z",
  //           "_id": "611066d2b6d7c30015708d10",
  //           "mid": "44fecd50-f89f-11eb-938a-c96f2d264dbc",
  //           "gid": "1",
  //           "messageText": "Oie",
  //           "sendBy": "gabrielamota",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:20:56.539Z",
  //           "_id": "611066d9b6d7c30015708d12",
  //           "mid": "48897ab0-f89f-11eb-a52a-2b8d304c7dfe",
  //           "gid": "1",
  //           "messageText": "Ta doido e",
  //           "sendBy": "marcus_gregory",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:21:03.295Z",
  //           "_id": "611066e0b6d7c30015708d14",
  //           "mid": "4c905cf0-f89f-11eb-a52a-2b8d304c7dfe",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "marcus_gregory",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:21:36.715Z",
  //           "_id": "61106700b6d7c30015708d16",
  //           "mid": "607bd9b0-f89f-11eb-938a-c96f2d264dbc",
  //           "gid": "1",
  //           "messageText": "Oi",
  //           "sendBy": "gabrielamota",
  //           "__v": 0
  //       },
  //       {
  //           "type": "message",
  //           "sendAt": "2021-08-08T23:21:37.121Z",
  //           "_id": "61106702b6d7c30015708d18",
  //           "mid": "60b9cd10-f89f-11eb-a52a-2b8d304c7dfe",
  //           "gid": "1",
  //           "messageText": "Sai dai peida fino",
  //           "sendBy": "marcus_gregory",
  //           "__v": 0
  //       }]}
  //   ''';

  //   Map<String, dynamic> json = jsonDecode(utf8.decode(messages.codeUnits));
  //   Iterable chats = json['data'];
  //   return chats.map((model) => _createMessage(model)).toList();
  // }

  IMessage _createMessage(dynamic model) {
    return CreateMethod.method(model);
  }
}

class CreateMethod {
  static final Map<String, IMessageStrategy> _methods = {
    'default': MessageTextStrategy(),
    'message': MessageTextStrategy()
  };
  static IMessage method(dynamic model) {
    if (_methods.containsKey(model['type'])) {
      return _methods['message']!.createMessage(model);
    } else {
      return _methods['default']!.createMessage(model);
    }
  }
}
