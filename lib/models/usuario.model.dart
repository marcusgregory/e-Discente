class UsuarioModel {
  late String nomeDeUsuario;
  late String nome;
  late String curso;
  late String numMatricula;
  late String urlImagemPerfil;
  late String cookie;
  late String token;

  UsuarioModel(
      {required this.nomeDeUsuario,
      required this.nome,
      required this.curso,
      required this.numMatricula,
      required this.urlImagemPerfil,
      required this.cookie,
      required this.token});

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    nomeDeUsuario = json['nomeDeUsuario'] ?? '';
    nome = json['nome'];
    curso = json['curso'];
    numMatricula = json['numMatricula'];
    urlImagemPerfil = json['urlImagemPerfil'];
    cookie = json['cookie'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomeDeUsuario'] = nomeDeUsuario.toLowerCase().trim();
    data['nome'] = nome;
    data['curso'] = curso;
    data['numMatricula'] = numMatricula;
    data['urlImagemPerfil'] = urlImagemPerfil;
    data['cookie'] = cookie;
    data['token'] = token;
    return data;
  }
}
