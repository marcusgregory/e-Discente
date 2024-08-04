
import 'discente.model.dart';
import 'docente.model.dart';

class ParticipantesModel {
  List<DocenteModel>? docentes;
  List<DiscenteModel>? discentes;

  ParticipantesModel({
    this.docentes,
    this.discentes,
  });

  factory ParticipantesModel.fromJson(Map<String, dynamic> json) =>
      ParticipantesModel(
        docentes: List<DocenteModel>.from(
            json["docentes"].map((x) => DocenteModel.fromJson(x))),
        discentes: List<DiscenteModel>.from(
            json["discentes"].map((x) => DiscenteModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "docentes": List<dynamic>.from(docentes!.map((x) => x.toJson())),
        "discentes": List<dynamic>.from(discentes!.map((x) => x.toJson())),
      };
}
