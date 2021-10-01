// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:e_discente/models/participantes.model.dart';
import '../settings.dart';

class ParticipantesRepository {
  Future<ParticipantesModel> getParticipantes(String idTurma) async {
    try {
      await Future.delayed(Duration(milliseconds: 1200));
      var url = '${Settings.apiURL}/sigaa/turma/$idTurma/participantes';
      http.Response response = await http.get(Uri.parse(url), headers: {
        'jwt': Settings.usuario.token
      }).timeout(Duration(seconds: 50));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return ParticipantesModel.fromJson(json['data']);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else {
        return Future.error('Ocorreu um erro ao obter os participantes');
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
