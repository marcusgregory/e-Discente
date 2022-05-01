import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:e_discente/models/perfil.model.dart';
import 'package:e_discente/settings.dart';

class PerfilRepository {
  Future<PerfilModel> getPerfil() async {
    try {
      var url = '${Settings.apiURL}/sigaa/discente';
      http.Response response = await http.get(Uri.parse(url), headers: {
        'jwt': Settings.usuario!.token!
      }).timeout(const Duration(seconds: 50));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return PerfilModel.fromJson(json['data']);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else {
        return Future.error('Ocorreu um erro ao obter o perfil do discente');
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
