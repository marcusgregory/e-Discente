// @dart=2.9
import 'package:uni_discente/models/participante.model.dart';

class DocenteModel extends ParticipanteModel {
  String departamento;
  String nivel;
  DocenteModel(
      {String urlFoto,
      String nome,
      String usuario,
      String email,
      this.departamento,
      this.nivel})
      : super(urlFoto, nome, usuario, email);

  factory DocenteModel.fromJson(Map<String, dynamic> json) => DocenteModel(
        urlFoto: json["urlFoto"],
        nome: json["nome"],
        departamento: json["departamento"],
        nivel: json["nivel"],
        usuario: json["usuario"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "urlFoto": urlFoto,
        "nome": nome,
        "departamento": departamento,
        "nivel": nivel,
        "usuario": usuario,
        "email": email,
      };
}
