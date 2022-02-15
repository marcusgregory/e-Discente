import 'dart:convert';

import '../app_instance.dart';

class MessageModel implements Comparable {
  String mid;
  String gid;
  String messageText;
  DateTime sendAt;
  String sendBy;
  String profilePicUrl;
  MessageState state;
  MessageModel({
    required this.mid,
    required this.gid,
    required this.messageText,
    required this.sendAt,
    required this.sendBy,
    String? profilePicUrl,
    this.state = MessageState.SENDING,
  }) : profilePicUrl = profilePicUrl ??
            '${AppInstance.apiURL}/user/profilepic/${sendBy.toLowerCase().trim()}';

  @override
  int compareTo(other) {
    return sendAt.compareTo(other.sendAt);
  }

  MessageModel copyWith({
    String? mid,
    String? gid,
    String? messageText,
    DateTime? sendAt,
    String? sendBy,
    String? profilePicUrl,
    MessageState? state,
  }) {
    return MessageModel(
      mid: mid ?? this.mid,
      gid: gid ?? this.gid,
      messageText: messageText ?? this.messageText,
      sendAt: sendAt ?? this.sendAt,
      sendBy: sendBy ?? this.sendBy,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mid': mid,
      'gid': gid,
      'messageText': messageText,
      'sendAt': sendAt.toIso8601String(),
      'sendBy': sendBy,
      'profilePicUrl': profilePicUrl,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      mid: map['mid'],
      gid: map['gid'],
      messageText: map['messageText'],
      sendAt: DateTime.parse(map['sendAt']),
      sendBy: map['sendBy'],
      profilePicUrl: map['profilePicUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageModel(mid: $mid, gid: $gid, messageText: $messageText, sendAt: $sendAt, sendBy: $sendBy, profilePicUrl: $profilePicUrl, state: $state)';
  }
}

enum MessageState { SENDED, SENDING, ERROR }
