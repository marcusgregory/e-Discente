// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.9

part of 'chat_item.model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatItemModel on _ChatItemModelBase, Store {
  Computed<String> _$recentMessageComputed;

  @override
  String get recentMessage =>
      (_$recentMessageComputed ??= Computed<String>(() => super.recentMessage,
              name: '_ChatItemModelBase.recentMessage'))
          .value;
  Computed<bool> _$isTypingComputed;

  @override
  bool get isTyping =>
      (_$isTypingComputed ??= Computed<bool>(() => super.isTyping,
              name: '_ChatItemModelBase.isTyping'))
          .value;
  Computed<String> _$typingTextComputed;

  @override
  String get typingText =>
      (_$typingTextComputed ??= Computed<String>(() => super.typingText,
              name: '_ChatItemModelBase.typingText'))
          .value;

  final _$eventoDigitandoAtom =
      Atom(name: '_ChatItemModelBase.eventoDigitando');

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

  final _$itemSubtitleAtom = Atom(name: '_ChatItemModelBase.itemSubtitle');

  @override
  String get itemSubtitle {
    _$itemSubtitleAtom.reportRead();
    return super.itemSubtitle;
  }

  @override
  set itemSubtitle(String value) {
    _$itemSubtitleAtom.reportWrite(value, super.itemSubtitle, () {
      super.itemSubtitle = value;
    });
  }

  final _$_recentMessageAtom = Atom(name: '_ChatItemModelBase._recentMessage');

  @override
  RecentMessage get _recentMessage {
    _$_recentMessageAtom.reportRead();
    return super._recentMessage;
  }

  @override
  set _recentMessage(RecentMessage value) {
    _$_recentMessageAtom.reportWrite(value, super._recentMessage, () {
      super._recentMessage = value;
    });
  }

  final _$_ChatItemModelBaseActionController =
      ActionController(name: '_ChatItemModelBase');

  @override
  dynamic receberEventoDigitando(EventoDigitandoModel digitandoModel) {
    final _$actionInfo = _$_ChatItemModelBaseActionController.startAction(
        name: '_ChatItemModelBase.receberEventoDigitando');
    try {
      return super.receberEventoDigitando(digitandoModel);
    } finally {
      _$_ChatItemModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _onDigitandoHandler(EventoDigitandoModel digitandoModel) {
    final _$actionInfo = _$_ChatItemModelBaseActionController.startAction(
        name: '_ChatItemModelBase._onDigitandoHandler');
    try {
      return super._onDigitandoHandler(digitandoModel);
    } finally {
      _$_ChatItemModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic stopTyping() {
    final _$actionInfo = _$_ChatItemModelBaseActionController.startAction(
        name: '_ChatItemModelBase.stopTyping');
    try {
      return super.stopTyping();
    } finally {
      _$_ChatItemModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
eventoDigitando: ${eventoDigitando},
itemSubtitle: ${itemSubtitle},
recentMessage: ${recentMessage},
isTyping: ${isTyping},
typingText: ${typingText}
    ''';
  }
}
