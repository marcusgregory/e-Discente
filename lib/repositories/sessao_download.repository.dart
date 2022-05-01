import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:e_discente/models/sessao_download.model.dart';

import '../settings.dart';
import 'package:http/http.dart' as http;

class SessaoDownload {
  Future<SessaoDownloadModel> requestSessaoDownload(String idTurma) async {
    try {
      var url = '${Settings.apiURL}/sigaa/turma/$idTurma/sessao-download';
      http.Response response = await http.get(Uri.parse(url), headers: {
        'jwt': Settings.usuario!.token!
      }).timeout(const Duration(seconds: 50));
      if (response.statusCode == 200) {
        return SessaoDownloadModel(
            response.headers['j-id'], response.headers['cookie-sigaa']);
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else {
        return Future.error('Ocorreu um erro ao obter a sessão');
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
