import 'dart:async';
import 'dart:convert';

import 'package:e_discente/repositories/saldo_restaurante.repository.dart';
import 'package:e_discente/util/toast.util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaldoBloc {
  String saldo = '';
  var saldoState = SaldoState.initial;

  final StreamController<SaldoState> _streamController =
      StreamController.broadcast();

  Stream<SaldoState> get saldoStream => _streamController.stream;

  Future<void> load() async {
    var prefs = await SharedPreferences.getInstance();
    try {
      if (!_streamController.isClosed) {
        if (prefs.containsKey('saldo')) {
          saldo = jsonDecode(prefs.getString('saldo') ?? '');
        } else {
          saldoState = SaldoState.loadingInitial;
          _streamController.sink.add(saldoState);
        }

        print('Carregando saldo...');
        saldoState = SaldoState.loading;
        _streamController.sink.add(saldoState);
        var saldoLoaded = (await SaldoRestauranteRepository().getSaldo());
        print('Carregado saldo!');
        await prefs.setString('saldo', jsonEncode(saldoLoaded));
        saldo = saldoLoaded;
        saldoState = SaldoState.ready;
        _streamController.sink.add(saldoState);
      }
    } catch (e) {
      if (saldo.isEmpty) {
        ToastUtil.showLongToast('Não foi possível obter o saldo atual!');
        saldoState = SaldoState.error;
        _streamController.sink.add(saldoState);
        _streamController.addError(e);
      } else {
        ToastUtil.showLongToast(
            'Não foi possível obter o saldo atual, Cuidado! pode ser que esteja desatualizado.');
        saldoState = SaldoState.ready;
        _streamController.sink.add(saldoState);
      }
    }
  }

  dispose() {
    _streamController.close();
  }
}

enum SaldoState { initial, loading, loadingInitial, ready, error }
