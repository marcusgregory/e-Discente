// @dart=2.9
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:uni_discente/chat/models/chat_item.model.dart';
import 'package:uni_discente/chat/models/evento_digitando.model.dart';
import 'package:uni_discente/chat/models/message.model.dart';
import 'package:uni_discente/chat/repositories/messages.repository.dart';
import 'package:uni_discente/chat/stores/socket_io.store.dart';

import '../../notification_settings2.dart';
import '../app_instance.dart';
part 'list_messages.store.g.dart';

class ListMessagesStore = _ListMessagesStoreBase with _$ListMessagesStore;

abstract class _ListMessagesStoreBase with Store {
  MessagesRepository _messagesRepository = MessagesRepository();
  final ChatItemModel chatItemModel;
  StreamSubscription subscription;
  _ListMessagesStoreBase(this.chatItemModel) {
    init();
  }

  void init() async {
    fetchMessages();
    subscription = AppInstance.socketStore.socketStateStream
        .listen((SocketState socketState) {
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
      }
    });
    AppInstance.socketStore.socketIOMessageStore.messageStream
        .listen((messageModel) {
      receberMensagem(messageModel);
    });
  }

  @observable
  ObservableList<MessageModel> mensagens = ObservableList.of([]);

  @observable
  bool isLoading = false;

  @action
  fetchMessages({bool silent = false}) async {
    print('Obtendo mensagens do grupo ${chatItemModel.gid} no servidor...');
    if (silent == false) {
      isLoading = true;
    }
    _messagesRepository.getMessages(chatItemModel.gid).then((value) {
      mensagens = value.asObservable();
      isLoading = false;
    }).onError((error, stackTrace) {
      print(stackTrace);
      isLoading = false;
    });
  }

  @action
  receberMensagem(MessageModel messageModel) {
    if (messageModel.gid.toLowerCase().trim() ==
        this.chatItemModel.gid.toLowerCase().trim()) {
      if (messageModel.sendBy.toLowerCase().trim() != AppInstance.nomeUsuario &&
          (AppInstance.currentChatPageOpenId != messageModel.gid)) {
        NotificationAwesome.createNotificationLargeIconMessage(
            messageModel, chatItemModel.name);
      }
      print('sendo disparado @receberMensagem do gid:' + chatItemModel.gid);
      messageModel.state = MessageState.SENDED;
      mensagens.add(messageModel);
    }
  }

  enviarEventoDigitando(String sendBy, String gid) {
    _onChangeHandler(EventoDigitandoModel(
        eventType: 'EVENT_TYPING', gid: gid, sendBy: sendBy));
  }

  @action
  enviarMensagem(MessageModel messageModel, Function callback) {
    mensagens.add(messageModel);
    print(messageModel.messageText);
    AppInstance.socketStore.enviarMensagem(messageModel, callback);
  }

  Timer _timer;
  Timer _timer2;
  _onChangeHandler(EventoDigitandoModel eventoDigitando) {
    const duration = Duration(milliseconds: 700);
    if (_timer == null) {
      send(eventoDigitando);
      _timer = Timer.periodic(duration, (Timer t) => send(eventoDigitando));
    }
    if (_timer2 != null) {
      _timer2.cancel();
      //clear timer
    }
    _timer2 = new Timer(duration, () {
      _timer.cancel();
      _timer = null;
    });
  }

  @action
  send(EventoDigitandoModel eventoDigitando) {
    AppInstance.socketStore.enviarEventoDigitando(eventoDigitando);
  }

  void reconnected() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      fetchMessages(silent: true);
    });
  }

  void dispose() {
    subscription.cancel();
  }
}
