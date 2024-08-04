// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PerfilStore on _PerfilStore, Store {
  final _$perfilDiscenteAtom = Atom(name: '_PerfilStore.perfilDiscente');

  @override
  ObservableFuture<PerfilModel>? get perfilDiscente {
    _$perfilDiscenteAtom.reportRead();
    return super.perfilDiscente;
  }

  @override
  set perfilDiscente(ObservableFuture<PerfilModel>? value) {
    _$perfilDiscenteAtom.reportWrite(value, super.perfilDiscente, () {
      super.perfilDiscente = value;
    });
  }

  final _$_PerfilStoreActionController = ActionController(name: '_PerfilStore');

  @override
  Future<dynamic> getPerfil() {
    final $actionInfo = _$_PerfilStoreActionController.startAction(
        name: '_PerfilStore.getPerfil');
    try {
      return super.getPerfil();
    } finally {
      _$_PerfilStoreActionController.endAction($actionInfo);
    }
  }

  @override
  String toString() {
    return '''
perfilDiscente: ${perfilDiscente}
    ''';
  }
}
