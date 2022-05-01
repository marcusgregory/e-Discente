import '../app_instance.dart';

abstract class IMessage implements Comparable {
  String type;
  String mid;
  String gid;
  DateTime sendAt;
  String sendBy;
  String? profilePicUrl;
  MessageState state;
  IMessage({
    required this.type,
    required this.mid,
    required this.gid,
    required this.sendAt,
    required this.sendBy,
    required this.profilePicUrl,
    this.state = MessageState.SENDING,
  }) {
    profilePicUrl = profilePicUrl ??
        '${AppInstance.apiURL}/user/profilepic/${sendBy.toLowerCase().trim()}';
  }

  @override
  int compareTo(other) {
    return sendAt.compareTo(other.sendAt);
  }

  IMessage copyWith({
    String? type,
    String? mid,
    String? gid,
    DateTime? sendAt,
    String? sendBy,
    String? profilePicUrl,
    MessageState? state,
  });

  @override
  bool operator ==(Object other) {
    return other is IMessage && other.mid == mid;
  }

  @override
  int get hashCode {
    return mid.hashCode;
  }
}

enum MessageState { SENDED, SENDING, ERROR }
