class UsuarioModel {
  String? nomeDeUsuario;
  String? nome;
  String? curso;
  String? numMatricula;
  String? urlImagemPerfil;
  String? cookie;
  String? token;

  UsuarioModel(
      {this.nomeDeUsuario,
      this.nome,
      this.curso,
      this.numMatricula,
      this.urlImagemPerfil,
      this.cookie,
      this.token});

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    nomeDeUsuario = json['nomeDeUsuario'];
    nome = json['nome'];
    curso = json['curso'];
    numMatricula = json['numMatricula'];
    urlImagemPerfil = json['urlImagemPerfil'];
    cookie = json['cookie'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomeDeUsuario'] = nomeDeUsuario!.toLowerCase().trim();
    data['nome'] = nome;
    data['curso'] = curso;
    data['numMatricula'] = numMatricula;
    data['urlImagemPerfil'] = urlImagemPerfil;
    data['cookie'] = cookie;
    data['token'] = token;
    return data;
  }
}
