// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on LoginStoreBase, Store {
  late final _$emailControllerAtom =
      Atom(name: 'LoginStoreBase.emailController', context: context);

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

  late final _$pinControllerAtom =
      Atom(name: 'LoginStoreBase.pinController', context: context);

  @override
  TextEditingController get pinController {
    _$pinControllerAtom.reportRead();
    return super.pinController;
  }

  @override
  set pinController(TextEditingController value) {
    _$pinControllerAtom.reportWrite(value, super.pinController, () {
      super.pinController = value;
    });
  }

  late final _$passwordControllerAtom =
      Atom(name: 'LoginStoreBase.passwordController', context: context);

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

  late final _$resetPasswordControllerAtom =
      Atom(name: 'LoginStoreBase.resetPasswordController', context: context);

  @override
  TextEditingController get resetPasswordController {
    _$resetPasswordControllerAtom.reportRead();
    return super.resetPasswordController;
  }

  @override
  set resetPasswordController(TextEditingController value) {
    _$resetPasswordControllerAtom
        .reportWrite(value, super.resetPasswordController, () {
      super.resetPasswordController = value;
    });
  }

  late final _$userCreateAtom =
      Atom(name: 'LoginStoreBase.userCreate', context: context);

  @override
  bool get userCreate {
    _$userCreateAtom.reportRead();
    return super.userCreate;
  }

  @override
  set userCreate(bool value) {
    _$userCreateAtom.reportWrite(value, super.userCreate, () {
      super.userCreate = value;
    });
  }

  late final _$confirmLoginAtom =
      Atom(name: 'LoginStoreBase.confirmLogin', context: context);

  @override
  bool get confirmLogin {
    _$confirmLoginAtom.reportRead();
    return super.confirmLogin;
  }

  @override
  set confirmLogin(bool value) {
    _$confirmLoginAtom.reportWrite(value, super.confirmLogin, () {
      super.confirmLogin = value;
    });
  }

  late final _$resetPassAtom =
      Atom(name: 'LoginStoreBase.resetPass', context: context);

  @override
  bool get resetPass {
    _$resetPassAtom.reportRead();
    return super.resetPass;
  }

  @override
  set resetPass(bool value) {
    _$resetPassAtom.reportWrite(value, super.resetPass, () {
      super.resetPass = value;
    });
  }

  late final _$exceptionAtom =
      Atom(name: 'LoginStoreBase.exception', context: context);

  @override
  String get exception {
    _$exceptionAtom.reportRead();
    return super.exception;
  }

  @override
  set exception(String value) {
    _$exceptionAtom.reportWrite(value, super.exception, () {
      super.exception = value;
    });
  }

  late final _$pinCreatedAtom =
      Atom(name: 'LoginStoreBase.pinCreated', context: context);

  @override
  bool get pinCreated {
    _$pinCreatedAtom.reportRead();
    return super.pinCreated;
  }

  @override
  set pinCreated(bool value) {
    _$pinCreatedAtom.reportWrite(value, super.pinCreated, () {
      super.pinCreated = value;
    });
  }

  late final _$sufixIconAtom =
      Atom(name: 'LoginStoreBase.sufixIcon', context: context);

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
      Atom(name: 'LoginStoreBase.obscureText', context: context);

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

  late final _$pinAtom = Atom(name: 'LoginStoreBase.pin', context: context);

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

  late final _$pathAtom = Atom(name: 'LoginStoreBase.path', context: context);

  @override
  String get path {
    _$pathAtom.reportRead();
    return super.path;
  }

  @override
  set path(String value) {
    _$pathAtom.reportWrite(value, super.path, () {
      super.path = value;
    });
  }

  late final _$getPlatformAsyncAction =
      AsyncAction('LoginStoreBase.getPlatform', context: context);

  @override
  Future<dynamic> getPlatform() {
    return _$getPlatformAsyncAction.run(() => super.getPlatform());
  }

  late final _$getPermissionStorageAsyncAction =
      AsyncAction('LoginStoreBase.getPermissionStorage', context: context);

  @override
  Future<dynamic> getPermissionStorage() {
    return _$getPermissionStorageAsyncAction
        .run(() => super.getPermissionStorage());
  }

  late final _$pinDecryptAsyncAction =
      AsyncAction('LoginStoreBase.pinDecrypt', context: context);

  @override
  Future<String> pinDecrypt() {
    return _$pinDecryptAsyncAction.run(() => super.pinDecrypt());
  }

  late final _$requestPermissionAsyncAction =
      AsyncAction('LoginStoreBase.requestPermission', context: context);

  @override
  Future<void> requestPermission(Permission permission) {
    return _$requestPermissionAsyncAction
        .run(() => super.requestPermission(permission));
  }

  late final _$checkPinAsyncAction =
      AsyncAction('LoginStoreBase.checkPin', context: context);

  @override
  Future<bool> checkPin(String pin) {
    return _$checkPinAsyncAction.run(() => super.checkPin(pin));
  }

  late final _$pinIsValidAsyncAction =
      AsyncAction('LoginStoreBase.pinIsValid', context: context);

  @override
  Future<bool> pinIsValid() {
    return _$pinIsValidAsyncAction.run(() => super.pinIsValid());
  }

  late final _$loginAsyncAction =
      AsyncAction('LoginStoreBase.login', context: context);

  @override
  Future<bool> login(String login, String password) {
    return _$loginAsyncAction.run(() => super.login(login, password));
  }

  late final _$registerAsyncAction =
      AsyncAction('LoginStoreBase.register', context: context);

  @override
  Future<bool> register(String login, String password) {
    return _$registerAsyncAction.run(() => super.register(login, password));
  }

  late final _$resetPasswordAsyncAction =
      AsyncAction('LoginStoreBase.resetPassword', context: context);

  @override
  Future<bool> resetPassword(String email) {
    return _$resetPasswordAsyncAction.run(() => super.resetPassword(email));
  }

  late final _$LoginStoreBaseActionController =
      ActionController(name: 'LoginStoreBase', context: context);

  @override
  dynamic sharedPrefs() {
    final _$actionInfo = _$LoginStoreBaseActionController.startAction(
        name: 'LoginStoreBase.sharedPrefs');
    try {
      return super.sharedPrefs();
    } finally {
      _$LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic visibilityPass() {
    final _$actionInfo = _$LoginStoreBaseActionController.startAction(
        name: 'LoginStoreBase.visibilityPass');
    try {
      return super.visibilityPass();
    } finally {
      _$LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool checkPinLength(String pin) {
    final _$actionInfo = _$LoginStoreBaseActionController.startAction(
        name: 'LoginStoreBase.checkPinLength');
    try {
      return super.checkPinLength(pin);
    } finally {
      _$LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeLoginWithPin(bool changeMode) {
    final _$actionInfo = _$LoginStoreBaseActionController.startAction(
        name: 'LoginStoreBase.changeLoginWithPin');
    try {
      return super.changeLoginWithPin(changeMode);
    } finally {
      _$LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String? validarEmail(String value) {
    final _$actionInfo = _$LoginStoreBaseActionController.startAction(
        name: 'LoginStoreBase.validarEmail');
    try {
      return super.validarEmail(value);
    } finally {
      _$LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool checkField() {
    final _$actionInfo = _$LoginStoreBaseActionController.startAction(
        name: 'LoginStoreBase.checkField');
    try {
      return super.checkField();
    } finally {
      _$LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
emailController: ${emailController},
pinController: ${pinController},
passwordController: ${passwordController},
resetPasswordController: ${resetPasswordController},
userCreate: ${userCreate},
confirmLogin: ${confirmLogin},
resetPass: ${resetPass},
exception: ${exception},
pinCreated: ${pinCreated},
sufixIcon: ${sufixIcon},
obscureText: ${obscureText},
pin: ${pin},
path: ${path}
    ''';
  }
}
