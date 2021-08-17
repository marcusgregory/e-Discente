import 'dart:convert';

EventoDigitandoModel eventoDigitandoModelFromJson(String str) =>
    EventoDigitandoModel.fromJson(json.decode(str));

String eventoDigitandoModelToJson(EventoDigitandoModel data) =>
    json.encode(data.toJson());

class EventoDigitandoModel {
  EventoDigitandoModel({
    this.eventType,
    this.gid,
    this.sendBy,
  });

  final String? eventType;
  final String? gid;
  final String? sendBy;

  factory EventoDigitandoModel.fromJson(Map<String, dynamic> json) =>
      EventoDigitandoModel(
        eventType: json["EVENT_TYPE"],
        gid: json["gid"],
        sendBy: json["sendBy"],
      );

  Map<String, dynamic> toJson() => {
        "EVENT_TYPE": eventType,
        "gid": gid,
        "sendBy": sendBy,
      };
}
