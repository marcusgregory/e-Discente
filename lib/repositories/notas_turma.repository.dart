import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uni_discente/models/notas_turma.model.dart';
import '../settings.dart';

class NotasTurmaRepository {
  Future<NotasTurmaModel> getNotaTurma(String idTurma) async {
    try {
      var url = '${Settings.apiURL}/sigaa/turma/$idTurma/notas';
      http.Response response = await http.get(url, headers: {
        'jwt': Settings.usuario.token
      }).timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        var notas = NotasTurmaModel.fromJson(json['data']);
        if (notas.notas.isNotEmpty) {
          return notas;
        } else {
          return null;
        }
      } else if (response.statusCode == 400) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else {
        return Future.error('Ocorreu um erro ao obter as notas da turma');
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
