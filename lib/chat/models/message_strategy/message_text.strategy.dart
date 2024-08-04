import 'package:e_discente/chat/models/i_message.dart';
import 'package:e_discente/chat/models/message_strategy/i_message.strategy.dart';

import '../message.model.dart';

class MessageTextStrategy implements IMessageStrategy {
  @override
  MessageModel createMessage(model) {
    return MessageModel.fromMap(model)..state = MessageState.SENDED;
  }
}
