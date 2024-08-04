class PerfilModel {
  String? nome;
  String? curso;
  String? numMatricula;
  String? urlImagemPerfil;
  String? nivel;
  String? situacao;
  String? semestreEntrada;
  String? iDE;
  String? integralizacao;
  String? cookie;

  PerfilModel(
      {this.nome,
      this.curso,
      this.numMatricula,
      this.urlImagemPerfil,
      this.nivel,
      this.situacao,
      this.semestreEntrada,
      this.iDE,
      this.integralizacao,
      this.cookie});

  PerfilModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    curso = json['curso'];
    numMatricula = json['numMatricula'];
    urlImagemPerfil = json['urlImagemPerfil'];
    nivel = json['nivel'];
    situacao = json['situacao'];
    semestreEntrada = json['semestreEntrada'];
    iDE = json['IDE'];
    integralizacao = json['integralizacao'];
    cookie = json['cookie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['curso'] = curso;
    data['numMatricula'] = numMatricula;
    data['urlImagemPerfil'] = urlImagemPerfil;
    data['nivel'] = nivel;
    data['situacao'] = situacao;
    data['semestreEntrada'] = semestreEntrada;
    data['IDE'] = iDE;
    data['integralizacao'] = integralizacao;
    data['cookie'] = cookie;
    return data;
  }
}
