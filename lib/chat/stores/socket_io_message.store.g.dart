// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.6

part of 'socket_io_message.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SocketIOMessageStore on _SocketIOMessageStoreBase, Store {
  final _$messageModelAtom =
      Atom(name: '_SocketIOMessageStoreBase.messageModel');

  @override
  MessageModel get messageModel {
    _$messageModelAtom.reportRead();
    return super.messageModel;
  }

  @override
  set messageModel(MessageModel value) {
    _$messageModelAtom.reportWrite(value, super.messageModel, () {
      super.messageModel = value;
    });
  }

  final _$_SocketIOMessageStoreBaseActionController =
      ActionController(name: '_SocketIOMessageStoreBase');

  @override
  dynamic receberMensagem(MessageModel newMessage) {
    final _$actionInfo = _$_SocketIOMessageStoreBaseActionController
        .startAction(name: '_SocketIOMessageStoreBase.receberMensagem');
    try {
      return super.receberMensagem(newMessage);
    } finally {
      _$_SocketIOMessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messageModel: ${messageModel}
    ''';
  }
}
