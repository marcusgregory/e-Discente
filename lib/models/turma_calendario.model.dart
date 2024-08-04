class TurmaCalendario implements Comparable {
  TurmaCalendario({
    required this.codigo,
    required this.nomeTurma,
    required this.docente,
    required this.local,
    required this.horario,
    required this.idTurma,
    required this.calendario,
    required this.horariosDefinidos,
  });

  String codigo;
  String nomeTurma;
  String docente;
  String local;
  String horario;
  String idTurma;
  Calendario calendario;
  List<HorariosDefinido> horariosDefinidos;

  factory TurmaCalendario.fromJson(Map<String, dynamic> json) =>
      TurmaCalendario(
        codigo: json["codigo"],
        nomeTurma: json["nomeTurma"],
        docente: json["docente"] ?? '',
        local: json["local"],
        horario: json["horario"],
        idTurma: json["idTurma"],
        calendario: Calendario.fromJson(json["calendario"]),
        horariosDefinidos: List<HorariosDefinido>.from(
            json["horariosDefinidos"].map((x) => HorariosDefinido.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nomeTurma": nomeTurma,
        "docente": docente,
        "local": local,
        "horario": horario,
        "idTurma": idTurma,
        "calendario": calendario.toJson(),
        "horariosDefinidos":
            List<dynamic>.from(horariosDefinidos.map((x) => x.toJson())),
      };

  @override
  int compareTo(other) {
    return horariosDefinidos.first.horarioInicial
        .compareTo(other.horariosDefinidos.first.horarioInicial);
  }
}

class Calendario {
  Calendario({
    required this.inicioPeriodo,
    required this.fimPeriodo,
    required this.datasAulas,
  });

  String inicioPeriodo;
  String fimPeriodo;
  List<String> datasAulas;

  factory Calendario.fromJson(Map<String, dynamic> json) => Calendario(
        inicioPeriodo: json["inicioPeriodo"],
        fimPeriodo: json["fimPeriodo"],
        datasAulas: List<String>.from(json["datasAulas"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "inicioPeriodo": inicioPeriodo,
        "fimPeriodo": fimPeriodo,
        "datasAulas": List<dynamic>.from(datasAulas.map((x) => x)),
      };
}

class HorariosDefinido {
  HorariosDefinido({
    required this.dias,
    required this.horarioInicial,
    required this.horarioFinal,
  });

  List<String> dias;
  String horarioInicial;
  String horarioFinal;

  factory HorariosDefinido.fromJson(Map<String, dynamic> json) =>
      HorariosDefinido(
        dias: List<String>.from(json["dias"].map((x) => x)),
        horarioInicial: json["horarioInicial"],
        horarioFinal: json["horarioFinal"],
      );

  Map<String, dynamic> toJson() => {
        "dias": List<dynamic>.from(dias.map((x) => x)),
        "horarioInicial": horarioInicial,
        "horarioFinal": horarioFinal,
      };
}
