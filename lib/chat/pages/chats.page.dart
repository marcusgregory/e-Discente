// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mobx/mobx.dart';
import 'package:uni_discente/chat/models/chat_item.model.dart';
import 'package:uni_discente/chat/stores/list_chats.store.dart';

import '../app_instance.dart';
import 'chat.page.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage();

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with AutomaticKeepAliveClientMixin {
  ListChatsStore _listChatsStore;

  @override
  void initState() {
    _listChatsStore = ListChatsStore()..loadListChats();
    AppInstance.listChatsStore = _listChatsStore;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return Scaffold(
    //     appBar: AppBar(
    //       title: InkWell(
    //           onTap: () {
    //             _listChatsStore.loadListChats();
    //           },
    //           child: Text('Conversas')),
    //     ),
    //     body:
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Observer(builder: (_) {
        final future = _listChatsStore.fetchListChatsFuture;

        //bool update = _listChatsStore.toogleUpdate;
        switch (future.status) {
          case FutureStatus.pending:
            print('pending');
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
            break;
          case FutureStatus.rejected:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _listChatsStore.fetchListChats();
                  },
                  icon: Icon(Icons.refresh),
                ),
                Text('Tentar novamente')
              ],
            );
            break;
          case FutureStatus.fulfilled:
            print('fulfilled');
            var listChats = _listChatsStore.fetchListChatsFuture.value.toList();

            if (listChats.isEmpty) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return Observer(builder: (_) {
              listChats.forEach((element) {
                if (element.messagesStore.mensagens.isNotEmpty) {
                  element.messagesStore.mensagens.last;
                }
              });
              return GroupedListView(
                  elements: listChats,
                  order: GroupedListOrder.DESC,
                  groupBy: (ChatItemModel chatItem) =>
                      chatItem.messagesStore.mensagens.isNotEmpty
                          ? chatItem.messagesStore.mensagens.last.sendAt
                          : DateTime.now(),
                  groupHeaderBuilder: (_) => Visibility(
                        visible: false,
                        child: Text(''),
                      ),
                  indexedItemBuilder: (context, ChatItemModel chatItem, index) {
                    return Observer(builder: (_) {
                      return buildItem(context, chatItem);
                    });
                  });
            });

            // return ListView.builder(
            //     itemCount: listChats.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Observer(builder: (_) {
            //         return buildItem(context, listChats[index]);
            //       });
            //     });
            break;
        }
        return Container();
      }),
    );
  }

  Widget buildItem(BuildContext context, ChatItemModel item) {
    return chatItemTile(
        traling: Visibility(
            visible: item.unreadedCounter > 0,
            child: balaoUnreaded(item.unreadedCounter)),
        leading: Container(
            width: 55.0,
            height: 55.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/group_icon_grey_square.png')))),
        title: item.name,
        subtitle: item.isTyping ? '${item.typingText}...' : item.recentMessage,
        item: item);
  }

  Widget balaoUnreaded(int unreaded) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 21.0,
          height: 21.0,
          decoration: BoxDecoration(
            color: Colors.green[400],
            shape: BoxShape.circle,
          ),
        ),
        Text(unreaded < 100 ? unreaded.toString() : '+99',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget chatItemTile(
      {Widget traling,
      Widget leading,
      String title,
      String subtitle,
      ChatItemModel item}) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ChatPage(item);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            leading,
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(subtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 14))
                ],
              ),
            ),
            traling,
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
