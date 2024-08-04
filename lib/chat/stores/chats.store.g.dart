// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatsStore on _ChatsStoreBase, Store {
  final _$chatsStateAtom = Atom(name: '_ChatsStoreBase.chatsState');

  @override
  ChatsState get chatsState {
    _$chatsStateAtom.reportRead();
    return super.chatsState;
  }

  @override
  set chatsState(ChatsState value) {
    _$chatsStateAtom.reportWrite(value, super.chatsState, () {
      super.chatsState = value;
    });
  }

  final _$listChatsAtom = Atom(name: '_ChatsStoreBase.listChats');

  @override
  ObservableList<ChatItemModel> get listChats {
    _$listChatsAtom.reportRead();
    return super.listChats;
  }

  @override
  set listChats(ObservableList<ChatItemModel> value) {
    _$listChatsAtom.reportWrite(value, super.listChats, () {
      super.listChats = value;
    });
  }

  final _$loadListChatsAsyncAction =
      AsyncAction('_ChatsStoreBase.loadListChats');

  @override
  Future<void> loadListChats({bool silent = false}) {
    return _$loadListChatsAsyncAction
        .run(() => super.loadListChats(silent: silent));
  }

  final _$loadMessagesChatByIDAsyncAction =
      AsyncAction('_ChatsStoreBase.loadMessagesChatByID');

  @override
  Future<List<MessageModel>> loadMessagesChatByID(String gid) {
    return _$loadMessagesChatByIDAsyncAction
        .run(() => super.loadMessagesChatByID(gid));
  }

  final _$_ChatsStoreBaseActionController =
      ActionController(name: '_ChatsStoreBase');

  @override
  void updateRecentMessage(IMessage message) {
    final $actionInfo = _$_ChatsStoreBaseActionController.startAction(
        name: '_ChatsStoreBase.updateRecentMessage');
    try {
      return super.updateRecentMessage(message);
    } finally {
      _$_ChatsStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  void sendMessage(IMessage message, Function callback) {
    final $actionInfo = _$_ChatsStoreBaseActionController.startAction(
        name: '_ChatsStoreBase.sendMessage');
    try {
      return super.sendMessage(message, callback);
    } finally {
      _$_ChatsStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  void receiveMessage(IMessage message) {
    final $actionInfo = _$_ChatsStoreBaseActionController.startAction(
        name: '_ChatsStoreBase.receiveMessage');
    try {
      return super.receiveMessage(message);
    } finally {
      _$_ChatsStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  void receiveTypingEvent(EventoDigitandoModel typingEvent) {
    final $actionInfo = _$_ChatsStoreBaseActionController.startAction(
        name: '_ChatsStoreBase.receiveTypingEvent');
    try {
      return super.receiveTypingEvent(typingEvent);
    } finally {
      _$_ChatsStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  String toString() {
    return '''
chatsState: ${chatsState},
listChats: ${listChats}
    ''';
  }
}
