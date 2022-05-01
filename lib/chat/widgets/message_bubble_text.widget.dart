import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linkwell/linkwell.dart';

import '../../pages/widgets/photo_view.widget.dart';
import '../models/i_message.dart';
import '../models/message.model.dart';

class MessageBubbleTextWidget extends StatelessWidget {
  final MessageModel message;
  final bool isOwn;
  final bool showAvatar;
  final bool showUserName;
  final BuildContext context;

  const MessageBubbleTextWidget({
    Key? key,
    required this.message,
    required this.context,
    this.isOwn = true,
    this.showAvatar = false,
    this.showUserName = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        AvatarWidget(isOwn: isOwn, message: message, showAvatar: showAvatar),
        _content(),
      ],
    );
  }

  Widget _content() {
    final _dateFormat = DateFormat('HH:mm');
    return Container(
      constraints: BoxConstraints(
        minWidth: 50,
        maxWidth: MediaQuery.of(context).size.width * .78,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: showUserName && !isOwn,
                  child: Text(
                    message.sendBy,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.caption!.fontSize! *
                                1.3),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                LinkWell(message.messageText,
                    linkStyle: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.caption!.fontSize! *
                                1.15,
                        color: Colors.blue),
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.caption!.fontSize! *
                                1.15,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).textTheme.bodyText1!.color
                            : isOwn
                                ? Colors.black
                                : Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color)),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _dateFormat.format(message.sendAt.toLocal()),
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[700]
                            : !isOwn
                                ? null
                                : Colors.grey[700],
                        fontSize:
                            Theme.of(context).textTheme.caption!.fontSize),
                  ),
                ],
              ),
              const SizedBox(
                width: 3,
              ),
              Visibility(visible: isOwn, child: _messageStatus())
            ],
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      decoration: BoxDecoration(
        color: isOwn
            ? Theme.of(context).brightness == Brightness.light
                ? Colors.lightBlue[100]
                : Theme.of(context).colorScheme.primary
            : Theme.of(context).brightness == Brightness.light
                ? Colors.grey[300]
                : Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      margin: isOwn
          ? const EdgeInsets.only(bottom: 5, right: 7)
          : const EdgeInsets.only(bottom: 5, left: 7),
    );
  }

  Widget _messageStatus() {
    switch (message.state) {
      case MessageState.SENDED:
        return Icon(Icons.check_rounded,
            size: Theme.of(context).textTheme.caption!.fontSize! * 1.2,
            color: Theme.of(context).brightness == Brightness.light
                ? null
                : Colors.black);
      case MessageState.SENDING:
        return Icon(Icons.access_time_rounded,
            size: Theme.of(context).textTheme.caption!.fontSize,
            color: Theme.of(context).brightness == Brightness.light
                ? null
                : Colors.black);
      case MessageState.ERROR:
        return Icon(Icons.access_time_rounded,
            size: Theme.of(context).textTheme.caption!.fontSize,
            color: Theme.of(context).brightness == Brightness.light
                ? null
                : Colors.black);
      default:
        return Container();
    }
  }
}

class AvatarWidget extends StatelessWidget {
  final MessageModel message;
  final bool isOwn;
  final bool showAvatar;

  const AvatarWidget(
      {Key? key,
      required this.isOwn,
      required this.message,
      required this.showAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isOwn && showAvatar
        ? Padding(
            padding: const EdgeInsets.only(left: 7),
            child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey[200],
                child: CachedNetworkImage(
                  imageUrl: message.profilePicUrl ?? '',
                  placeholder: (context, url) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: Image.asset('assets/profile_pic.png').image,
                            fit: BoxFit.cover),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: Image.asset('assets/profile_pic.png').image,
                            fit: BoxFit.cover),
                      ),
                    );
                  },
                  imageBuilder: (context, imageProvider) => Hero(
                    tag: message.mid,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return PhotoViewWidget(message.profilePicUrl ?? '',
                              tag: message.mid);
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                )))
        : Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Container(
              width: 32,
            ),
          );
  }
}
