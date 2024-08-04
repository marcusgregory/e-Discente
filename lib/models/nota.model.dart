
import 'dart:convert';

class Nota {
  String? descricao;
  String? valor;

  Nota({
    this.descricao,
    this.valor,
  });

  factory Nota.fromRawJson(String str) => Nota.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Nota.fromJson(Map<String, dynamic> json) => Nota(
        descricao: json["descricao"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "descricao": descricao,
        "valor": valor,
      };
}
