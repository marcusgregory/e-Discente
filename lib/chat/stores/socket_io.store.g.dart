// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.6

part of 'socket_io.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SocketIOStore on _SocketIOStoreBase, Store {
  Computed<bool> _$isConnectedComputed;

  @override
  bool get isConnected =>
      (_$isConnectedComputed ??= Computed<bool>(() => super.isConnected,
              name: '_SocketIOStoreBase.isConnected'))
          .value;

  final _$socketStateAtom = Atom(name: '_SocketIOStoreBase.socketState');

  @override
  SocketState get socketState {
    _$socketStateAtom.reportRead();
    return super.socketState;
  }

  @override
  set socketState(SocketState value) {
    _$socketStateAtom.reportWrite(value, super.socketState, () {
      super.socketState = value;
    });
  }

  final _$eventoDigitandoAtom =
      Atom(name: '_SocketIOStoreBase.eventoDigitando');

  @override
  EventoDigitandoModel get eventoDigitando {
    _$eventoDigitandoAtom.reportRead();
    return super.eventoDigitando;
  }

  @override
  set eventoDigitando(EventoDigitandoModel value) {
    _$eventoDigitandoAtom.reportWrite(value, super.eventoDigitando, () {
      super.eventoDigitando = value;
    });
  }

  final _$_SocketIOStoreBaseActionController =
      ActionController(name: '_SocketIOStoreBase');

  @override
  void _onConnect() {
    final _$actionInfo = _$_SocketIOStoreBaseActionController.startAction(
        name: '_SocketIOStoreBase._onConnect');
    try {
      return super._onConnect();
    } finally {
      _$_SocketIOStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onConnecting() {
    final _$actionInfo = _$_SocketIOStoreBaseActionController.startAction(
        name: '_SocketIOStoreBase._onConnecting');
    try {
      return super._onConnecting();
    } finally {
      _$_SocketIOStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onReconnecting() {
    final _$actionInfo = _$_SocketIOStoreBaseActionController.startAction(
        name: '_SocketIOStoreBase._onReconnecting');
    try {
      return super._onReconnecting();
    } finally {
      _$_SocketIOStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onReconnected() {
    final _$actionInfo = _$_SocketIOStoreBaseActionController.startAction(
        name: '_SocketIOStoreBase._onReconnected');
    try {
      return super._onReconnected();
    } finally {
      _$_SocketIOStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic receberEventoDigitando(EventoDigitandoModel newDigitandoModel) {
    final _$actionInfo = _$_SocketIOStoreBaseActionController.startAction(
        name: '_SocketIOStoreBase.receberEventoDigitando');
    try {
      return super.receberEventoDigitando(newDigitandoModel);
    } finally {
      _$_SocketIOStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
socketState: ${socketState},
eventoDigitando: ${eventoDigitando},
isConnected: ${isConnected}
    ''';
  }
}
