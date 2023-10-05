import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:e_discente/chat/models/i_message.dart';
import 'package:e_discente/chat/models/message.model.dart';
import 'package:e_discente/chat/stores/chats.store.dart';
import 'package:e_discente/chat/stores/messages.store.dart';
import 'package:e_discente/chat/utils/user.util.dart';
import 'package:e_discente/chat/widgets/jumping_dots.widget.dart';
import 'package:e_discente/chat/widgets/marquee.widget.dart';
import 'package:e_discente/chat/widgets/message_bubble_text_renderer.dart';

import '../app_instance.dart';
import '../external/emoji_picker/category_icons.dart';
import '../external/emoji_picker/config.dart';
import '../external/emoji_picker/emoji_picker.dart' as emoji_picker;

class ChatPage extends StatefulWidget {
  final String gid;
  final String groupName;

  const ChatPage({Key? key, required this.gid, required this.groupName})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final ScrollController listScrollController = ScrollController();
  //final listMessagesBloc = ListMessagesBloc();
  MessagesStore? messagesStore;

  final f = DateFormat('HH:mm');
  DateFormat formatDateMonthDay = DateFormat(DateFormat.MONTH_DAY, 'pt_Br');
  DateFormat formatDateYearMonthDay =
      DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br');
  bool showScrollButton = false;
  late StreamController<bool> stream;
  bool showEmoji = false;
  late StreamController<bool> emoji;
  var textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    AppInstance.currentPageLastOpenedId = widget.gid;
    AppInstance.currentChatPageOpenId = widget.gid;
    stream = StreamController<bool>();
    emoji = StreamController<bool>();
    stream.sink.add(showScrollButton);
    for (var element in GetIt.I<ChatsStore>().listChats) {
      if (element.gid == widget.gid) {
        messagesStore = element.messagesStore;
      }
    }
    if (messagesStore != null) {
      if (!messagesStore!.firstRun) {
        messagesStore?.loadMessages();
      }
    } else {
      Navigator.of(context).pop();
    }

    listScrollController.addListener(() {
      if (listScrollController.position.pixels > 500) {
        if (mounted && showScrollButton == false) {
          showScrollButton = true;
          stream.add(showScrollButton);
        }
      } else {
        if (mounted && showScrollButton == true) {
          showScrollButton = false;
          stream.add(showScrollButton);
        }
      }

      if (listScrollController.position.pixels >=
              listScrollController.position.maxScrollExtent &&
          !(messagesStore!.isLoadingMore) &&
          !(messagesStore!.loadedAllMessages)) {
        messagesStore!.loadMoreMessages();
      }
    });
    focusNode.addListener(onFocusChange);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppInstance.currentChatPageOpenId = widget.gid;
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
    if (AppInstance.currentChatPageOpenId == widget.gid) {
      AppInstance.currentChatPageOpenId = '';
    }

    WidgetsBinding.instance.removeObserver(this);
    AppInstance.currentPageLastOpenedId = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            AssetImage('assets/group_icon_grey_square.png')))),
            const SizedBox(
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
                      child: Text(widget.groupName.trim(),
                          style: const TextStyle(fontSize: 15.5),
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (messagesStore != null)
                      Observer(builder: (_) {
                        switch (messagesStore!.typingState) {
                          case TypingState.TYPING:
                            return Row(
                              children: [
                                Text(
                                    UserUtil.isYouOrUser(messagesStore!
                                            .eventTyping.sendBy!) +
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
                                            .bodyLarge!
                                            .backgroundColor ??
                                        Colors.grey[200] ??
                                        Colors.grey)
                              ],
                            );
                          case TypingState.NOTHING:
                            return Text('',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[200],
                                    fontWeight: FontWeight.normal));
                        }
                      })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: onBackPress,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (messagesStore != null)
                      Observer(builder: (_) {
                        // print(widget.chatItem.messagesStore.messages.toList());
                        if (messagesStore != null) {
                          switch (messagesStore!.messagesState) {
                            case MessagesState.LOADING:
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            case MessagesState.READY:
                              return Observer(builder: (_) {
                                var lista = messagesStore!.messages.toList();
                                return GroupedListView(
                                    key: const Key('Mensagens'),
                                    addAutomaticKeepAlives: true,
                                    controller: listScrollController,
                                    elements: lista,
                                    groupBy: (IMessage message) {
                                      return DateTime(
                                          message.sendAt.toLocal().year,
                                          message.sendAt.toLocal().month,
                                          message.sendAt.toLocal().day);
                                    },
                                    order: GroupedListOrder.DESC,
                                    reverse: true,
                                    floatingHeader: true,
                                    useStickyGroupSeparators: true,
                                    groupHeaderBuilder: (IMessage message) =>
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20.0)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  message.sendAt.year ==
                                                          DateTime.now().year
                                                      ? formatDateMonthDay
                                                          .format(message.sendAt
                                                              .toLocal())
                                                      : formatDateYearMonthDay
                                                          .format(message.sendAt
                                                              .toLocal()),
                                                  style: TextStyle(
                                                      fontSize:
                                                          Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .fontSize! *
                                                              0.9,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    indexedItemBuilder: (context,
                                        IMessage messageModel, int index) {
                                      return buildItemChat(
                                          messageModel as MessageModel,
                                          lista,
                                          index);
                                    });
                              });

                            case MessagesState.ERROR:
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      messagesStore!.loadMessages();
                                    },
                                    icon: const Icon(Icons.refresh),
                                  ),
                                  const Text('Tentar novamente')
                                ],
                              );
                          }
                        }
                        return Container();
                      }),
                    if (messagesStore != null)
                      Observer(builder: (_) {
                        if (messagesStore != null) {
                          return Visibility(
                            visible: messagesStore!.isLoadingMore,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: Center(
                                          child: CircularProgressIndicator
                                              .adaptive(
                                            strokeWidth: 3.0,
                                          ),
                                        )),
                                  ),
                                )),
                          );
                        } else {
                          return Container();
                        }
                      }),
                    StreamBuilder<bool>(
                        stream: stream.stream,
                        builder: (context, snapshot) {
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity: snapshot.data ?? false ? 1.0 : 0.0,
                            child: IgnorePointer(
                              ignoring: !(snapshot.data ?? false),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: FloatingActionButton.small(
                                      backgroundColor:
                                          Theme.of(context).canvasColor,
                                      child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      onPressed: () {
                                        listScrollController.animateTo(0.0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeOut);
                                      }),
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
              buildInput(),
              StreamBuilder<bool>(
                  stream: emoji.stream,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.data ?? false) {}
                    return Visibility(
                        visible: snapshot.data ?? false, child: buildEmojis());
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmojis() {
    return Expanded(child: _emojiPicker());
  }

  Widget _emojiPicker() {
    if (kIsWeb) {
      return Container();
    } else {
      return emoji_picker.EmojiPicker(
        onBackspacePressed: () {
          textEditingController
            ..text =
                textEditingController.text.characters.skipLast(1).toString()
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: textEditingController.text.length));
        },
        config: Config(
            columns: 8,
            emojiSizeMax: 22 * (Platform.isIOS ? 1.30 : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            initCategory: emoji_picker.Category.RECENT,
            bgColor: const Color(0xFFF2F2F2),
            indicatorColor: Theme.of(context).primaryColor,
            iconColor: Colors.grey,
            iconColorSelected: Theme.of(context).primaryColor,
            progressIndicatorColor: Theme.of(context).primaryColor,
            backspaceColor: Theme.of(context).primaryColor,
            skinToneDialogBgColor: Colors.white,
            skinToneIndicatorColor: Colors.grey,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 28,
            noRecents: const Text(
              'Sem emojis recentes',
              style: TextStyle(fontSize: 20, color: Colors.black26),
            ),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: emoji_picker.ButtonMode.MATERIAL),
        onEmojiSelected: (category, emoji) {
          textEditingController
            ..text += emoji.emoji
            ..selection = TextSelection.fromPosition(
                TextPosition(offset: textEditingController.text.length));
        },
      );
    }
  }

  Widget buildItemChat(
      MessageModel message, List<IMessage> listMessages, int index) {
    listMessages = listMessages.reversed.toList();
    bool isMyMessage = false;
    if (message.sendBy.toLowerCase().trim() ==
        AppInstance.nomeUsuario.toLowerCase().trim()) {
      isMyMessage = true;
    }
    bool isFirstMessageUser() {
      if (index + 1 < listMessages.length &&
          message.sendBy == listMessages[index + 1].sendBy) {
        return false;
      }
      return true;
    }

    bool isLastMessage() {
      if (index <= listMessages.length - 1) {
        if (index > 0 && index + 1 != listMessages.length) {
          if (isFirstMessageUser() &&
              listMessages[index].sendBy != listMessages[index - 1].sendBy) {
            return true;
          }
          if (listMessages[index].sendBy == listMessages[index + 1].sendBy &&
              listMessages[index].sendBy != listMessages[index - 1].sendBy) {
            return true;
          } else {
            return false;
          }
        } else {
          return true;
        }
      } else {
        return false;
      }
    }

    switch (message.runtimeType) {
      case MessageModel:
        return MessageBubbleText(
                message: message,
                isOwn: isMyMessage,
                showUserName: isFirstMessageUser(),
                showAvatar: isLastMessage(),
                context: context)
            .render();
      default:
        return MessageBubbleText(
                message: message.copyWith(
                  messageText: '🚫 Mensagem não compatível',
                ),
                isOwn: isMyMessage,
                showUserName: isFirstMessageUser(),
                showAvatar: isLastMessage(),
                context: context)
            .render();
    }
  }

  Widget buildInput() {
    return Row(
      children: <Widget>[
        // Button send image
        // Material(
        //   child: IconButton(
        //     icon: const Icon(Icons.image_outlined),
        //     onPressed: () => {},
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Material(
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined),
                onPressed: () {
                  getSticker();
                },
              ),
            ),
          ),
        ),

        // Edit text
        Flexible(
          child: TextField(
            focusNode: focusNode,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r".*[^ ].*")),
              FilteringTextInputFormatter.deny(RegExp(r"^[\n\r]")),
            ],
            autocorrect: true,
            readOnly: false,
            showCursor: true,
            maxLines: 5,
            minLines: 1,
            autofocus: false,
            onChanged: (_) {
              messagesStore!.sendTypingEvent();
            },
            onEditingComplete: () {
              focusNode.unfocus();
            },
            onSubmitted: (value) {
              focusNode.unfocus();
            },
            style: const TextStyle(fontSize: 15.0),
            controller: textEditingController,
            decoration: const InputDecoration(
              isCollapsed: false,
              border: InputBorder.none,
              hintText: 'Mensagem',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        // Button send message
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (textEditingController.text.isNotEmpty &&
                    !textEditingController.text.startsWith(" ")) {
                  messagesStore!.sendMessage(MessageModel(
                      gid: widget.gid,
                      messageText: textEditingController.text
                          .replaceAll(RegExp(r"[\n\r]$"), "")
                          .replaceAll(RegExp(r"^[\n\r]"), "")
                          .trim(),
                      sendAt: DateTime.now(),
                      sendBy: AppInstance.nomeUsuario.toLowerCase().trim(),
                      mid: const Uuid().v1()));

                  listScrollController.animateTo(0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                  textEditingController.clear();
                }
              },
            )),
      ],
    );
  }

  Future<bool> onBackPress() {
    if (showEmoji) {
      emoji.sink.add(!showEmoji);
      showEmoji = !showEmoji;
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    emoji.sink.add(!showEmoji);
    showEmoji = !showEmoji;
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      emoji.sink.add(false);
      showEmoji = false;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
