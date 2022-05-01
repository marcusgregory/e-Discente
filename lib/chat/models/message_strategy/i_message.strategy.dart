import '../i_message.dart';

abstract class IMessageStrategy {
  IMessage createMessage(dynamic model);
}
