//@dart=2.9
import 'package:uni_discente/chat/stores/socket_io.store.dart';
import 'package:uni_discente/settings.dart';
import 'stores/list_chats.store.dart';

class AppInstance {
  static final String apiURL = 'https://chat-server-unilab.herokuapp.com';
  static get token => Settings.usuario.token;
  static String get nomeUsuario =>
      Settings.usuario.nomeDeUsuario.toLowerCase().trim();
  static get urlFotoPerfil => Settings.usuario.urlImagemPerfil;
  static SocketIOStore socketStore;
  static ListChatsStore listChatsStore;
  static String currentChatPageOpenId = '';
}
