import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uni_discente/models/autenticacao.model.dart';
import 'package:uni_discente/models/usuario.model.dart';
import 'package:uni_discente/settings.dart';

class ContaRepository{
  Future<UsuarioModel> autenticar(AutenticacaoModel autenticacao) async{
  var url = '${Settings.apiURL}/login';
  http.Response response = await http.post(url,body:{'usuario':autenticacao.usuario,'senha':autenticacao.senha});
  if(response.statusCode==200){
   Map<String,dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
   Map<String,dynamic> usuario = json['data'];
   return UsuarioModel.fromJson(usuario);
  }else if(response.statusCode==401){
    Map<String,dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
    return Future.error(json['message']);
  }else{
    return Future.error('Ocorreu um erro no servidor\nVerifique se o SIGAA está funcionando.');
  }
  
  }
}