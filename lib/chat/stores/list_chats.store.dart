//@dart=2.9
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:uni_discente/chat/app_instance.dart';
import 'package:uni_discente/chat/models/chat_item.model.dart';
import 'package:uni_discente/chat/repositories/list-chat.repository.dart';
import 'package:uni_discente/settings.dart';

import 'socket_io.store.dart';
part 'list_chats.store.g.dart';

class ListChatsStore = _ListChatsStoreBase with _$ListChatsStore;

abstract class _ListChatsStoreBase with Store {
  ListChatRepository _chatsRepository = ListChatRepository();

  StreamSubscription subscription;

  _ListChatsStoreBase() {
    init();
  }

  void init() async {
    subscription = AppInstance.socketStore.socketStateStream
        .listen((SocketState socketState) {
      switch (socketState) {
        case SocketState.RECONNECTED:
          //reconnected();
          break;
        case SocketState.CONNECT:
          break;
        case SocketState.CONNECTING:
          break;
        case SocketState.RECONNECTING:
          break;
      }
    });
    // AppInstance.socketService.socket.onReconnect((data) async {
    //   print('Socket reconectado');
    //   print('Carregando lista de chats...');
    //   await fetchListChats(silent: true);
    //   print('Entrando nos grupos...');
    //   AppInstance.socketService.entrarNosGrupos(listChats);
    //   print('Feito!');
    // });
  }

  //@observable
  ObservableList<ChatItemModel> listChats = ObservableList<ChatItemModel>();

  static ObservableFuture<ObservableList<ChatItemModel>> emptyResponse =
      ObservableFuture.value(ObservableList<ChatItemModel>());

  @observable
  ObservableFuture<ObservableList<ChatItemModel>> fetchListChatsFuture =
      emptyResponse;

  @action
  Future<ObservableList<ChatItemModel>> fetchListChats(
      {bool silent = false}) async {
    final future = _chatsRepository.getChats();
    final chatItem = ChatItemModel(
      createdAt: DateTime.now(),
      createdBy: 'sistema',
      gid: '0',
      members: [''],
      modifiedAt: DateTime.now(),
      name: 'DISCENTES GERAL',
      recentMessage: RecentMessage(
          messageText: '', readBy: [], sentAt: DateTime.now(), sentBy: ''),
    );
    final chatItem2 = ChatItemModel(
      createdAt: DateTime.now(),
      createdBy: 'sistema',
      gid: Settings.usuario.curso
          .toLowerCase()
          .trim()
          .replaceAll(" ", "")
          .replaceAll('/', "-")
          .replaceAll(r'\', '-'),
      members: [''],
      modifiedAt: DateTime.now(),
      name: Settings.usuario.curso,
      recentMessage: RecentMessage(
          messageText: '', readBy: [], sentAt: DateTime.now(), sentBy: ''),
    );
    // ObservableList<ChatItemModel> listChats1 =
    //     ObservableList<ChatItemModel>.of([chatItem, chatItem2]);
    // final future = Future.value(listChats1);
    if (silent) {
      fetchListChatsFuture = ObservableFuture.value(
          ObservableList.of([chatItem, chatItem2] + await future));
      listChats = fetchListChatsFuture.value;
      AppInstance.socketStore.rooms = listChats.map((e) => e.gid).toList();
      return listChats;
    }
    // await Future.delayed(Duration(seconds: 2));
    fetchListChatsFuture = ObservableFuture.value(
        ObservableList.of([chatItem, chatItem2] + await future));

    listChats = fetchListChatsFuture.value;
    AppInstance.socketStore.rooms = listChats.map((e) => e.gid).toList();
    AppInstance.socketStore.entrarNosGrupos(listChats.toList());
    return listChats;
  }

  void loadListChats() async {
    var list = await fetchListChats();
    AppInstance.socketStore.entrarNosGrupos(list.toList());
  }

  Future<void> reconnected() async {
    AppInstance.socketStore.entrarNosGrupos(listChats.toList());
    //dispose();
    //fetchListChatsFuture = emptyResponse;
    Future.delayed(Duration(seconds: 2)).then((_) async {
      await fetchListChats(silent: true);
      AppInstance.socketStore.entrarNosGrupos(listChats.toList());
    });
  }

  void dispose() {
    listChats.forEach((itemChat) {
      itemChat.messagesStore.dispose();
      itemChat.dispose();
    });
    //subscription.cancel();
  }
}
