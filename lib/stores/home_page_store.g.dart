// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomePageStore on HomePageStoreBase, Store {
  late final _$listItensAtom =
      Atom(name: 'HomePageStoreBase.listItens', context: context);

  @override
  ObservableList<ItensModel> get listItens {
    _$listItensAtom.reportRead();
    return super.listItens;
  }

  @override
  set listItens(ObservableList<ItensModel> value) {
    _$listItensAtom.reportWrite(value, super.listItens, () {
      super.listItens = value;
    });
  }

  late final _$listTypesAtom =
      Atom(name: 'HomePageStoreBase.listTypes', context: context);

  @override
  ObservableList<TypeModel> get listTypes {
    _$listTypesAtom.reportRead();
    return super.listTypes;
  }

  @override
  set listTypes(ObservableList<TypeModel> value) {
    _$listTypesAtom.reportWrite(value, super.listTypes, () {
      super.listTypes = value;
    });
  }

  late final _$filterItensAtom =
      Atom(name: 'HomePageStoreBase.filterItens', context: context);

  @override
  ObservableList<ItensModel> get filterItens {
    _$filterItensAtom.reportRead();
    return super.filterItens;
  }

  @override
  set filterItens(ObservableList<ItensModel> value) {
    _$filterItensAtom.reportWrite(value, super.filterItens, () {
      super.filterItens = value;
    });
  }

  late final _$typeLenghtClearAtom =
      Atom(name: 'HomePageStoreBase.typeLenghtClear', context: context);

  @override
  ObservableList<String> get typeLenghtClear {
    _$typeLenghtClearAtom.reportRead();
    return super.typeLenghtClear;
  }

  @override
  set typeLenghtClear(ObservableList<String> value) {
    _$typeLenghtClearAtom.reportWrite(value, super.typeLenghtClear, () {
      super.typeLenghtClear = value;
    });
  }

  late final _$filterTypeAtom =
      Atom(name: 'HomePageStoreBase.filterType', context: context);

  @override
  ObservableList<String> get filterType {
    _$filterTypeAtom.reportRead();
    return super.filterType;
  }

  @override
  set filterType(ObservableList<String> value) {
    _$filterTypeAtom.reportWrite(value, super.filterType, () {
      super.filterType = value;
    });
  }

  late final _$typeAtom =
      Atom(name: 'HomePageStoreBase.type', context: context);

  @override
  ObservableList<TypeModel> get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(ObservableList<TypeModel> value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$searchTextFieldAtom =
      Atom(name: 'HomePageStoreBase.searchTextField', context: context);

  @override
  bool get searchTextField {
    _$searchTextFieldAtom.reportRead();
    return super.searchTextField;
  }

  @override
  set searchTextField(bool value) {
    _$searchTextFieldAtom.reportWrite(value, super.searchTextField, () {
      super.searchTextField = value;
    });
  }

  late final _$searchControllerAtom =
      Atom(name: 'HomePageStoreBase.searchController', context: context);

  @override
  TextEditingController get searchController {
    _$searchControllerAtom.reportRead();
    return super.searchController;
  }

  @override
  set searchController(TextEditingController value) {
    _$searchControllerAtom.reportWrite(value, super.searchController, () {
      super.searchController = value;
    });
  }

  late final _$pinAtom = Atom(name: 'HomePageStoreBase.pin', context: context);

  @override
  int get pin {
    _$pinAtom.reportRead();
    return super.pin;
  }

  @override
  set pin(int value) {
    _$pinAtom.reportWrite(value, super.pin, () {
      super.pin = value;
    });
  }

  late final _$pathAtom =
      Atom(name: 'HomePageStoreBase.path', context: context);

  @override
  String? get path {
    _$pathAtom.reportRead();
    return super.path;
  }

  @override
  set path(String? value) {
    _$pathAtom.reportWrite(value, super.path, () {
      super.path = value;
    });
  }

  late final _$selectedIndexAtom =
      Atom(name: 'HomePageStoreBase.selectedIndex', context: context);

  @override
  int get selectedIndex {
    _$selectedIndexAtom.reportRead();
    return super.selectedIndex;
  }

  @override
  set selectedIndex(int value) {
    _$selectedIndexAtom.reportWrite(value, super.selectedIndex, () {
      super.selectedIndex = value;
    });
  }

  late final _$modeAtom =
      Atom(name: 'HomePageStoreBase.mode', context: context);

  @override
  int get mode {
    _$modeAtom.reportRead();
    return super.mode;
  }

  @override
  set mode(int value) {
    _$modeAtom.reportWrite(value, super.mode, () {
      super.mode = value;
    });
  }

  late final _$isCheckedAtom =
      Atom(name: 'HomePageStoreBase.isChecked', context: context);

  @override
  bool get isChecked {
    _$isCheckedAtom.reportRead();
    return super.isChecked;
  }

  @override
  set isChecked(bool value) {
    _$isCheckedAtom.reportWrite(value, super.isChecked, () {
      super.isChecked = value;
    });
  }

  late final _$listScreensAtom =
      Atom(name: 'HomePageStoreBase.listScreens', context: context);

  @override
  List<Widget> get listScreens {
    _$listScreensAtom.reportRead();
    return super.listScreens;
  }

  @override
  set listScreens(List<Widget> value) {
    _$listScreensAtom.reportWrite(value, super.listScreens, () {
      super.listScreens = value;
    });
  }

  late final _$getPinAsyncAction =
      AsyncAction('HomePageStoreBase.getPin', context: context);

  @override
  Future<bool> getPin() {
    return _$getPinAsyncAction.run(() => super.getPin());
  }

  late final _$checkBoxVisibleInfoPinAsyncAction =
      AsyncAction('HomePageStoreBase.checkBoxVisibleInfoPin', context: context);

  @override
  Future checkBoxVisibleInfoPin(bool check) {
    return _$checkBoxVisibleInfoPinAsyncAction
        .run(() => super.checkBoxVisibleInfoPin(check));
  }

  late final _$getPlatformAsyncAction =
      AsyncAction('HomePageStoreBase.getPlatform', context: context);

  @override
  Future<dynamic> getPlatform() {
    return _$getPlatformAsyncAction.run(() => super.getPlatform());
  }

  late final _$getDataAsyncAction =
      AsyncAction('HomePageStoreBase.getData', context: context);

  @override
  Future<dynamic> getData() {
    return _$getDataAsyncAction.run(() => super.getData());
  }

  late final _$requestPermissionAsyncAction =
      AsyncAction('HomePageStoreBase.requestPermission', context: context);

  @override
  Future<void> requestPermission(Permission permission) {
    return _$requestPermissionAsyncAction
        .run(() => super.requestPermission(permission));
  }

  late final _$HomePageStoreBaseActionController =
      ActionController(name: 'HomePageStoreBase', context: context);

  @override
  dynamic sharedPrefs() {
    final _$actionInfo = _$HomePageStoreBaseActionController.startAction(
        name: 'HomePageStoreBase.sharedPrefs');
    try {
      return super.sharedPrefs();
    } finally {
      _$HomePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic visibleSearch() {
    final _$actionInfo = _$HomePageStoreBaseActionController.startAction(
        name: 'HomePageStoreBase.visibleSearch');
    try {
      return super.visibleSearch();
    } finally {
      _$HomePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool visibleIconSearch(int index) {
    final _$actionInfo = _$HomePageStoreBaseActionController.startAction(
        name: 'HomePageStoreBase.visibleIconSearch');
    try {
      return super.visibleIconSearch(index);
    } finally {
      _$HomePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<ItensModel> searchList(String search) {
    final _$actionInfo = _$HomePageStoreBaseActionController.startAction(
        name: 'HomePageStoreBase.searchList');
    try {
      return super.searchList(search);
    } finally {
      _$HomePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool loadingWidget(List<ItensModel> list) {
    final _$actionInfo = _$HomePageStoreBaseActionController.startAction(
        name: 'HomePageStoreBase.loadingWidget');
    try {
      return super.loadingWidget(list);
    } finally {
      _$HomePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic filterList(List<ItensModel> itens, String search) {
    final _$actionInfo = _$HomePageStoreBaseActionController.startAction(
        name: 'HomePageStoreBase.filterList');
    try {
      return super.filterList(itens, search);
    } finally {
      _$HomePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<Widget> screens() {
    final _$actionInfo = _$HomePageStoreBaseActionController.startAction(
        name: 'HomePageStoreBase.screens');
    try {
      return super.screens();
    } finally {
      _$HomePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onItemTapped(int index) {
    final _$actionInfo = _$HomePageStoreBaseActionController.startAction(
        name: 'HomePageStoreBase.onItemTapped');
    try {
      return super.onItemTapped(index);
    } finally {
      _$HomePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listItens: ${listItens},
listTypes: ${listTypes},
filterItens: ${filterItens},
typeLenghtClear: ${typeLenghtClear},
filterType: ${filterType},
type: ${type},
searchTextField: ${searchTextField},
searchController: ${searchController},
pin: ${pin},
path: ${path},
selectedIndex: ${selectedIndex},
mode: ${mode},
isChecked: ${isChecked},
listScreens: ${listScreens}
    ''';
  }
}
