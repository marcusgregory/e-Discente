
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_discente/models/noticias.model.dart';
import 'package:http/http.dart' as http;
import 'package:e_discente/settings.dart';

class NoticiasRepository {
  Future<List<NoticiaModel>> getAll() async {
    try {
      var url = '${Settings.apiURL}/unilab/noticias';
      http.Response response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        Iterable noticias = json['data'];
        return noticias.map((model) => NoticiaModel.fromJson(model)).toList();
      } else {
        return Future.error('Ocorreu um erro ao obter as notícias');
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
