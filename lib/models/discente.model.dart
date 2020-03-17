import 'package:uni_discente/models/participante.model.dart';

class DiscenteModel extends ParticipanteModel {
  String curso;
  String matricula;
  DiscenteModel(
      {String urlFoto,
      String nome,
      String usuario,
      String email,
      this.curso,
      this.matricula})
      : super(urlFoto, nome, usuario, email);

  factory DiscenteModel.fromJson(Map<String, dynamic> json) => DiscenteModel(
        urlFoto: json["urlFoto"],
        nome: json["nome"],
        curso: json["curso"],
        matricula: json["matricula"],
        usuario: json["usuario"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "urlFoto": urlFoto,
        "nome": nome,
        "curso": curso,
        "matricula": matricula,
        "usuario": usuario,
        "email": email,
      };
}
