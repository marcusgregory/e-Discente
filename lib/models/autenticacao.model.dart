class AutenticacaoModel {
  String? usuario;
  String? senha;

  AutenticacaoModel({this.usuario, this.senha});

  AutenticacaoModel.fromJson(Map<String, dynamic> json) {
    usuario = json['usuario'];
    senha = json['senha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usuario'] = usuario;
    data['senha'] = senha;
    return data;
  }
}
