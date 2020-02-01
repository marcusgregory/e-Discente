// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PerfilStore on _PerfilStore, Store {
  final _$perfilDiscenteAtom = Atom(name: '_PerfilStore.perfilDiscente');

  @override
  ObservableFuture<PerfilModel> get perfilDiscente {
    _$perfilDiscenteAtom.context.enforceReadPolicy(_$perfilDiscenteAtom);
    _$perfilDiscenteAtom.reportObserved();
    return super.perfilDiscente;
  }

  @override
  set perfilDiscente(ObservableFuture<PerfilModel> value) {
    _$perfilDiscenteAtom.context.conditionallyRunInAction(() {
      super.perfilDiscente = value;
      _$perfilDiscenteAtom.reportChanged();
    }, _$perfilDiscenteAtom, name: '${_$perfilDiscenteAtom.name}_set');
  }

  final _$_PerfilStoreActionController = ActionController(name: '_PerfilStore');

  @override
  Future<dynamic> getPerfil() {
    final _$actionInfo = _$_PerfilStoreActionController.startAction();
    try {
      return super.getPerfil();
    } finally {
      _$_PerfilStoreActionController.endAction(_$actionInfo);
    }
  }
}
