// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.9

part of 'list_chats.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ListChatsStore on _ListChatsStoreBase, Store {
  final _$fetchListChatsFutureAtom =
      Atom(name: '_ListChatsStoreBase.fetchListChatsFuture');

  @override
  ObservableFuture<ObservableList<ChatItemModel>> get fetchListChatsFuture {
    _$fetchListChatsFutureAtom.reportRead();
    return super.fetchListChatsFuture;
  }

  @override
  set fetchListChatsFuture(
      ObservableFuture<ObservableList<ChatItemModel>> value) {
    _$fetchListChatsFutureAtom.reportWrite(value, super.fetchListChatsFuture,
        () {
      super.fetchListChatsFuture = value;
    });
  }

  final _$fetchListChatsAsyncAction =
      AsyncAction('_ListChatsStoreBase.fetchListChats');

  @override
  Future<ObservableList<ChatItemModel>> fetchListChats({bool silent = false}) {
    return _$fetchListChatsAsyncAction
        .run(() => super.fetchListChats(silent: silent));
  }

  @override
  String toString() {
    return '''
fetchListChatsFuture: ${fetchListChatsFuture}
    ''';
  }
}
