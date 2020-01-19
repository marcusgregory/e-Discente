class TurmaModel {
  String codigo;
  String nomeTurma;
  String docente;
  String local;
  String horario;
  String idTurma;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nomeTurma'] = this.nomeTurma;
    data['docente'] = this.docente;
    data['local'] = this.local;
    data['horario'] = this.horario;
    data['idTurma'] = this.idTurma;
    return data;
  }
}
