import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:unidiscente/models/autenticacao.model.dart';
import 'package:unidiscente/models/usuario.model.dart';
import 'package:unidiscente/settings.dart';

class ContaRepository{
  Future<UsuarioModel> autenticar(AutenticacaoModel autenticacao) async{
  var url = '${Settings.apiURL}/login';
  http.Response response = await http.post(url,body:{'usuario':autenticacao.usuario,'senha':autenticacao.senha});
  if(response.statusCode==200){
   Map<String,dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
   Map<String,dynamic> usuario = json['data'];
   print(json.toString());
   return UsuarioModel.fromJson(usuario);
  }else if(response.statusCode==401){
    throw new Exception('Usuario ou senha incorretos');
  }else{
    throw new Exception('Ocorreu um erro desconhecido');
  }
  
  }
}