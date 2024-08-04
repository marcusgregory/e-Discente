class BoletimModel {
  String? codigo;
  String? disciplina;
  String? nota1;
  String? nota2;
  String? nota3;
  String? nota4;
  String? nota5;
  String? recuperacao;
  String? resultado;
  String? faltas;
  String? situacao;

  BoletimModel(
      {this.codigo,
      this.disciplina,
      this.nota1,
      this.nota2,
      this.nota3,
      this.recuperacao,
      this.resultado,
      this.faltas,
      this.situacao});

  BoletimModel.fromJson(Map<String, dynamic> json) {
    codigo = json["codigo"];
    disciplina = json["disciplina"];
    nota1 = json["nota1"];
    nota2 = json["nota2"];
    nota3 = json["nota3"];
    nota4 = json["nota4"];
    nota5 = json["nota5"];
    recuperacao = json["recuperacao"];
    resultado = json["resultado"];
    faltas = json["faltas"];
    situacao = json["situacao"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["codigo"] = codigo;
    data["disciplina"] = disciplina;
    data["nota1"] = nota1;
    data["nota2"] = nota2;
    data["nota3"] = nota3;
    data["nota4"] = nota4;
    data["nota5"] = nota5;
    data["recuperacao"] = recuperacao;
    data["resultado"] = resultado;
    data["faltas"] = faltas;
    data["situacao"] = situacao;
    return data;
  }
}
