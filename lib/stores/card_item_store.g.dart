// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_item_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CardItemStore on CardItemStoreBase, Store {
  late final _$itensAtom =
      Atom(name: 'CardItemStoreBase.itens', context: context);

  @override
  ItensModel? get itens {
    _$itensAtom.reportRead();
    return super.itens;
  }

  @override
  set itens(ItensModel? value) {
    _$itensAtom.reportWrite(value, super.itens, () {
      super.itens = value;
    });
  }

  late final _$listTypeDropAtom =
      Atom(name: 'CardItemStoreBase.listTypeDrop', context: context);

  @override
  ObservableList<String> get listTypeDrop {
    _$listTypeDropAtom.reportRead();
    return super.listTypeDrop;
  }

  @override
  set listTypeDrop(ObservableList<String> value) {
    _$listTypeDropAtom.reportWrite(value, super.listTypeDrop, () {
      super.listTypeDrop = value;
    });
  }

  late final _$visibilityPasswordAtom =
      Atom(name: 'CardItemStoreBase.visibilityPassword', context: context);

  @override
  String get visibilityPassword {
    _$visibilityPasswordAtom.reportRead();
    return super.visibilityPassword;
  }

  @override
  set visibilityPassword(String value) {
    _$visibilityPasswordAtom.reportWrite(value, super.visibilityPassword, () {
      super.visibilityPassword = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: 'CardItemStoreBase.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$visiblePassAtom =
      Atom(name: 'CardItemStoreBase.visiblePass', context: context);

  @override
  bool get visiblePass {
    _$visiblePassAtom.reportRead();
    return super.visiblePass;
  }

  @override
  set visiblePass(bool value) {
    _$visiblePassAtom.reportWrite(value, super.visiblePass, () {
      super.visiblePass = value;
    });
  }

  late final _$editAtom =
      Atom(name: 'CardItemStoreBase.edit', context: context);

  @override
  bool get edit {
    _$editAtom.reportRead();
    return super.edit;
  }

  @override
  set edit(bool value) {
    _$editAtom.reportWrite(value, super.edit, () {
      super.edit = value;
    });
  }

  late final _$validationAtom =
      Atom(name: 'CardItemStoreBase.validation', context: context);

  @override
  bool get validation {
    _$validationAtom.reportRead();
    return super.validation;
  }

  @override
  set validation(bool value) {
    _$validationAtom.reportWrite(value, super.validation, () {
      super.validation = value;
    });
  }

  late final _$formValidatorAtom =
      Atom(name: 'CardItemStoreBase.formValidator', context: context);

  @override
  bool get formValidator {
    _$formValidatorAtom.reportRead();
    return super.formValidator;
  }

  @override
  set formValidator(bool value) {
    _$formValidatorAtom.reportWrite(value, super.formValidator, () {
      super.formValidator = value;
    });
  }

  late final _$heightAtom =
      Atom(name: 'CardItemStoreBase.height', context: context);

  @override
  double get height {
    _$heightAtom.reportRead();
    return super.height;
  }

  @override
  set height(double value) {
    _$heightAtom.reportWrite(value, super.height, () {
      super.height = value;
    });
  }

  late final _$widthAtom =
      Atom(name: 'CardItemStoreBase.width', context: context);

  @override
  double get width {
    _$widthAtom.reportRead();
    return super.width;
  }

  @override
  set width(double value) {
    _$widthAtom.reportWrite(value, super.width, () {
      super.width = value;
    });
  }

  late final _$typeControllerAtom =
      Atom(name: 'CardItemStoreBase.typeController', context: context);

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
      Atom(name: 'CardItemStoreBase.serviceController', context: context);

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
      Atom(name: 'CardItemStoreBase.siteController', context: context);

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
      Atom(name: 'CardItemStoreBase.emailController', context: context);

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
      Atom(name: 'CardItemStoreBase.loginController', context: context);

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
      Atom(name: 'CardItemStoreBase.passwordController', context: context);

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

  late final _$newItenAtom =
      Atom(name: 'CardItemStoreBase.newIten', context: context);

  @override
  ItensModel get newIten {
    _$newItenAtom.reportRead();
    return super.newIten;
  }

  @override
  set newIten(ItensModel value) {
    _$newItenAtom.reportWrite(value, super.newIten, () {
      super.newIten = value;
    });
  }

  late final _$iconAtom =
      Atom(name: 'CardItemStoreBase.icon', context: context);

  @override
  IconData get icon {
    _$iconAtom.reportRead();
    return super.icon;
  }

  @override
  set icon(IconData value) {
    _$iconAtom.reportWrite(value, super.icon, () {
      super.icon = value;
    });
  }

  late final _$saveEditItemAsyncAction =
      AsyncAction('CardItemStoreBase.saveEditItem', context: context);

  @override
  Future<bool> saveEditItem(ItensModel item) {
    return _$saveEditItemAsyncAction.run(() => super.saveEditItem(item));
  }

  late final _$visibilityPassAsyncAction =
      AsyncAction('CardItemStoreBase.visibilityPass', context: context);

  @override
  Future visibilityPass(String pass) {
    return _$visibilityPassAsyncAction.run(() => super.visibilityPass(pass));
  }

  late final _$passDecryptAsyncAction =
      AsyncAction('CardItemStoreBase.passDecrypt', context: context);

  @override
  Future<String> passDecrypt(String pass) {
    return _$passDecryptAsyncAction.run(() => super.passDecrypt(pass));
  }

  late final _$CardItemStoreBaseActionController =
      ActionController(name: 'CardItemStoreBase', context: context);

  @override
  dynamic listItemDropDown(List<TypeModel> list) {
    final _$actionInfo = _$CardItemStoreBaseActionController.startAction(
        name: 'CardItemStoreBase.listItemDropDown');
    try {
      return super.listItemDropDown(list);
    } finally {
      _$CardItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getItem(ItensModel item) {
    final _$actionInfo = _$CardItemStoreBaseActionController.startAction(
        name: 'CardItemStoreBase.getItem');
    try {
      return super.getItem(item);
    } finally {
      _$CardItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getSize(double h, double w) {
    final _$actionInfo = _$CardItemStoreBaseActionController.startAction(
        name: 'CardItemStoreBase.getSize');
    try {
      return super.getSize(h, w);
    } finally {
      _$CardItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validator(String password, String login, String service) {
    final _$actionInfo = _$CardItemStoreBaseActionController.startAction(
        name: 'CardItemStoreBase.validator');
    try {
      return super.validator(password, login, service);
    } finally {
      _$CardItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String? validarEmail(String value) {
    final _$actionInfo = _$CardItemStoreBaseActionController.startAction(
        name: 'CardItemStoreBase.validarEmail');
    try {
      return super.validarEmail(value);
    } finally {
      _$CardItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String? textFieldValidator(String value) {
    final _$actionInfo = _$CardItemStoreBaseActionController.startAction(
        name: 'CardItemStoreBase.textFieldValidator');
    try {
      return super.textFieldValidator(value);
    } finally {
      _$CardItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearController() {
    final _$actionInfo = _$CardItemStoreBaseActionController.startAction(
        name: 'CardItemStoreBase.clearController');
    try {
      return super.clearController();
    } finally {
      _$CardItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeIcon(bool verifyIcon) {
    final _$actionInfo = _$CardItemStoreBaseActionController.startAction(
        name: 'CardItemStoreBase.changeIcon');
    try {
      return super.changeIcon(verifyIcon);
    } finally {
      _$CardItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
itens: ${itens},
listTypeDrop: ${listTypeDrop},
visibilityPassword: ${visibilityPassword},
password: ${password},
visiblePass: ${visiblePass},
edit: ${edit},
validation: ${validation},
formValidator: ${formValidator},
height: ${height},
width: ${width},
typeController: ${typeController},
serviceController: ${serviceController},
siteController: ${siteController},
emailController: ${emailController},
loginController: ${loginController},
passwordController: ${passwordController},
newIten: ${newIten},
icon: ${icon}
    ''';
  }
}
