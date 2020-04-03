import 'dart:convert';
import 'nota.model.dart';

class NotasTurmaModel {
    String recuperacao;
    String resultado;
    String faltas;
    String situacao;
    List<Nota> notas;

    NotasTurmaModel({
        this.recuperacao,
        this.resultado,
        this.faltas,
        this.situacao,
        this.notas,
    });

    factory NotasTurmaModel.fromRawJson(String str) => NotasTurmaModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NotasTurmaModel.fromJson(Map<String, dynamic> json) => NotasTurmaModel(
        recuperacao: json["recuperacao"],
        resultado: json["resultado"],
        faltas: json["faltas"],
        situacao: json["situacao"],
        notas: List<Nota>.from(json["notas"].map((x) => Nota.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "recuperacao": recuperacao,
        "resultado": resultado,
        "faltas": faltas,
        "situacao": situacao,
        "notas": List<dynamic>.from(notas.map((x) => x.toJson())),
    };
}
