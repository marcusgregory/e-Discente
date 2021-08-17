// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.9

part of 'aulas.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Aulas on _AulasBase, Store {
  final _$aulasAtom = Atom(name: '_AulasBase.aulas');

  @override
  ObservableFuture<List<AulaModel>> get aulas {
    _$aulasAtom.reportRead();
    return super.aulas;
  }

  @override
  set aulas(ObservableFuture<List<AulaModel>> value) {
    _$aulasAtom.reportWrite(value, super.aulas, () {
      super.aulas = value;
    });
  }

  final _$_AulasBaseActionController = ActionController(name: '_AulasBase');

  @override
  Future<dynamic> getAulas(String idTurma) {
    final _$actionInfo =
        _$_AulasBaseActionController.startAction(name: '_AulasBase.getAulas');
    try {
      return super.getAulas(idTurma);
    } finally {
      _$_AulasBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
aulas: ${aulas}
    ''';
  }
}
