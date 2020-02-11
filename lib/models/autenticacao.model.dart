class AutenticacaoModel{
  String usuario;
  String senha;

  AutenticacaoModel({this.usuario,this.senha});

  AutenticacaoModel.fromJson(Map<String,dynamic> json){
    usuario = json['usuario'];
    senha = json['senha'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['usuario'] = this.usuario;
    data['senha'] = this.senha;
    return data;
  }

  
}