//@dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uni_discente/chat/models/chat_item.model.dart';
import 'package:uni_discente/chat/models/evento_digitando.model.dart';
import 'package:uni_discente/chat/models/message.model.dart';
import 'package:uni_discente/chat/stores/socket_io_message.store.dart';

import '../../settings.dart';
import '../app_instance.dart';
part 'socket_io.store.g.dart';

class SocketIOStore = _SocketIOStoreBase with _$SocketIOStore;

abstract class _SocketIOStoreBase with Store {
  IO.Socket socket;

  @observable
  SocketState socketState;

  var _socketStateStream = StreamController<SocketState>.broadcast();
  Stream<SocketState> get socketStateStream => _socketStateStream.stream;

  SocketIOMessageStore socketIOMessageStore;

  List<String> rooms = [];

  @observable
  EventoDigitandoModel eventoDigitando;

  var _eventoDigitandoStream =
      StreamController<EventoDigitandoModel>.broadcast();
  Stream<EventoDigitandoModel> get eventoDigitandoStream =>
      _eventoDigitandoStream.stream;

  _SocketIOStoreBase() {
    socketIOMessageStore = SocketIOMessageStore();
  }

  void initSocket() {
    print('initSocket');
    socket = IO.io(
        AppInstance.apiURL,
        IO.OptionBuilder()
            .enableForceNewConnection()
            .setTransports(['websocket']).setQuery({
          'token': AppInstance.token,
          'usuario': json.encode(Settings.usuario.toJson())
        }).build());
    socket.connect();
    socket.onConnect((_) => _onConnect());
    socket.onConnecting((data) => _onConnecting());
    socket.onReconnecting((data) => _onReconnecting());
    socket.onReconnect((data) => _onReconnected());
    socket.onDisconnect((data) => print('O socket foi desconectado!'));
    socket.onError((data) => print('Ocorreu um erro no socket!'));
    socket.on('receber_mensagem', (data) {
      socketIOMessageStore.receberMensagem(messageFromMap(data));
    });
    socket.on('evento_digitando', (data) {
      receberEventoDigitando(EventoDigitandoModel.fromJson(data));
    });
  }

  @action
  void _onConnect() {
    socketState = SocketState.CONNECT;
    _socketStateStream.sink.add(SocketState.CONNECT);
    print('O socket foi conectado!');
    update();
  }

  @action
  void _onConnecting() {
    socketState = SocketState.CONNECTING;
    _socketStateStream.sink.add(SocketState.CONNECTING);
    print('Conectando ao socket...');
  }

  @action
  void _onReconnecting() {
    socketState = SocketState.RECONNECTING;
    _socketStateStream.sink.add(SocketState.RECONNECTING);
    print('Reconectando ao socket...');
  }

  @action
  void _onReconnected() {
    socketState = SocketState.RECONNECTED;
    _socketStateStream.sink.add(SocketState.RECONNECTED);
    print('O socket foi reconectado!');
  }

  @computed
  bool get isConnected => socketState == SocketState.CONNECT;

  void enviarMensagem(MessageModel messageModel, Function callback) {
    print('Uma nova mensagem foi enviada ' + messageModel.toJson().toString());
    socket.emitWithAck('enviar_mensagem', messageToMap(messageModel),
        ack: (ack) {
      callback(ack);
    });
  }

  @action
  receberEventoDigitando(EventoDigitandoModel newDigitandoModel) {
    print(
        'Novo evento recebido: ${newDigitandoModel.sendBy} está digitando... gid: ${newDigitandoModel.gid}');
    _eventoDigitandoStream.sink.add(newDigitandoModel);
    eventoDigitando = newDigitandoModel;
  }

  void enviarEventoDigitando(EventoDigitandoModel eventoDigitando) {
    if (socket.connected) {
      socket.emit('evento_digitando', eventoDigitando);
    }
  }

  void entrarNosGrupos(List<ChatItemModel> listChats) {
    print('Enviando a lista de salas para o servidor!');
    socket.emit(
        'entrar_nos_grupos', jsonEncode(listChats.map((e) => e.gid).toList()));
  }

  void entrarNosGruposByIds(List<String> gid) {
    if (gid.isNotEmpty) {
      print('Enviando a lista de salas para o servidor');
      Future.delayed(Duration(milliseconds: 1500))
          .then((value) => {socket.emit('entrar_nos_grupos', jsonEncode(gid))});
    } else {
      print('Atenção: Não pode ser enviado uma lista de grupos vazia!');
    }
  }

  void update() {
    entrarNosGruposByIds(rooms);
  }

  void dispose() {
    _eventoDigitandoStream.close();
    _socketStateStream.close();
    socket.close();
    socket.destroy();
    socket.disconnect();
    socket.dispose();
  }
}

enum SocketState { CONNECT, CONNECTING, RECONNECTED, RECONNECTING }
