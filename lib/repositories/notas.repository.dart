import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uni_discente/models/boletim.model.dart';
import 'package:uni_discente/settings.dart';

class NotasRepository {
  Future<Map<String,List<BoletimModel>>> getNotas() async {
    try {
      var url = '${Settings.apiURL}/sigaa/notas';
      http.Response response = await http.get(url, headers: {
        'jwt': Settings.usuario.token
      }).timeout(Duration(seconds: 50));

      if (response.statusCode == 200) {
        Map<String,dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
       
        Map<String,List<BoletimModel>> boletim = Map<String,List<BoletimModel>>();
         for(Map<String,dynamic> json in json['data']){
           List<BoletimModel> notas = List<BoletimModel>();
           for(Map<String,dynamic> json2 in json.values.first){
            notas.add(BoletimModel.fromJson(json2));
           }
            boletim[json.keys.first] = notas;
         }
       return boletim;
      } else if (response.statusCode == 400) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return Future.error(json['message']);
      } else {
        return Future.error('Ocorreu um erro ao obter as notas do discente');
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
