
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/models/turma.model.dart';

import 'models/usuario.model.dart';

class Settings{
  static String apiURL="https://api-unilab.herokuapp.com/api";
  static UsuarioModel usuario; 
  static List<NoticiaModel> noticias;
  static List<TurmaModel> turmas;
}