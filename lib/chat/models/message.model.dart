// @dart=2.9
import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:uni_discente/chat/app_instance.dart';
import 'package:uni_discente/chat/stores/list_messages.store.dart';
import 'package:uuid/uuid.dart';

part 'message.model.g.dart';

MessageModel messageFromJson(String str) =>
    _MessageModelBase.fromJson(json.decode(str));

String messageToJson(MessageModel data) => json.encode(data.toJson());

MessageModel messageFromMap(Map<String, dynamic> str) =>
    _MessageModelBase.fromJson(str);

Map<String, dynamic> messageToMap(MessageModel data) => data.toJson();

class MessageModel = _MessageModelBase with _$MessageModel;

abstract class _MessageModelBase with Store implements Comparable {
  _MessageModelBase(
      {String mid,
      this.gid,
      this.messageText,
      this.sendAt,
      this.sendBy,
      String profilePic})
      : _mid = mid ?? Uuid().v1(),
        profilePicUrl = profilePic ??
            '${AppInstance.apiURL}/user/profilepic/${sendBy.toLowerCase().trim()}';

  String _mid;

  String get mid => _mid;

  @observable
  String gid;

  @observable
  String messageText;

  @observable
  DateTime sendAt;

  @observable
  String sendBy;

  @observable
  String profilePicUrl;

  @observable
  MessageState state = MessageState.SENDING;

  @override
  int compareTo(other) {
    return sendAt.compareTo(other.sendAt);
  }

  @action
  void enviarMensagem(ListMessagesStore store) {
    store.enviarMensagem(this, (ack) {
      state = MessageState.SENDED;
      print('Mensagem recebida no servidor.');
    });
  }

  factory _MessageModelBase.fromJson(Map<String, dynamic> json) => MessageModel(
        mid: json["mid"],
        gid: json["gid"],
        messageText: json["messageText"],
        sendAt: DateTime.parse(json["sendAt"]),
        sendBy: json["sendBy"],
        profilePic: json["profilePicUrl"],
      );

  Map<String, dynamic> toJson() => {
        "mid": _mid,
        "gid": gid,
        "messageText": messageText,
        "sendAt": sendAt.toIso8601String(),
        "sendBy": sendBy,
        "profilePicUrl": profilePicUrl,
      };
}

enum MessageState { SENDED, SENDING }
