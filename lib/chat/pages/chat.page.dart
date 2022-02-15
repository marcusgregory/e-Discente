// @dart=2.9

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_discente/chat/stores/messages.store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:linkwell/linkwell.dart';
import 'package:e_discente/chat/models/chat_item.model.dart';
import 'package:e_discente/chat/models/message.model.dart';
import 'package:e_discente/chat/widgets/jumping_dots.widget.dart';
import 'package:e_discente/chat/widgets/marquee.widget.dart';
import 'package:e_discente/pages/widgets/photo_view.widget.dart';
import 'package:uuid/uuid.dart';

import '../app_instance.dart';

class ChatPage extends StatefulWidget {
  final ChatItemModel chatItem;
  ChatPage(this.chatItem);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final ScrollController listScrollController = ScrollController();
  //final listMessagesBloc = ListMessagesBloc();
  MessagesStore messagesStore;

  final f = DateFormat('HH:mm');
  DateFormat formatDateMonthDay = DateFormat(DateFormat.MONTH_DAY, 'pt_Br');
  DateFormat formatDateYearMonthDay =
      DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br');

  @override
  void initState() {
    super.initState();

    messagesStore = widget.chatItem.messagesStore;
    messagesStore.loadMessages();
    AppInstance.currentChatPageOpenId = widget.chatItem.gid;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppInstance.currentChatPageOpenId = widget.chatItem.gid;
        break;
      case AppLifecycleState.inactive:
        AppInstance.currentChatPageOpenId = '';
        break;
      case AppLifecycleState.paused:
        AppInstance.currentChatPageOpenId = '';
        break;
      case AppLifecycleState.detached:
        AppInstance.currentChatPageOpenId = '';
        break;
    }
  }

  @override
  void dispose() {
    AppInstance.currentChatPageOpenId = '';
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            AssetImage('assets/group_icon_grey_square.png')))),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 3, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MarqueeWidget(
                      direction: Axis.horizontal,
                      animationDuration: Duration(milliseconds: 5000),
                      backDuration: Duration(milliseconds: 3000),
                      child: Text(widget.chatItem.name.trim(),
                          style: TextStyle(fontSize: 15.5),
                          overflow: TextOverflow.fade),
                    ),
                    Observer(builder: (_) {
                      switch (widget.chatItem.messagesStore.typingState) {
                        case TypingState.TYPING:
                          return Row(
                            children: [
                              Text(
                                  widget.chatItem.messagesStore.eventTyping
                                          .sendBy +
                                      " está digitando",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[200],
                                      fontWeight: FontWeight.normal)),
                              JumpingDotsProgressIndicator(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .backgroundColor)
                            ],
                          );
                          break;
                        case TypingState.NOTHING:
                          return Text('',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[200],
                                  fontWeight: FontWeight.normal));
                          break;
                      }
                      return Container();
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Observer(builder: (_) {
                  // print(widget.chatItem.messagesStore.messages.toList());
                  switch (widget.chatItem.messagesStore.messagesState) {
                    case MessagesState.LOADING:
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                      break;
                    case MessagesState.READY:
                      return Observer(builder: (_) {
                        var lista =
                            widget.chatItem.messagesStore.messages.toList();
                        return GroupedListView(
                            controller: listScrollController,
                            elements: lista,
                            groupBy: (MessageModel message) => DateTime(
                                message.sendAt.toLocal().year,
                                message.sendAt.toLocal().month,
                                message.sendAt.toLocal().day),
                            order: GroupedListOrder.DESC,
                            reverse: true,
                            floatingHeader: true,
                            useStickyGroupSeparators: true,
                            shrinkWrap: true,
                            groupHeaderBuilder: (MessageModel message) =>
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            message.sendAt.year ==
                                                    DateTime.now().year
                                                ? '${formatDateMonthDay.format(message.sendAt.toLocal())}'
                                                : '${formatDateYearMonthDay.format(message.sendAt.toLocal())}',
                                            style: TextStyle(
                                                fontSize: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .fontSize *
                                                    0.9,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            indexedItemBuilder: (context,
                                    MessageModel messageModel, int index) =>
                                buildItemChat(messageModel, lista, index));
                      });
                      break;
                    case MessagesState.ERROR:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              widget.chatItem.messagesStore.loadMessages();
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                          const Text('Tentar novamente')
                        ],
                      );
                      break;
                  }
                  return Container();
                }),
              ),
            ),
            buildInput()
          ],
        ),
      ),
    );
  }

  Widget buildItemChat(
      MessageModel message, List<MessageModel> listMessages, int index) {
    listMessages = listMessages.reversed.toList();
    bool isMyMessage = false;
    if (message.sendBy.toLowerCase().trim() ==
        AppInstance.nomeUsuario.toLowerCase().trim()) {
      isMyMessage = true;
    }
    bool isFirstMessageUser = true;
    if (index + 1 < listMessages.length &&
        message.sendBy == listMessages[index + 1].sendBy) {
      isFirstMessageUser = false;
    }

    bool isLastMessage(int index) {
      if (index + 1 <= listMessages.length || listMessages != null) {
        if (index != 0 && index + 1 != listMessages.length) {
          if (listMessages[index].sendBy == listMessages[index + 1].sendBy &&
              listMessages[index].sendBy != listMessages[index - 1].sendBy) {
            return true;
          } else {
            return false;
          }
        } else {
          if (index + 1 != listMessages.length) {
            if (listMessages[index].sendBy == listMessages[index + 1].sendBy) {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        }
      } else {
        return false;
      }

      // if (index == 0 && listMessages != null) {
      //   return true;
      // } else if (index > 0 && index + 1 < listMessages.length) {
      //   if (listMessages[index + 1].sendBy == message.sendBy &&
      //       listMessages[index - 1].sendBy != message.sendBy) {
      //     return true;
      //   } else {
      //     return false;
      //   }
      // } else {
      //   return false;
      // }

      // if ((index > 0 &&
      //         listMessages != null &&
      //         listMessages[index - 1].sendBy == message.sendBy) ||
      //     index == 0) {
      //   return true;
      // } else {
      //   return false;
      // }
    }

    // print(isLastMessage(index));
    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        !isMyMessage && isFirstMessageUser
            ? Padding(
                padding: const EdgeInsets.only(left: 9),
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
                                image:
                                    Image.asset('assets/profile_pic.png').image,
                                fit: BoxFit.cover),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    Image.asset('assets/profile_pic.png').image,
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
                              return PhotoViewWidget(message.profilePicUrl,
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
                padding: const EdgeInsets.only(left: 9),
                child: Container(
                  width: 30,
                ),
              ),
        Container(
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: 250,
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
                      visible: isFirstMessageUser,
                      child: Visibility(
                        visible: !isMyMessage,
                        child: Text(
                          message.sendBy,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  Theme.of(context).textTheme.caption.fontSize *
                                      1.3),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    LinkWell(message.messageText,
                        linkStyle: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.caption.fontSize *
                                    1.15,
                            color: Colors.blue),
                        style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.caption.fontSize *
                                    1.15,
                            color: Theme.of(context).brightness ==
                                    Brightness.light
                                ? Theme.of(context).textTheme.bodyText1.color
                                : isMyMessage
                                    ? Colors.black
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color)),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        f.format(message.sendAt.toLocal()),
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[700]
                                    : !isMyMessage
                                        ? null
                                        : Colors.grey[700],
                            fontSize:
                                Theme.of(context).textTheme.caption.fontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Visibility(
                    visible: isMyMessage,
                    child: message.state == MessageState.SENDING
                        ? Icon(Icons.access_time_rounded,
                            size: Theme.of(context).textTheme.caption.fontSize,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? null
                                    : Colors.black)
                        : Icon(Icons.check_rounded,
                            size: Theme.of(context).textTheme.caption.fontSize *
                                1.2,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? null
                                    : Colors.black),
                  )
                ],
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          decoration: BoxDecoration(
            color: isMyMessage
                ? Theme.of(context).brightness == Brightness.light
                    ? Colors.lightBlue[100]
                    : Theme.of(context).accentColor
                : Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[300]
                    : Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(!isMyMessage &&
                      isLastMessage(index) &&
                      !isFirstMessageUser
                  ? 0
                  : !isMyMessage && !isFirstMessageUser && !isLastMessage(index)
                      ? 8
                      : 20),
              topRight: Radius.circular(isMyMessage &&
                      isLastMessage(index) &&
                      !isFirstMessageUser
                  ? 0
                  : isMyMessage && !isFirstMessageUser && !isLastMessage(index)
                      ? 8
                      : 20),
              bottomLeft: Radius.circular(!isMyMessage && isFirstMessageUser
                  ? 0
                  : !isMyMessage && !isFirstMessageUser && !isLastMessage(index)
                      ? 8
                      : 20),
              bottomRight: Radius.circular(isMyMessage && isFirstMessageUser
                  ? 0
                  : isMyMessage && !isFirstMessageUser && !isLastMessage(index)
                      ? 8
                      : 20),
            ),
          ),
          margin: isMyMessage
              ? EdgeInsets.only(bottom: 5, right: 10)
              : EdgeInsets.only(bottom: 5, left: 10),
        ),
      ],
    );
  }

  Widget buildInput() {
    var textEditingController = TextEditingController();
    return Row(
      children: <Widget>[
        // Button send image
        Material(
          child: Container(
            child: IconButton(
              icon: Icon(Icons.image_outlined),
              onPressed: () => {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Material(
            child: Container(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.emoji_emotions_outlined),
                  onPressed: () => {},
                ),
              ),
            ),
          ),
        ),

        // Edit text
        Flexible(
          child: Container(
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r".*[^ ].*")),
                FilteringTextInputFormatter.deny(RegExp(r"^[\n\r]")),
              ],
              autocorrect: true,
              readOnly: false,
              showCursor: true,
              maxLines: 5,
              minLines: 1,
              autofocus: true,
              onChanged: (_) {
                widget.chatItem.messagesStore.sendTypingEvent();
              },
              style: TextStyle(fontSize: 15.0),
              controller: textEditingController,
              decoration: InputDecoration(
                isCollapsed: false,
                border: InputBorder.none,
                hintText: 'Mensagem',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        // Button send message
        Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                if (textEditingController.text.isNotEmpty &&
                    !textEditingController.text.startsWith(" ")) {
                  widget.chatItem.messagesStore.sendMessage(MessageModel(
                      gid: widget.chatItem.gid,
                      messageText: textEditingController.text
                          .replaceAll(RegExp(r"[\n\r]$"), "")
                          .replaceAll(RegExp(r"^[\n\r]"), "")
                          .trim(),
                      sendAt: DateTime.now(),
                      sendBy: AppInstance.nomeUsuario.toLowerCase().trim(),
                      mid: Uuid().v1()));

                  listScrollController.animateTo(0.0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                  textEditingController.clear();
                }
              },
            )),
      ],
    );
  }
}
