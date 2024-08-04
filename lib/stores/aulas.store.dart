import 'package:mobx/mobx.dart';
import 'package:e_discente/models/aulas.model.dart';
import 'package:e_discente/repositories/aulas.repository.dart';
part 'aulas.store.g.dart';

class Aulas = _AulasBase with _$Aulas;

abstract class _AulasBase with Store {
  final AulasRepository _aulasRepository = AulasRepository();

  @observable
  ObservableFuture<List<AulaModel>>? aulas;

  @action
  Future getAulas(String? idTurma) =>
      aulas = ObservableFuture(_aulasRepository.getAulas(idTurma));

  void loadAulas(String? idTurma) {
    getAulas(idTurma);
  }
}
