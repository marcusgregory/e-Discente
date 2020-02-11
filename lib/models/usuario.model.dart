class UsuarioModel {
  String nome;
  String curso;
  String numMatricula;
  String urlImagemPerfil;
  String cookie;
  String token;

  UsuarioModel(
      {this.nome,
      this.curso,
      this.numMatricula,
      this.urlImagemPerfil,
      this.cookie,
      this.token});
  

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    curso = json['curso'];
    numMatricula = json['numMatricula'];
    urlImagemPerfil = json['urlImagemPerfil'];
    cookie = json['cookie'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['curso'] = this.curso;
    data['numMatricula'] = this.numMatricula;
    data['urlImagemPerfil'] = this.urlImagemPerfil;
    data['cookie'] = this.cookie;
    data['token'] = this.token;
    return data;
  }
}
