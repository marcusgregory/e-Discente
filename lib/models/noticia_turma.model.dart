import 'dart:convert';

NoticiaTurmaModel noticiaTurmaFromJson(String str) =>
    NoticiaTurmaModel.fromJson(json.decode(str));

String noticiaTurmaToJson(NoticiaTurmaModel data) => json.encode(data.toJson());

class NoticiaTurmaModel {
  final String titulo;
  final String data;
  final String conteudo;
  final String html;

  NoticiaTurmaModel({
    required this.titulo,
    required this.data,
    required this.conteudo,
    required this.html,
  });

  NoticiaTurmaModel copyWith({
    String? titulo,
    String? data,
    String? conteudo,
    String? html,
  }) =>
      NoticiaTurmaModel(
        titulo: titulo ?? this.titulo,
        data: data ?? this.data,
        conteudo: conteudo ?? this.conteudo,
        html: html ?? this.html,
      );

  factory NoticiaTurmaModel.fromJson(Map<String, dynamic> json) =>
      NoticiaTurmaModel(
        titulo: json["titulo"],
        data: json["data"],
        conteudo: json["conteudo"],
        html: json["html"],
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "data": data,
        "conteudo": conteudo,
        "html": html,
      };
}
