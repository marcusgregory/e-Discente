import 'dart:convert';

import 'package:unidiscente/models/noticias.model.dart';
import 'package:http/http.dart' as http;
import 'package:unidiscente/settings.dart';

class NoticiasRepository{
  Future<List<NoticiaModel>> getAll() async{
    var url= '${Settings.apiURL}/unilab/noticias';
    http.Response response = await http.get(url);
    if(response.statusCode==200){
      Map<String,dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      Iterable noticias = json['data'];
      return noticias.map((model) => NoticiaModel.fromJson(model)).toList();

    }else{
      return Future.error('Ocorreu um erro ao obter as notícias');
    }

  }
}