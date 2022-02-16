// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeScreenStore on _HomeScreenStoreBase, Store {
  final _$homeIndexAtom = Atom(name: '_HomeScreenStoreBase.homeIndex');

  @override
  int get homeIndex {
    _$homeIndexAtom.reportRead();
    return super.homeIndex;
  }

  @override
  set homeIndex(int value) {
    _$homeIndexAtom.reportWrite(value, super.homeIndex, () {
      super.homeIndex = value;
    });
  }

  final _$_HomeScreenStoreBaseActionController =
      ActionController(name: '_HomeScreenStoreBase');

  @override
  void updateHomeIndex(int _index) {
    final _$actionInfo = _$_HomeScreenStoreBaseActionController.startAction(
        name: '_HomeScreenStoreBase.updateHomeIndex');
    try {
      return super.updateHomeIndex(_index);
    } finally {
      _$_HomeScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
homeIndex: ${homeIndex}
    ''';
  }
}
