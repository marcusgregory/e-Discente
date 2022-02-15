import 'dart:convert';

import 'package:e_discente/chat/models/evento_digitando.model.dart';
import 'package:flutter/foundation.dart';

import 'package:e_discente/chat/models/message.model.dart';
import 'package:e_discente/chat/stores/messages.store.dart';

class ChatItemModel {
  String gid;
  String name;
  MessageModel recentMessage;
  int unreadedCounter;
  List<String> members;
  DateTime createdAt;
  String createdBy;
  DateTime modifiedAt;
  MessagesStore? messagesStore;
  EventoDigitandoModel? eventoDigitando;
  ChatItemModel(
      {required this.gid,
      required this.name,
      required this.recentMessage,
      this.unreadedCounter = 0,
      required this.members,
      required this.createdAt,
      required this.createdBy,
      required this.modifiedAt,
      this.messagesStore,
      this.eventoDigitando}) {
    messagesStore == null
        ? messagesStore = MessagesStore(gid)
        : this.messagesStore;
  }

  Map<String, dynamic> toMap() {
    return {
      'gid': gid,
      'name': name,
      'recentMessage': recentMessage.toMap(),
      'unreadedCounter': unreadedCounter,
      'members': members,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

  factory ChatItemModel.fromMap(Map<String, dynamic> map) {
    return ChatItemModel(
      gid: map['gid'] ?? '',
      name: map['name'] ?? '',
      recentMessage: MessageModel.fromMap(map['recentMessage']),
      unreadedCounter: map['unreadedCounter']?.toInt() ?? 0,
      members: List<String>.from(map['members']),
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'] ?? '',
      modifiedAt: DateTime.parse(map['modifiedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatItemModel.fromJson(String source) =>
      ChatItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatItemModel(gid: $gid, name: $name, recentMessage: $recentMessage, unreadedCounter: $unreadedCounter, members: $members, createdAt: $createdAt, createdBy: $createdBy, modifiedAt: $modifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatItemModel &&
        other.gid == gid &&
        other.name == name &&
        other.recentMessage == recentMessage &&
        other.unreadedCounter == unreadedCounter &&
        listEquals(other.members, members) &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy &&
        other.modifiedAt == modifiedAt;
  }

  @override
  int get hashCode {
    return gid.hashCode ^
        name.hashCode ^
        recentMessage.hashCode ^
        unreadedCounter.hashCode ^
        members.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode ^
        modifiedAt.hashCode;
  }

  ChatItemModel copyWith(
      {String? gid,
      String? name,
      MessageModel? recentMessage,
      int? unreadedCounter,
      List<String>? members,
      DateTime? createdAt,
      String? createdBy,
      DateTime? modifiedAt,
      MessagesStore? messagesStore,
      EventoDigitandoModel? eventoDigitando}) {
    return ChatItemModel(
      gid: gid ?? this.gid,
      name: name ?? this.name,
      recentMessage: recentMessage ?? this.recentMessage,
      unreadedCounter: unreadedCounter ?? this.unreadedCounter,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      messagesStore: messagesStore ?? this.messagesStore,
      eventoDigitando: eventoDigitando,
    );
  }
}
