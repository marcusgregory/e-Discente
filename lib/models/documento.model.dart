// @dart=2.9
class DocumentoModel {
  String nome;
  String id;
  String formAva;

  DocumentoModel({
    this.nome,
    this.id,
    this.formAva,
  });

  factory DocumentoModel.fromJson(Map<String, dynamic> json) => DocumentoModel(
        nome: json["nome"],
        id: json["id"],
        formAva: json["formAva"],
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "id": id,
        "formAva": formAva,
      };
}
