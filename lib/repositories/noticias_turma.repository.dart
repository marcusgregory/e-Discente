import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_discente/models/noticia_turma.model.dart';
import 'package:http/http.dart' as http;

import '../settings.dart';

class NoticiasTurmaRepository {
  Future<List<NoticiaTurmaModel>> getNoticiasTurma(String? idTurma) async {
    try {
      var url = '${Settings.apiURL}/sigaa/turma/$idTurma/noticias';
      http.Response response = await http.get(Uri.parse(url), headers: {
        'jwt': Settings.usuario!.token
      }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        Iterable aulas = json['data'];
        return aulas.map((model) => NoticiaTurmaModel.fromJson(model)).toList();
      } else if (response.statusCode == 400) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else {
        return Future.error(
            'Ocorreu um erro ao obter as noticias da turma $idTurma');
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
