import 'package:e_discente/chat/stores/socket_io.store.dart';
import 'package:e_discente/settings.dart';

class AppInstance {
  static const String apiURL = 'https://chat-server-unilab.herokuapp.com';
  static get token => Settings.usuario!.token;
  static String get nomeUsuario =>
      Settings.usuario!.nomeDeUsuario!.toLowerCase().trim();
  static get urlFotoPerfil => Settings.usuario!.urlImagemPerfil;
  static SocketIOStore? socketStore;
  //static ListChatsStore listChatsStore;
  static String currentChatPageOpenId = '';
  static String currentPageLastOpenedId = '';
  static Map<String, String>? payload;
}
