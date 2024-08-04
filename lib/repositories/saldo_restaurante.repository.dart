import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:e_discente/settings.dart';

class SaldoRestauranteRepository {
  Future<String> getSaldo() async {
    try {
      var url = '${Settings.apiURL}/catraca/saldo';
      http.Response response = await http.get(Uri.parse(url), headers: {
        'jwt': Settings.usuario!.token
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return json['data']['saldo'] as String;
      } else if (response.statusCode == 400) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else {
        return Future.error('Ocorreu um erro ao obter o saldo');
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
