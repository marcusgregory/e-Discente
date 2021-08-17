// @dart=2.9
import 'package:mobx/mobx.dart';
import 'package:uni_discente/models/aulas.model.dart';
import 'package:uni_discente/repositories/aulas.repository.dart';
part 'aulas.store.g.dart';

class Aulas = _AulasBase with _$Aulas;

abstract class _AulasBase with Store {
  AulasRepository _aulasRepository = AulasRepository();

  @observable
  ObservableFuture<List<AulaModel>> aulas;

  @action
  Future getAulas(String idTurma) =>
      aulas = ObservableFuture(_aulasRepository.getAulas(idTurma));

  void loadAulas(String idTurma) {
    getAulas(idTurma);
  }
}
