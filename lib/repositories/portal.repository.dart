import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_discente/models/portal.model.dart';
import 'package:http/http.dart' as http;
import 'package:e_discente/settings.dart';

class PortalRepository {
  Future<Portal> getAtualizacoesPortal({String token = ''}) async {
    if (token.isEmpty) {
      token = Settings.usuario!.token!;
    }
    try {
      var url = '${Settings.apiURL}/sigaa/portal';
      http.Response response = await http.get(Uri.parse(url),
          headers: {'jwt': token}).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Portal.fromJson(json['data']);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else {
        return Future.error(
            'Ocorreu um erro ao obter as atualizações do portal');
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
