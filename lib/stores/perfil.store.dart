import 'package:mobx/mobx.dart';
import 'package:e_discente/models/perfil.model.dart';
import 'package:e_discente/repositories/perfil.repository.dart';

part 'perfil.store.g.dart';

class PerfilStore = _PerfilStore with _$PerfilStore;

abstract class _PerfilStore with Store {
  final PerfilRepository _perfil = PerfilRepository();

  @observable
  ObservableFuture<PerfilModel>? perfilDiscente;

  bool firstRun = true;

  @action
  Future getPerfil() {
    return perfilDiscente = ObservableFuture(_perfil.getPerfil());
  }

  void loadPerfil() {
    firstRun = false;
    getPerfil();
  }
}
