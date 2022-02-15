import 'package:e_discente/chat/app_instance.dart';
import 'package:e_discente/chat/models/evento_digitando.model.dart';
import 'package:e_discente/chat/stores/chats.store.dart';
import 'package:e_discente/chat/stores/socket_io.store.dart';
import 'package:e_discente/chat/utils/debouces.util.dart';
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

  @observable
  var messages = ObservableList<MessageModel>();

  @observable
  var messagesState = MessagesState.LOADING;

  @observable
  TypingState typingState = TypingState.NOTHING;

  var eventTyping = EventoDigitandoModel();

  @action
  Future<void> loadMessages({bool silent = false}) async {
    print('Obtendo mensagens do grupo ${gid} no servidor...');
    if (silent = false) messagesState = messagesState = MessagesState.LOADING;
    ;
    try {
      messages = (await messagesRepository.getMessages(gid)).asObservable();
      GetIt.I<ChatsStore>().updateRecentMessage(messages.last);
    } catch (e) {
      messagesState = MessagesState.ERROR;
    }
    messagesState = MessagesState.READY;
  }

  @action
  void sendMessage(MessageModel message) {
    messages.add(message);
    GetIt.I<ChatsStore>().sendMessage(message, (ack) {
      messages[messages.indexOf(message)] =
          message.copyWith(state: MessageState.SENDED);
    });
  }

  @action
  void receiveMessage(MessageModel message) {
    messages.add(message);
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
    ;
  }

  @action
  void reconnect() {
    loadMessages(silent: true);
  }
}

enum MessagesState { LOADING, READY, ERROR }
enum TypingState { TYPING, NOTHING }
