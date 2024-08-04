import 'dart:convert';

import 'i_message.dart';

class MessageModel extends IMessage {
  String messageText;
  MessageModel({
    String type = 'message',
    required String mid,
    required String gid,
    required this.messageText,
    required DateTime sendAt,
    required String sendBy,
    String? profilePicUrl,
    MessageState? state,
  }) : super(
            type: type,
            mid: mid,
            gid: gid,
            sendAt: sendAt,
            sendBy: sendBy,
            profilePicUrl: profilePicUrl,
            state: state ?? MessageState.SENDING);

  @override
  MessageModel copyWith({
    String? type,
    String? mid,
    String? gid,
    String? messageText,
    DateTime? sendAt,
    String? sendBy,
    String? profilePicUrl,
    MessageState? state,
  }) {
    return MessageModel(
      type: type ?? this.type,
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
      'type': type,
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
      type: map['type'] ?? 'message',
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
    return 'MessageModel(type: $type, mid: $mid, gid: $gid, messageText: $messageText, sendAt: $sendAt, sendBy: $sendBy, profilePicUrl: $profilePicUrl, state: $state)';
  }
}
