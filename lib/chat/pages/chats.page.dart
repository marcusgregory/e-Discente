import 'package:e_discente/chat/stores/chats.store.dart';
import 'package:e_discente/chat/utils/user.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:e_discente/chat/models/chat_item.model.dart';

import '../app_instance.dart';
import 'chat.page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with AutomaticKeepAliveClientMixin {
  late ChatsStore _chatsStore;

  @override
  void initState() {
    _chatsStore = GetIt.I<ChatsStore>();
    _chatsStore.loadListChats();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Observer(builder: (_) {
        switch (_chatsStore.chatsState) {
          case ChatsState.LOADING:
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          case ChatsState.READY:
            if (_chatsStore.listChats.isEmpty) {
              return const Center(
                child: Text('Você não tem chats'),
              );
            } else {
              return ListView.builder(
                  itemCount: _chatsStore.listChats.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildItem(context, _chatsStore.listChats[index]);
                  });
            }
          case ChatsState.ERROR:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _chatsStore.loadListChats();
                  },
                  icon: const Icon(Icons.refresh),
                ),
                const Text('Tentar novamente')
              ],
            );
        }
        return Container();
      }),
    );
  }

  Widget buildItem(BuildContext context, ChatItemModel item) {
    print(item.eventoDigitando);
    return chatItemTile(
        traling: Visibility(
            visible: item.unreadedCounter > 0,
            child: balaoUnreaded(item.unreadedCounter)),
        leading: Container(
            width: 55.0,
            height: 55.0,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/group_icon_grey_square.png')))),
        title: item.name,
        subtitle: item.eventoDigitando == null
            ? UserUtil.isYouOrUser(item.recentMessage.sendBy) +
                ": " +
                item.recentMessage.messageText
            : item.eventoDigitando!.sendBy! +
                " está digitando...", //item.messages.isNotEmpty
        //     ? '${item.messages.last.sendBy}: ${item.messages.last.messageText}'
        //     : '',
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
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget chatItemTile(
      {required Widget traling,
      required Widget leading,
      required String title,
      required String subtitle,
      required ChatItemModel item}) {
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
            const SizedBox(
              width: 10,
            ),
            leading,
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(subtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14))
                ],
              ),
            ),
            traling,
            const SizedBox(
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
