//@dart=2.6
import 'dart:async';

import 'package:e_discente/chat/models/evento_digitando.model.dart';
import 'package:e_discente/chat/models/message.model.dart';
import 'package:e_discente/chat/repositories/messages.repository.dart';
import 'package:e_discente/chat/utils/debouces.util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:e_discente/chat/models/chat_item.model.dart';
import 'package:e_discente/chat/repositories/list-chat.repository.dart';
import 'package:e_discente/chat/stores/socket_io.store.dart';

part 'chats.store.g.dart';

class ChatsStore = _ChatsStoreBase with _$ChatsStore;

abstract class _ChatsStoreBase with Store {
  var listChatRepository = ListChatRepository();
  var messagesRepository = MessagesRepository();
  var socketIOStore = GetIt.I<SocketIOStore>();
  StreamSubscription subscription;

  _ChatsStoreBase() {
    init();
  }

  void init() async {
    subscription =
        socketIOStore.socketStateStream.listen((SocketState socketState) {
      switch (socketState) {
        case SocketState.RECONNECTED:
          reconnected();
          break;
        case SocketState.CONNECT:
          break;
        case SocketState.CONNECTING:
          break;
        case SocketState.RECONNECTING:
          break;
        case SocketState.DISCONNECTED:
          break;
      }
    });
  }

  @observable
  ChatsState chatsState = ChatsState.LOADING;

  @observable
  ObservableList<ChatItemModel> listChats = ObservableList<ChatItemModel>();

  @action
  Future<void> loadListChats({bool silent = false}) async {
    if (silent = false) chatsState = ChatsState.LOADING;
    try {
      listChats = (await listChatRepository.getChats()).asObservable();
      socketIOStore.entrarNosGrupos(listChats);
      chatsState = ChatsState.READY;
    } catch (e) {
      print(e);
      chatsState = ChatsState.ERROR;
    }
  }

  @action
  void updateRecentMessage(MessageModel message) {
    listChats.forEach((chat) {
      if (chat.gid == message.gid) {
        listChats[listChats.indexOf(chat)] =
            chat.copyWith(recentMessage: message);
      }
    });
  }

  @action
  void sendMessage(MessageModel message, Function callback) {
    listChats.forEach((chat) {
      if (chat.gid == message.gid) {
        listChats[listChats.indexOf(chat)] =
            chat.copyWith(recentMessage: message);
      }
    });
    socketIOStore.enviarMensagem(message, callback);
  }

  @action
  void receiveMessage(MessageModel message) {
    listChats.forEach((chat) {
      if (chat.gid == message.gid) {
        listChats[listChats.indexOf(chat)] = chat.copyWith(
          recentMessage: message.copyWith(state: MessageState.SENDED),
        )..messagesStore.receiveMessage(message);
      }
    });
  }

  @action
  void receiveTypingEvent(EventoDigitandoModel typingEvent) {
    listChats.forEach((chat) {
      if (chat.gid == typingEvent.gid) {
        chat.messagesStore.receiveTypingEvent(typingEvent, () {
          int index = listChats.indexOf(chat);
          listChats.remove(chat);
          listChats.insert(index, chat.copyWith(eventoDigitando: typingEvent));
        }, () {
          int index = listChats.indexOf(chat);
          listChats.remove(chat);
          listChats.insert(index, chat.copyWith(eventoDigitando: null));
        });
      }
    });
  }
  // @action
  // void loadAllMessagesChat() {
  //   listChats.forEach((element) async {
  //     var messages = await loadMessagesChatByID(element.gid);
  //     listChats[listChats.indexOf(element)] =
  //         element.copyWith(messages: messages);
  //   });
  // }

  @action
  Future<List<MessageModel>> loadMessagesChatByID(String gid) async {
    print('Obtendo mensagens do grupo ${gid} no servidor...');
    return (await messagesRepository.getMessages(gid));
  }

  Future<void> reconnected() async {
    // await loadListChats(silent: true);
    socketIOStore.entrarNosGrupos(listChats);
    listChats.forEach((chat) {
      chat.messagesStore.reconnect();
    });
  }
}

enum ChatsState { LOADING, READY, ERROR }
