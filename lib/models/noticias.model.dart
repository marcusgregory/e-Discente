class NoticiaModel {
  int? id;
  String? url;
  String? data;
  String? titulo;
  String? conteudo;
  String? resumo;
  String? imagem;

  NoticiaModel(
      {this.id,
      this.url,
      this.data,
      this.titulo,
      this.conteudo,
      this.resumo,
      this.imagem});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoticiaModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url;
  @override
  int get hashCode => id! + url.hashCode;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['data'] = this.data;
    data['titulo'] = titulo;
    data['conteudo'] = conteudo;
    data['resumo'] = resumo;
    data['imagem'] = imagem;
    return data;
  }
}
