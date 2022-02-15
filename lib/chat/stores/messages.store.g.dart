// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MessagesStore on _MessagesStoreBase, Store {
  final _$messagesAtom = Atom(name: '_MessagesStoreBase.messages');

  @override
  ObservableList<MessageModel> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<MessageModel> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$messagesStateAtom = Atom(name: '_MessagesStoreBase.messagesState');

  @override
  MessagesState get messagesState {
    _$messagesStateAtom.reportRead();
    return super.messagesState;
  }

  @override
  set messagesState(MessagesState value) {
    _$messagesStateAtom.reportWrite(value, super.messagesState, () {
      super.messagesState = value;
    });
  }

  final _$typingStateAtom = Atom(name: '_MessagesStoreBase.typingState');

  @override
  TypingState get typingState {
    _$typingStateAtom.reportRead();
    return super.typingState;
  }

  @override
  set typingState(TypingState value) {
    _$typingStateAtom.reportWrite(value, super.typingState, () {
      super.typingState = value;
    });
  }

  final _$loadMessagesAsyncAction =
      AsyncAction('_MessagesStoreBase.loadMessages');

  @override
  Future<void> loadMessages({bool silent = false}) {
    return _$loadMessagesAsyncAction
        .run(() => super.loadMessages(silent: silent));
  }

  final _$_MessagesStoreBaseActionController =
      ActionController(name: '_MessagesStoreBase');

  @override
  void sendMessage(MessageModel message) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.sendMessage');
    try {
      return super.sendMessage(message);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void receiveMessage(MessageModel message) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.receiveMessage');
    try {
      return super.receiveMessage(message);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void receiveTypingEvent(
      EventoDigitandoModel typingEvent, Function init, Function stop) {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.receiveTypingEvent');
    try {
      return super.receiveTypingEvent(typingEvent, init, stop);
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reconnect() {
    final _$actionInfo = _$_MessagesStoreBaseActionController.startAction(
        name: '_MessagesStoreBase.reconnect');
    try {
      return super.reconnect();
    } finally {
      _$_MessagesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messages: ${messages},
messagesState: ${messagesState},
typingState: ${typingState}
    ''';
  }
}
