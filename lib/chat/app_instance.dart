import 'package:e_discente/chat/stores/socket_io.store.dart';
import 'package:e_discente/settings.dart';

class AppInstance {
  static const String apiURL = 'https://ediscente.com.br/chat';
  static const String socketUrl = 'https://ediscente.com.br';
  static get token => Settings.usuario!.token;
  static String get nomeUsuario =>
      Settings.usuario!.nomeDeUsuario.toLowerCase().trim();
  static get urlFotoPerfil => Settings.usuario!.urlImagemPerfil;
  static SocketIOStore? socketStore;
  //static ListChatsStore listChatsStore;
  static String currentChatPageOpenId = '';
  static String currentPageLastOpenedId = '';
  static Map<String, String>? payload;
}
