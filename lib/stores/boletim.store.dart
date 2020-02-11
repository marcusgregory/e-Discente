import 'package:mobx/mobx.dart';
import 'package:uni_discente/models/boletim.model.dart';
import 'package:uni_discente/repositories/notas.repository.dart';
part 'boletim.store.g.dart';

class Boletim = _BoletimBase with _$Boletim;

abstract class _BoletimBase with Store {
  NotasRepository _notasRepository = NotasRepository();

  @observable
  ObservableFuture<Map<String, List<BoletimModel>>> boletim;

  @action
  Future getBoletim() =>
      boletim = ObservableFuture(_notasRepository.getNotas());

  void loadBoletim() {
    getBoletim();
  }

  @observable
  var valores = [];

  @action
  addValor(value) {
    valores.add(value);
  }

  @observable
  int index = 0;

  @action
  setIdex(int index) {
    this.index = index;
  }
}
