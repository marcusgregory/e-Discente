import 'package:e_discente/chat/widgets/message_bubble_text.widget.dart';
import 'package:flutter/material.dart';

import 'package:e_discente/chat/models/message.model.dart';
import 'package:e_discente/chat/widgets/i_message_bubble.dart';

class MessageBubbleText implements IMessageBubble {
  MessageModel message;
  bool isOwn;
  bool showAvatar;
  bool showUserName;
  BuildContext context;

  MessageBubbleText({
    required this.message,
    required this.context,
    this.isOwn = true,
    this.showAvatar = false,
    this.showUserName = false,
  }) {
    if (isOwn) {
      showAvatar = false;
    }
  }

  @override
  Widget render() {
    return MessageBubbleTextWidget(
      key: ValueKey(message.mid),
      message: message,
      isOwn: isOwn,
      showAvatar: showAvatar,
      showUserName: showUserName,
      context: context,
    );
  }
}
