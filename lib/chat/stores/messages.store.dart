import 'package:e_discente/chat/app_instance.dart';
import 'package:e_discente/chat/models/evento_digitando.model.dart';
import 'package:e_discente/chat/models/i_message.dart';
import 'package:e_discente/chat/stores/chats.store.dart';
import 'package:e_discente/chat/stores/socket_io.store.dart';
import 'package:e_discente/chat/utils/debouces.util.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:e_discente/chat/models/message.model.dart';
import 'package:e_discente/chat/repositories/messages.repository.dart';

part 'messages.store.g.dart';

class MessagesStore = _MessagesStoreBase with _$MessagesStore;

abstract class _MessagesStoreBase with Store {
  final String gid;
  _MessagesStoreBase(this.gid);

  var messagesRepository = MessagesRepository();

  var firstRun = false;

  var page = 1;

  @observable
  var isLoadingMore = false;

  var loadedAllMessages = false;

  @observable
  var messages = ObservableList<IMessage>.of([]);

  @observable
  var messagesState = MessagesState.LOADING;

  @observable
  TypingState typingState = TypingState.NOTHING;

  var eventTyping = EventoDigitandoModel();

  @action
  Future<void> loadMessages({bool silent = false}) async {
    print('Obtendo mensagens do grupo $gid no servidor...');
    firstRun = true;
    if (silent == false) messagesState = messagesState = MessagesState.LOADING;
    try {
      var messagesChat =
          (await messagesRepository.getMessages(gid)).asObservable();
      if (messagesChat.isNotEmpty) {
        for (var element in messagesChat) {
          if (!messages.contains(element)) {
            messages.add(element);
          }
        }

        GetIt.I<ChatsStore>().updateRecentMessage(messages.first);
      }
      if (page == 1 && !silent) {
        page = 2;
      }
    } catch (e) {
      messagesState = MessagesState.ERROR;
    }
    messagesState = MessagesState.READY;
  }

  @action
  Future<void> loadMoreMessages() async {
    if (page > 1) {
      print('Carregando mais mensagens do grupo $gid no servidor...');
      try {
        isLoadingMore = true;
        var newMessages = await messagesRepository.getMessages(gid, page: page);
        if (newMessages.isNotEmpty) {
          messages.addAll(newMessages);
          page++;
        } else {
          loadedAllMessages = true;
          print(
              'Não tem mais mensagens no grupo $gid para carregar no servidor...');
        }
      } catch (e) {
        debugPrint('erro');
      } finally {
        isLoadingMore = false;
      }
    }
  }

  @action
  void sendMessage(MessageModel message) {
    messages.add(message);
    GetIt.I<ChatsStore>().sendMessage(message, (ack) {
      var index = messages.indexOf(message);
      messages.removeAt(index);
      messages.insert(
          index,
          message.copyWith(
              state: MessageState.SENDED,
              sendAt: DateTime.parse(ack['server_time'])));
    });
  }

  @action
  void receiveMessage(MessageModel message) {
    messages.add(message.copyWith(state: MessageState.SENDED));
  }

  var debouce = DeboucesUtil();
  @action
  void receiveTypingEvent(
      EventoDigitandoModel typingEvent, Function init, Function stop) {
    debouce.debouce(() {
      eventTyping = typingEvent;
      init();
      typingState = TypingState.TYPING;
    }, () {
      typingState = TypingState.NOTHING;
      eventTyping = EventoDigitandoModel();
      stop();
    });
  }

  var debouceEvery = DeboucesUtil();
  void sendTypingEvent() {
    debouceEvery.debouceEvery(() {
      GetIt.I<SocketIOStore>().enviarEventoDigitando(EventoDigitandoModel(
          eventType: 'EVENT_TYPING',
          gid: gid,
          sendBy: AppInstance.nomeUsuario.toLowerCase().trim()));
    });
  }

  @action
  void reconnect() {
    if (firstRun) {
      loadMessages(silent: true);
    }
  }
}

enum MessagesState { LOADING, READY, ERROR }

enum TypingState { TYPING, NOTHING }
