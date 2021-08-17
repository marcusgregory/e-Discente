// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:uni_discente/chat/stores/list_messages.store.dart';

import '../app_instance.dart';
import 'evento_digitando.model.dart';

part 'chat_item.model.g.dart';

ChatItemModel chatItemFromJson(String str) =>
    _ChatItemModelBase.fromJson(json.decode(str));

String chatItemToJson(ChatItemModel data) => json.encode(data.toJson());

ChatItemModel chatItemFromMap(Map<String, dynamic> str) =>
    _ChatItemModelBase.fromJson(str);

Map<String, dynamic> chatItemToMap(ChatItemModel data) => data.toJson();

class ChatItemModel = _ChatItemModelBase with _$ChatItemModel;

abstract class _ChatItemModelBase with Store {
  int unreadedCounter = 0;
  ListMessagesStore messagesStore;
  String gid;
  List<String> members;
  DateTime createdAt;
  String createdBy;
  DateTime modifiedAt;
  String name;
  @observable
  EventoDigitandoModel eventoDigitando;
  @observable
  String itemSubtitle = '';
  @observable
  RecentMessage _recentMessage;
  StreamSubscription subscription;

  _ChatItemModelBase({
    this.gid,
    this.members,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.name,
    RecentMessage recentMessage,
  }) : _recentMessage = recentMessage {
    messagesStore = ListMessagesStore(this);
    subscription = AppInstance.socketStore.eventoDigitandoStream
        .listen((EventoDigitandoModel eventoDigitando) {
      receberEventoDigitando(eventoDigitando);
    });
  }
  factory _ChatItemModelBase.fromJson(Map<String, dynamic> json) =>
      ChatItemModel(
        gid: json["gid"],
        members: List<String>.from(json["members"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        createdBy: json["createdBy"],
        modifiedAt: DateTime.parse(json["modifiedAt"]),
        name: json["name"],
        recentMessage: RecentMessage.fromJson(json["recentMessage"]),
      );

  Map<String, dynamic> toJson() => {
        "gid": gid,
        "members": List<dynamic>.from(members.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "createdBy": createdBy,
        "modifiedAt": modifiedAt.toIso8601String(),
        "name": name,
        "recentMessage": _recentMessage.toJson(),
      };

  @computed
  String get recentMessage {
    if (messagesStore.mensagens.isNotEmpty) {
      var lastMessage = messagesStore.mensagens.last;
      return (AppInstance.nomeUsuario.toLowerCase().trim() ==
                  lastMessage.sendBy.toLowerCase().trim()
              ? 'Você'
              : '${lastMessage.sendBy}') +
          ': ${lastMessage.messageText}';
    }
    /* else if (_recentMessage != null) {
      return '${_recentMessage.sentBy}: ${_recentMessage.messageText}';
    }*/
    return '';
  }

  sumCounter() {
    unreadedCounter++;
  }

  resetCounter() {
    unreadedCounter = 0;
  }

  @computed
  bool get isTyping =>
      eventoDigitando != null &&
      eventoDigitando.sendBy.toLowerCase().trim() !=
          AppInstance.nomeUsuario.toLowerCase().trim();

  @computed
  String get typingText =>
      (AppInstance.nomeUsuario.toLowerCase().trim() ==
              eventoDigitando.sendBy.toLowerCase().trim()
          ? 'Você'
          : '${eventoDigitando.sendBy}') +
      ' está digitando';

  @action
  receberEventoDigitando(EventoDigitandoModel digitandoModel) {
    if (digitandoModel.gid == this.gid) {
      _onDigitandoHandler(digitandoModel);
    }
  }

  Timer _searchOnStoppedTyping;
  @action
  _onDigitandoHandler(EventoDigitandoModel digitandoModel) {
    const duration = Duration(
        milliseconds:
            800); //set the duration that you want call stopTyping() after that.
    if (_searchOnStoppedTyping != null) {
      _searchOnStoppedTyping.cancel();
      //clear timer
      eventoDigitando = digitandoModel;
      itemSubtitle = '${digitandoModel.sendBy.trim()} está digitando...';
    }
    _searchOnStoppedTyping = new Timer(duration, () => stopTyping());
  }

  @action
  stopTyping() {
    eventoDigitando = null;
  }

  void dispose() {
    subscription.cancel();
  }
}

class RecentMessage {
  RecentMessage({
    this.messageText,
    this.sentBy,
    this.sentAt,
    this.readBy,
  });

  String messageText;
  String sentBy;
  DateTime sentAt;
  List<String> readBy;

  factory RecentMessage.fromJson(Map<String, dynamic> json) => RecentMessage(
        messageText: json["messageText"],
        sentBy: json["sentBy"],
        sentAt: DateTime.parse(json["sentAt"]),
        readBy: List<String>.from(json["readBy"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "messageText": messageText,
        "sentBy": sentBy,
        "sentAt": sentAt.toIso8601String(),
        "readBy": List<dynamic>.from(readBy.map((x) => x)),
      };
}
