class NoticiaModel {
  int id;
  String url;
  String data;
  String titulo;
  String conteudo;
  String resumo;
  String imagem;

  NoticiaModel(
      {this.id,
      this.url,
      this.data,
      this.titulo,
      this.conteudo,
      this.resumo,
      this.imagem});

  NoticiaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    data = json['data'];
    titulo = json['titulo'];
    conteudo = json['conteudo'];
    resumo = json['resumo'];
    imagem = json['imagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['data'] = this.data;
    data['titulo'] = this.titulo;
    data['conteudo'] = this.conteudo;
    data['resumo'] = this.resumo;
    data['imagem'] = this.imagem;
    return data;
  }
}
