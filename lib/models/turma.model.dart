class TurmaModel implements Comparable<TurmaModel> {
  String? codigo;
  String? nomeTurma;
  String? docente;
  String? local;
  String? horario;
  String? idTurma;

  TurmaModel(
      {this.codigo,
      this.nomeTurma,
      this.docente,
      this.local,
      this.horario,
      this.idTurma});

  TurmaModel.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nomeTurma = json['nomeTurma'];
    docente = json['docente'];
    local = json['local'];
    horario = json['horario'];
    idTurma = json['idTurma'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codigo'] = codigo;
    data['nomeTurma'] = nomeTurma;
    data['docente'] = docente;
    data['local'] = local;
    data['horario'] = horario;
    data['idTurma'] = idTurma;
    return data;
  }

  @override
  int compareTo(TurmaModel other) {
    return horario?.compareTo(other.horario ?? '') ?? 0;
  }
}
