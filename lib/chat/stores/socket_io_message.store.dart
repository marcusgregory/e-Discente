//@dart=2.6
import 'dart:async';

import 'package:e_discente/chat/stores/chats.store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:e_discente/chat/models/message.model.dart';

import '../app_instance.dart';
part 'socket_io_message.store.g.dart';

class SocketIOMessageStore = _SocketIOMessageStoreBase
    with _$SocketIOMessageStore;

abstract class _SocketIOMessageStoreBase with Store {
  _SocketIOMessageStoreBase();

  final _messageStream = StreamController<MessageModel>.broadcast();
  Stream<MessageModel> get messageStream => _messageStream.stream;

  @observable
  MessageModel messageModel;

  @action
  receberMensagem(MessageModel newMessage) {
    print('Uma nova mensagem foi recebida: ' + newMessage.toJson().toString());
    messageModel = newMessage;
    _messageStream.sink.add(newMessage);
    GetIt.I<ChatsStore>().receiveMessage(newMessage);
  }

  void dispose() {
    _messageStream.close();
  }
}
