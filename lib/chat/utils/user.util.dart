import 'package:e_discente/chat/app_instance.dart';

class UserUtil {
  static isYouOrUser(String username) {
    if (AppInstance.nomeUsuario.toLowerCase().trim() == username) {
      return "Você";
    } else {
      return username;
    }
  }
}
