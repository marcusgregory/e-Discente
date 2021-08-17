// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.9

part of 'list_messages.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ListMessagesStore on _ListMessagesStoreBase, Store {
  final _$mensagensAtom = Atom(name: '_ListMessagesStoreBase.mensagens');

  @override
  ObservableList<MessageModel> get mensagens {
    _$mensagensAtom.reportRead();
    return super.mensagens;
  }

  @override
  set mensagens(ObservableList<MessageModel> value) {
    _$mensagensAtom.reportWrite(value, super.mensagens, () {
      super.mensagens = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_ListMessagesStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$fetchMessagesAsyncAction =
      AsyncAction('_ListMessagesStoreBase.fetchMessages');

  @override
  Future fetchMessages({bool silent = false}) {
    return _$fetchMessagesAsyncAction
        .run(() => super.fetchMessages(silent: silent));
  }

  final _$_ListMessagesStoreBaseActionController =
      ActionController(name: '_ListMessagesStoreBase');

  @override
  dynamic receberMensagem(MessageModel messageModel) {
    final _$actionInfo = _$_ListMessagesStoreBaseActionController.startAction(
        name: '_ListMessagesStoreBase.receberMensagem');
    try {
      return super.receberMensagem(messageModel);
    } finally {
      _$_ListMessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic enviarMensagem(MessageModel messageModel, Function callback) {
    final _$actionInfo = _$_ListMessagesStoreBaseActionController.startAction(
        name: '_ListMessagesStoreBase.enviarMensagem');
    try {
      return super.enviarMensagem(messageModel, callback);
    } finally {
      _$_ListMessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic send(EventoDigitandoModel eventoDigitando) {
    final _$actionInfo = _$_ListMessagesStoreBaseActionController.startAction(
        name: '_ListMessagesStoreBase.send');
    try {
      return super.send(eventoDigitando);
    } finally {
      _$_ListMessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mensagens: ${mensagens},
isLoading: ${isLoading}
    ''';
  }
}
