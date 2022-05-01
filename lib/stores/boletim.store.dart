import 'package:mobx/mobx.dart';
import 'package:e_discente/models/boletim.model.dart';
import 'package:e_discente/repositories/notas.repository.dart';
part 'boletim.store.g.dart';

class Boletim = _BoletimBase with _$Boletim;

abstract class _BoletimBase with Store {
  final NotasRepository _notasRepository = NotasRepository();

  bool firstRun = true;

  @observable
  ObservableFuture<Map<String, List<BoletimModel>>>? boletim;

  @action
  Future getBoletim() =>
      boletim = ObservableFuture(_notasRepository.getNotas());

  void loadBoletim() {
    firstRun = false;
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
