
class DocumentoModel {
  String? nome;
  String? id;
  String? formAva;
  String? key;

  DocumentoModel({this.nome, this.id, this.formAva, this.key});

  factory DocumentoModel.fromJson(Map<String, dynamic> json) => DocumentoModel(
        nome: json["nome"],
        id: json["id"],
        formAva: json["formAva"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "id": id,
        "formAva": formAva,
        "key": key,
      };
}
