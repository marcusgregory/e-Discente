
import 'documento.model.dart';

class AulaModel {
  String? titulo;
  String? conteudo;
  List<DocumentoModel>? documentos;

  AulaModel({
    this.titulo,
    this.conteudo,
    this.documentos,
  });

  factory AulaModel.fromJson(Map<String, dynamic> json) => AulaModel(
        titulo: json["titulo"],
        conteudo: json["conteudo"],
        documentos: List<DocumentoModel>.from(
            json["documentos"].map((x) => DocumentoModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "conteudo": conteudo,
        "documentos": List<dynamic>.from(documentos!.map((x) => x.toJson())),
      };
}
