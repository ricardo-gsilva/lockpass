// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConfigPageStore on _ConfigPageStore, Store {
  Computed<bool>? _$visibleRemovePinComputed;

  @override
  bool get visibleRemovePin => (_$visibleRemovePinComputed ??= Computed<bool>(
          () => super.visibleRemovePin,
          name: '_ConfigPageStore.visibleRemovePin'))
      .value;

  late final _$pinControllerAtom =
      Atom(name: '_ConfigPageStore.pinController', context: context);

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

  late final _$colorPinAtom =
      Atom(name: '_ConfigPageStore.colorPin', context: context);

  @override
  Color? get colorPin {
    _$colorPinAtom.reportRead();
    return super.colorPin;
  }

  @override
  set colorPin(Color? value) {
    _$colorPinAtom.reportWrite(value, super.colorPin, () {
      super.colorPin = value;
    });
  }

  late final _$pinAtom = Atom(name: '_ConfigPageStore.pin', context: context);

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

  late final _$textPinAtom =
      Atom(name: '_ConfigPageStore.textPin', context: context);

  @override
  String? get textPin {
    _$textPinAtom.reportRead();
    return super.textPin;
  }

  @override
  set textPin(String? value) {
    _$textPinAtom.reportWrite(value, super.textPin, () {
      super.textPin = value;
    });
  }

  late final _$pinValidateAtom =
      Atom(name: '_ConfigPageStore.pinValidate', context: context);

  @override
  bool get pinValidate {
    _$pinValidateAtom.reportRead();
    return super.pinValidate;
  }

  @override
  set pinValidate(bool value) {
    _$pinValidateAtom.reportWrite(value, super.pinValidate, () {
      super.pinValidate = value;
    });
  }

  late final _$valuePinAtom =
      Atom(name: '_ConfigPageStore.valuePin', context: context);

  @override
  int get valuePin {
    _$valuePinAtom.reportRead();
    return super.valuePin;
  }

  @override
  set valuePin(int value) {
    _$valuePinAtom.reportWrite(value, super.valuePin, () {
      super.valuePin = value;
    });
  }

  late final _$pathAtom = Atom(name: '_ConfigPageStore.path', context: context);

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

  late final _$heightAtom =
      Atom(name: '_ConfigPageStore.height', context: context);

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

  late final _$percentAtom =
      Atom(name: '_ConfigPageStore.percent', context: context);

  @override
  double get percent {
    _$percentAtom.reportRead();
    return super.percent;
  }

  @override
  set percent(double value) {
    _$percentAtom.reportWrite(value, super.percent, () {
      super.percent = value;
    });
  }

  late final _$isAndroidAtom =
      Atom(name: '_ConfigPageStore.isAndroid', context: context);

  @override
  bool get isAndroid {
    _$isAndroidAtom.reportRead();
    return super.isAndroid;
  }

  @override
  set isAndroid(bool value) {
    _$isAndroidAtom.reportWrite(value, super.isAndroid, () {
      super.isAndroid = value;
    });
  }

  late final _$uploadPathAtom =
      Atom(name: '_ConfigPageStore.uploadPath', context: context);

  @override
  TextEditingController get uploadPath {
    _$uploadPathAtom.reportRead();
    return super.uploadPath;
  }

  @override
  set uploadPath(TextEditingController value) {
    _$uploadPathAtom.reportWrite(value, super.uploadPath, () {
      super.uploadPath = value;
    });
  }

  late final _$_pathsAtom =
      Atom(name: '_ConfigPageStore._paths', context: context);

  @override
  List<PlatformFile>? get _paths {
    _$_pathsAtom.reportRead();
    return super._paths;
  }

  @override
  set _paths(List<PlatformFile>? value) {
    _$_pathsAtom.reportWrite(value, super._paths, () {
      super._paths = value;
    });
  }

  late final _$directoryAtom =
      Atom(name: '_ConfigPageStore.directory', context: context);

  @override
  String get directory {
    _$directoryAtom.reportRead();
    return super.directory;
  }

  @override
  set directory(String value) {
    _$directoryAtom.reportWrite(value, super.directory, () {
      super.directory = value;
    });
  }

  late final _$isCryptedAtom =
      Atom(name: '_ConfigPageStore.isCrypted', context: context);

  @override
  bool get isCrypted {
    _$isCryptedAtom.reportRead();
    return super.isCrypted;
  }

  @override
  set isCrypted(bool value) {
    _$isCryptedAtom.reportWrite(value, super.isCrypted, () {
      super.isCrypted = value;
    });
  }

  late final _$zipFileAtom =
      Atom(name: '_ConfigPageStore.zipFile', context: context);

  @override
  File get zipFile {
    _$zipFileAtom.reportRead();
    return super.zipFile;
  }

  @override
  set zipFile(File value) {
    _$zipFileAtom.reportWrite(value, super.zipFile, () {
      super.zipFile = value;
    });
  }

  late final _$selectedFileAtom =
      Atom(name: '_ConfigPageStore.selectedFile', context: context);

  @override
  bool get selectedFile {
    _$selectedFileAtom.reportRead();
    return super.selectedFile;
  }

  @override
  set selectedFile(bool value) {
    _$selectedFileAtom.reportWrite(value, super.selectedFile, () {
      super.selectedFile = value;
    });
  }

  late final _$sharedPrefsAsyncAction =
      AsyncAction('_ConfigPageStore.sharedPrefs', context: context);

  @override
  Future sharedPrefs() {
    return _$sharedPrefsAsyncAction.run(() => super.sharedPrefs());
  }

  late final _$validatePinAsyncAction =
      AsyncAction('_ConfigPageStore.validatePin', context: context);

  @override
  Future validatePin(String pin) {
    return _$validatePinAsyncAction.run(() => super.validatePin(pin));
  }

  late final _$savePinAsyncAction =
      AsyncAction('_ConfigPageStore.savePin', context: context);

  @override
  Future savePin(String pin) {
    return _$savePinAsyncAction.run(() => super.savePin(pin));
  }

  late final _$removePinAsyncAction =
      AsyncAction('_ConfigPageStore.removePin', context: context);

  @override
  Future removePin() {
    return _$removePinAsyncAction.run(() => super.removePin());
  }

  late final _$getPinVerificationAsyncAction =
      AsyncAction('_ConfigPageStore.getPinVerification', context: context);

  @override
  Future getPinVerification() {
    return _$getPinVerificationAsyncAction
        .run(() => super.getPinVerification());
  }

  late final _$verifyPlatformAsyncAction =
      AsyncAction('_ConfigPageStore.verifyPlatform', context: context);

  @override
  Future verifyPlatform() {
    return _$verifyPlatformAsyncAction.run(() => super.verifyPlatform());
  }

  late final _$checkPermissionAsyncAction =
      AsyncAction('_ConfigPageStore.checkPermission', context: context);

  @override
  Future<bool> checkPermission() {
    return _$checkPermissionAsyncAction.run(() => super.checkPermission());
  }

  late final _$pinDecryptAsyncAction =
      AsyncAction('_ConfigPageStore.pinDecrypt', context: context);

  @override
  Future<String> pinDecrypt() {
    return _$pinDecryptAsyncAction.run(() => super.pinDecrypt());
  }

  late final _$selectFileAsyncAction =
      AsyncAction('_ConfigPageStore.selectFile', context: context);

  @override
  Future selectFile() {
    return _$selectFileAsyncAction.run(() => super.selectFile());
  }

  late final _$_ConfigPageStoreActionController =
      ActionController(name: '_ConfigPageStore', context: context);

  @override
  bool checkPinLength(String pin) {
    final _$actionInfo = _$_ConfigPageStoreActionController.startAction(
        name: '_ConfigPageStore.checkPinLength');
    try {
      return super.checkPinLength(pin);
    } finally {
      _$_ConfigPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool isZipFileEncrypted() {
    final _$actionInfo = _$_ConfigPageStoreActionController.startAction(
        name: '_ConfigPageStore.isZipFileEncrypted');
    try {
      return super.isZipFileEncrypted();
    } finally {
      _$_ConfigPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pinController: ${pinController},
colorPin: ${colorPin},
pin: ${pin},
textPin: ${textPin},
pinValidate: ${pinValidate},
valuePin: ${valuePin},
path: ${path},
height: ${height},
percent: ${percent},
isAndroid: ${isAndroid},
uploadPath: ${uploadPath},
directory: ${directory},
isCrypted: ${isCrypted},
zipFile: ${zipFile},
selectedFile: ${selectedFile},
visibleRemovePin: ${visibleRemovePin}
    ''';
  }
}
