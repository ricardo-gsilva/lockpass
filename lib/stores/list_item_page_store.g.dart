// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_item_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ListItemStore on _ListItemStore, Store {
  late final _$listDynamicAtom =
      Atom(name: '_ListItemStore.listDynamic', context: context);

  @override
  ObservableList<ItensModel> get listDynamic {
    _$listDynamicAtom.reportRead();
    return super.listDynamic;
  }

  @override
  set listDynamic(ObservableList<ItensModel> value) {
    _$listDynamicAtom.reportWrite(value, super.listDynamic, () {
      super.listDynamic = value;
    });
  }

  late final _$alphabetListAtom =
      Atom(name: '_ListItemStore.alphabetList', context: context);

  @override
  ObservableList<dynamic> get alphabetList {
    _$alphabetListAtom.reportRead();
    return super.alphabetList;
  }

  @override
  set alphabetList(ObservableList<dynamic> value) {
    _$alphabetListAtom.reportWrite(value, super.alphabetList, () {
      super.alphabetList = value;
    });
  }

  late final _$_ListItemStoreActionController =
      ActionController(name: '_ListItemStore', context: context);

  @override
  dynamic changeBool(TypeModel type, List<TypeModel> listType) {
    final _$actionInfo = _$_ListItemStoreActionController.startAction(
        name: '_ListItemStore.changeBool');
    try {
      return super.changeBool(type, listType);
    } finally {
      _$_ListItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic listFilter(String type, List<ItensModel> listItens) {
    final _$actionInfo = _$_ListItemStoreActionController.startAction(
        name: '_ListItemStore.listFilter');
    try {
      return super.listFilter(type, listItens);
    } finally {
      _$_ListItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic filterList(List<dynamic> list, List<ItensModel> itens) {
    final _$actionInfo = _$_ListItemStoreActionController.startAction(
        name: '_ListItemStore.filterList');
    try {
      return super.filterList(list, itens);
    } finally {
      _$_ListItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listDynamic: ${listDynamic},
alphabetList: ${alphabetList}
    ''';
  }
}
