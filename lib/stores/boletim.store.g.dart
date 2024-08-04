// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boletim.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Boletim on _BoletimBase, Store {
  final _$boletimAtom = Atom(name: '_BoletimBase.boletim');

  @override
  ObservableFuture<Map<String, List<BoletimModel>>>? get boletim {
    _$boletimAtom.reportRead();
    return super.boletim;
  }

  @override
  set boletim(ObservableFuture<Map<String, List<BoletimModel>>>? value) {
    _$boletimAtom.reportWrite(value, super.boletim, () {
      super.boletim = value;
    });
  }

  final _$valoresAtom = Atom(name: '_BoletimBase.valores');

  @override
  List<dynamic> get valores {
    _$valoresAtom.reportRead();
    return super.valores;
  }

  @override
  set valores(List<dynamic> value) {
    _$valoresAtom.reportWrite(value, super.valores, () {
      super.valores = value;
    });
  }

  final _$indexAtom = Atom(name: '_BoletimBase.index');

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  final _$_BoletimBaseActionController = ActionController(name: '_BoletimBase');

  @override
  Future<dynamic> getBoletim() {
    final _$actionInfo = _$_BoletimBaseActionController.startAction(
        name: '_BoletimBase.getBoletim');
    try {
      return super.getBoletim();
    } finally {
      _$_BoletimBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addValor(dynamic value) {
    final _$actionInfo = _$_BoletimBaseActionController.startAction(
        name: '_BoletimBase.addValor');
    try {
      return super.addValor(value);
    } finally {
      _$_BoletimBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIdex(int index) {
    final _$actionInfo = _$_BoletimBaseActionController.startAction(
        name: '_BoletimBase.setIdex');
    try {
      return super.setIdex(index);
    } finally {
      _$_BoletimBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
boletim: ${boletim},
valores: ${valores},
index: ${index}
    ''';
  }
}
