
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:e_discente/chat/models/chat_item.model.dart';
//import 'package:e_discente/chat/models/message.model.dart';
import 'package:e_discente/settings.dart';
//import '../../notification_settings2.dart';
import '../app_instance.dart';

class SocketIOService {
  late IO.Socket socket;

  void initSocket() {
    //listChatsBloc = ListChatsBloc();

    print('initSocket');
    socket = IO.io(
        AppInstance.apiURL,
        IO.OptionBuilder()
            .enableForceNewConnection()
            .setTransports(['websocket']).setQuery({
          'token': AppInstance.token,
          'usuario': json.encode(Settings.usuario!.toJson())
        }).build());
    socket.connect();
    socket.onConnect((_) {
      print('conectado');
    });
    socket.onConnecting((data) => print('conectando...'));
    socket.onDisconnect((data) {
      //socket.connect();
      //listChatsBloc.load();
    });
    socket.onReconnecting((data) => print('reconectando...'));

    // socket.on('receber_mensagem', (data) {
    //   var message = messageFromMap(data);
    //   if (message.sendBy.toLowerCase().trim() != AppInstance.nomeUsuario &&
    //       (AppInstance.currentChatPageOpenId != message.gid)) {
    //     NotificationAwesome.createNotificationLargeIconMessage(message);
    //   }
    // });
  }

  void entrarNosGrupos(List<ChatItemModel> listChats) {
    socket.emit(
        'entrar_nos_grupos', jsonEncode(listChats.map((e) => e.gid).toList()));
  }

  void dispose() {
    socket.close();
    socket.destroy();
    socket.disconnect();
    socket.dispose();
  }
}
