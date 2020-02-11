// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boletim.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Boletim on _BoletimBase, Store {
  final _$boletimAtom = Atom(name: '_BoletimBase.boletim');

  @override
  ObservableFuture<Map<String, List<BoletimModel>>> get boletim {
    _$boletimAtom.context.enforceReadPolicy(_$boletimAtom);
    _$boletimAtom.reportObserved();
    return super.boletim;
  }

  @override
  set boletim(ObservableFuture<Map<String, List<BoletimModel>>> value) {
    _$boletimAtom.context.conditionallyRunInAction(() {
      super.boletim = value;
      _$boletimAtom.reportChanged();
    }, _$boletimAtom, name: '${_$boletimAtom.name}_set');
  }

  final _$valoresAtom = Atom(name: '_BoletimBase.valores');

  @override
  List<dynamic> get valores {
    _$valoresAtom.context.enforceReadPolicy(_$valoresAtom);
    _$valoresAtom.reportObserved();
    return super.valores;
  }

  @override
  set valores(List<dynamic> value) {
    _$valoresAtom.context.conditionallyRunInAction(() {
      super.valores = value;
      _$valoresAtom.reportChanged();
    }, _$valoresAtom, name: '${_$valoresAtom.name}_set');
  }

  final _$indexAtom = Atom(name: '_BoletimBase.index');

  @override
  int get index {
    _$indexAtom.context.enforceReadPolicy(_$indexAtom);
    _$indexAtom.reportObserved();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.context.conditionallyRunInAction(() {
      super.index = value;
      _$indexAtom.reportChanged();
    }, _$indexAtom, name: '${_$indexAtom.name}_set');
  }

  final _$_BoletimBaseActionController = ActionController(name: '_BoletimBase');

  @override
  Future<dynamic> getBoletim() {
    final _$actionInfo = _$_BoletimBaseActionController.startAction();
    try {
      return super.getBoletim();
    } finally {
      _$_BoletimBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addValor(dynamic value) {
    final _$actionInfo = _$_BoletimBaseActionController.startAction();
    try {
      return super.addValor(value);
    } finally {
      _$_BoletimBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIdex(int index) {
    final _$actionInfo = _$_BoletimBaseActionController.startAction();
    try {
      return super.setIdex(index);
    } finally {
      _$_BoletimBaseActionController.endAction(_$actionInfo);
    }
  }
}
