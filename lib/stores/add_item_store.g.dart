// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_item_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddItemStore on AddItemStoreBase, Store {
  late final _$typeControllerAtom =
      Atom(name: 'AddItemStoreBase.typeController', context: context);

  @override
  TextEditingController get typeController {
    _$typeControllerAtom.reportRead();
    return super.typeController;
  }

  @override
  set typeController(TextEditingController value) {
    _$typeControllerAtom.reportWrite(value, super.typeController, () {
      super.typeController = value;
    });
  }

  late final _$serviceControllerAtom =
      Atom(name: 'AddItemStoreBase.serviceController', context: context);

  @override
  TextEditingController get serviceController {
    _$serviceControllerAtom.reportRead();
    return super.serviceController;
  }

  @override
  set serviceController(TextEditingController value) {
    _$serviceControllerAtom.reportWrite(value, super.serviceController, () {
      super.serviceController = value;
    });
  }

  late final _$siteControllerAtom =
      Atom(name: 'AddItemStoreBase.siteController', context: context);

  @override
  TextEditingController get siteController {
    _$siteControllerAtom.reportRead();
    return super.siteController;
  }

  @override
  set siteController(TextEditingController value) {
    _$siteControllerAtom.reportWrite(value, super.siteController, () {
      super.siteController = value;
    });
  }

  late final _$emailControllerAtom =
      Atom(name: 'AddItemStoreBase.emailController', context: context);

  @override
  TextEditingController get emailController {
    _$emailControllerAtom.reportRead();
    return super.emailController;
  }

  @override
  set emailController(TextEditingController value) {
    _$emailControllerAtom.reportWrite(value, super.emailController, () {
      super.emailController = value;
    });
  }

  late final _$loginControllerAtom =
      Atom(name: 'AddItemStoreBase.loginController', context: context);

  @override
  TextEditingController get loginController {
    _$loginControllerAtom.reportRead();
    return super.loginController;
  }

  @override
  set loginController(TextEditingController value) {
    _$loginControllerAtom.reportWrite(value, super.loginController, () {
      super.loginController = value;
    });
  }

  late final _$passwordControllerAtom =
      Atom(name: 'AddItemStoreBase.passwordController', context: context);

  @override
  TextEditingController get passwordController {
    _$passwordControllerAtom.reportRead();
    return super.passwordController;
  }

  @override
  set passwordController(TextEditingController value) {
    _$passwordControllerAtom.reportWrite(value, super.passwordController, () {
      super.passwordController = value;
    });
  }

  late final _$fieldIsValidAtom =
      Atom(name: 'AddItemStoreBase.fieldIsValid', context: context);

  @override
  bool get fieldIsValid {
    _$fieldIsValidAtom.reportRead();
    return super.fieldIsValid;
  }

  @override
  set fieldIsValid(bool value) {
    _$fieldIsValidAtom.reportWrite(value, super.fieldIsValid, () {
      super.fieldIsValid = value;
    });
  }

  late final _$formIsValidAtom =
      Atom(name: 'AddItemStoreBase.formIsValid', context: context);

  @override
  bool get formIsValid {
    _$formIsValidAtom.reportRead();
    return super.formIsValid;
  }

  @override
  set formIsValid(bool value) {
    _$formIsValidAtom.reportWrite(value, super.formIsValid, () {
      super.formIsValid = value;
    });
  }

  late final _$sufixIconAtom =
      Atom(name: 'AddItemStoreBase.sufixIcon', context: context);

  @override
  bool get sufixIcon {
    _$sufixIconAtom.reportRead();
    return super.sufixIcon;
  }

  @override
  set sufixIcon(bool value) {
    _$sufixIconAtom.reportWrite(value, super.sufixIcon, () {
      super.sufixIcon = value;
    });
  }

  late final _$obscureTextAtom =
      Atom(name: 'AddItemStoreBase.obscureText', context: context);

  @override
  bool get obscureText {
    _$obscureTextAtom.reportRead();
    return super.obscureText;
  }

  @override
  set obscureText(bool value) {
    _$obscureTextAtom.reportWrite(value, super.obscureText, () {
      super.obscureText = value;
    });
  }

  late final _$listItensAtom =
      Atom(name: 'AddItemStoreBase.listItens', context: context);

  @override
  ObservableList<String> get listItens {
    _$listItensAtom.reportRead();
    return super.listItens;
  }

  @override
  set listItens(ObservableList<String> value) {
    _$listItensAtom.reportWrite(value, super.listItens, () {
      super.listItens = value;
    });
  }

  late final _$listItensDropAtom =
      Atom(name: 'AddItemStoreBase.listItensDrop', context: context);

  @override
  ObservableList<String> get listItensDrop {
    _$listItensDropAtom.reportRead();
    return super.listItensDrop;
  }

  @override
  set listItensDrop(ObservableList<String> value) {
    _$listItensDropAtom.reportWrite(value, super.listItensDrop, () {
      super.listItensDrop = value;
    });
  }

  late final _$AddItemStoreBaseActionController =
      ActionController(name: 'AddItemStoreBase', context: context);

  @override
  void listItemDropDown(List<ItensModel>? itens) {
    final _$actionInfo = _$AddItemStoreBaseActionController.startAction(
        name: 'AddItemStoreBase.listItemDropDown');
    try {
      return super.listItemDropDown(itens);
    } finally {
      _$AddItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic visibilityPass() {
    final _$actionInfo = _$AddItemStoreBaseActionController.startAction(
        name: 'AddItemStoreBase.visibilityPass');
    try {
      return super.visibilityPass();
    } finally {
      _$AddItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String? validarEmail(String value) {
    final _$actionInfo = _$AddItemStoreBaseActionController.startAction(
        name: 'AddItemStoreBase.validarEmail');
    try {
      return super.validarEmail(value);
    } finally {
      _$AddItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String? textFieldValidator(String value) {
    final _$actionInfo = _$AddItemStoreBaseActionController.startAction(
        name: 'AddItemStoreBase.textFieldValidator');
    try {
      return super.textFieldValidator(value);
    } finally {
      _$AddItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic formValidator(String password, String login, String service) {
    final _$actionInfo = _$AddItemStoreBaseActionController.startAction(
        name: 'AddItemStoreBase.formValidator');
    try {
      return super.formValidator(password, login, service);
    } finally {
      _$AddItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addItem(ItensModel item) {
    final _$actionInfo = _$AddItemStoreBaseActionController.startAction(
        name: 'AddItemStoreBase.addItem');
    try {
      return super.addItem(item);
    } finally {
      _$AddItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearController() {
    final _$actionInfo = _$AddItemStoreBaseActionController.startAction(
        name: 'AddItemStoreBase.clearController');
    try {
      return super.clearController();
    } finally {
      _$AddItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
typeController: ${typeController},
serviceController: ${serviceController},
siteController: ${siteController},
emailController: ${emailController},
loginController: ${loginController},
passwordController: ${passwordController},
fieldIsValid: ${fieldIsValid},
formIsValid: ${formIsValid},
sufixIcon: ${sufixIcon},
obscureText: ${obscureText},
listItens: ${listItens},
listItensDrop: ${listItensDrop}
    ''';
  }
}
