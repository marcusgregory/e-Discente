import 'dart:convert';

Portal portalFromJson(String str) => Portal.fromJson(json.decode(str));

String portalToJson(Portal data) => json.encode(data.toJson());

class Portal {
  Portal({
    required this.atualizacoesTurmas,
    required this.atividades,
  });

  List<AtualizacoesTurma> atualizacoesTurmas;
  List<Atividade> atividades;

  factory Portal.fromJson(Map<String, dynamic> json) => Portal(
        atualizacoesTurmas: List<AtualizacoesTurma>.from(
            json["atualizacoesTurmas"]
                .map((x) => AtualizacoesTurma.fromJson(x))),
        atividades: List<Atividade>.from(
            json["atividades"].map((x) => Atividade.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "atualizacoesTurmas":
            List<dynamic>.from(atualizacoesTurmas.map((x) => x.toJson())),
        "atividades": List<dynamic>.from(atividades.map((x) => x.toJson())),
      };
}

class Atividade {
  Atividade({
    required this.idTurma,
    required this.idAtividade,
    required this.nomeDisciplina,
    required this.expirada,
    required this.data,
    required this.hora,
    required this.conteudo,
  });

  String idTurma;
  String idAtividade;
  String nomeDisciplina;
  bool expirada;
  String data;
  String hora;
  String conteudo;

  factory Atividade.fromJson(Map<String, dynamic> json) => Atividade(
        idTurma: json["idTurma"],
        idAtividade: json["idAtividade"],
        nomeDisciplina: json["nomeDisciplina"],
        expirada: json["expirada"],
        data: json["data"],
        hora: json["hora"],
        conteudo: json["conteudo"],
      );

  Map<String, dynamic> toJson() => {
        "idTurma": idTurma,
        "idAtividade": idAtividade,
        "nomeDisciplina": nomeDisciplina,
        "expirada": expirada,
        "data": data,
        "hora": hora,
        "conteudo": conteudo,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Atividade &&
          runtimeType == other.runtimeType &&
          idAtividade == other.idAtividade &&
          idTurma == other.idTurma;

  @override
  int get hashCode => idAtividade.hashCode + idTurma.hashCode;
}

class AtualizacoesTurma {
  AtualizacoesTurma({
    required this.idTurma,
    required this.nomeDisciplina,
    required this.conteudo,
    required this.data,
  });

  String idTurma;
  String nomeDisciplina;
  String conteudo;
  String data;

  factory AtualizacoesTurma.fromJson(Map<String, dynamic> json) =>
      AtualizacoesTurma(
        idTurma: json["idTurma"],
        nomeDisciplina: json["nomeDisciplina"],
        conteudo: json["conteudo"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "idTurma": idTurma,
        "nomeDisciplina": nomeDisciplina,
        "conteudo": conteudo,
        "data": data,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AtualizacoesTurma &&
          runtimeType == other.runtimeType &&
          nomeDisciplina == other.nomeDisciplina &&
          idTurma == other.idTurma &&
          data == other.data &&
          conteudo == other.conteudo;

  @override
  int get hashCode =>
      nomeDisciplina.hashCode +
      idTurma.hashCode +
      data.hashCode +
      conteudo.hashCode;
}
