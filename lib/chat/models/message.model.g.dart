// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.9

part of 'message.model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MessageModel on _MessageModelBase, Store {
  final _$gidAtom = Atom(name: '_MessageModelBase.gid');

  @override
  String get gid {
    _$gidAtom.reportRead();
    return super.gid;
  }

  @override
  set gid(String value) {
    _$gidAtom.reportWrite(value, super.gid, () {
      super.gid = value;
    });
  }

  final _$messageTextAtom = Atom(name: '_MessageModelBase.messageText');

  @override
  String get messageText {
    _$messageTextAtom.reportRead();
    return super.messageText;
  }

  @override
  set messageText(String value) {
    _$messageTextAtom.reportWrite(value, super.messageText, () {
      super.messageText = value;
    });
  }

  final _$sendAtAtom = Atom(name: '_MessageModelBase.sendAt');

  @override
  DateTime get sendAt {
    _$sendAtAtom.reportRead();
    return super.sendAt;
  }

  @override
  set sendAt(DateTime value) {
    _$sendAtAtom.reportWrite(value, super.sendAt, () {
      super.sendAt = value;
    });
  }

  final _$sendByAtom = Atom(name: '_MessageModelBase.sendBy');

  @override
  String get sendBy {
    _$sendByAtom.reportRead();
    return super.sendBy;
  }

  @override
  set sendBy(String value) {
    _$sendByAtom.reportWrite(value, super.sendBy, () {
      super.sendBy = value;
    });
  }

  final _$profilePicUrlAtom = Atom(name: '_MessageModelBase.profilePicUrl');

  @override
  String get profilePicUrl {
    _$profilePicUrlAtom.reportRead();
    return super.profilePicUrl;
  }

  @override
  set profilePicUrl(String value) {
    _$profilePicUrlAtom.reportWrite(value, super.profilePicUrl, () {
      super.profilePicUrl = value;
    });
  }

  final _$stateAtom = Atom(name: '_MessageModelBase.state');

  @override
  MessageState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(MessageState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  final _$_MessageModelBaseActionController =
      ActionController(name: '_MessageModelBase');

  @override
  void enviarMensagem(ListMessagesStore store) {
    final _$actionInfo = _$_MessageModelBaseActionController.startAction(
        name: '_MessageModelBase.enviarMensagem');
    try {
      return super.enviarMensagem(store);
    } finally {
      _$_MessageModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSendAt(DateTime sendAt) {
    final _$actionInfo = _$_MessageModelBaseActionController.startAction(
        name: '_MessageModelBase.updateSendAt');
    try {
      return super.updateSendAt(sendAt);
    } finally {
      _$_MessageModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
gid: ${gid},
messageText: ${messageText},
sendAt: ${sendAt},
sendBy: ${sendBy},
profilePicUrl: ${profilePicUrl},
state: ${state}
    ''';
  }
}
