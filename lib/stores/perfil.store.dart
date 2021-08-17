// @dart=2.9
import 'package:mobx/mobx.dart';
import 'package:uni_discente/models/perfil.model.dart';
import 'package:uni_discente/repositories/perfil.repository.dart';

part 'perfil.store.g.dart';

class PerfilStore = _PerfilStore with _$PerfilStore;

abstract class _PerfilStore with Store {
  PerfilRepository _perfil = new PerfilRepository();

  @observable
  ObservableFuture<PerfilModel> perfilDiscente;

  @action
  Future getPerfil() {
    return perfilDiscente = ObservableFuture(_perfil.getPerfil());
  }

  void loadPerfil() {
    getPerfil();
  }
}
