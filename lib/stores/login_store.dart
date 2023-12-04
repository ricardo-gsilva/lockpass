import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/database/shared_preferences.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  SharedPrefs? sharedPref;

  @observable
  TextEditingController emailController = TextEditingController();

  @observable
  TextEditingController pinController = TextEditingController();

  @observable
  TextEditingController passwordController = TextEditingController();

  @observable
  TextEditingController resetPasswordController = TextEditingController();

  @observable
  bool userCreate = false;

  @observable
  bool confirmLogin = false;

  @observable
  bool resetPass = false;

  @observable
  String exception = '';

  @observable
  bool pinCreated = false;

  @observable
  bool sufixIcon = true;

  @observable
  bool obscureText = true;

  @observable
  int pin = 0;

  @observable
  String path = '';

  @action
  sharedPrefs() {
    SharedPreferences.getInstance().then((value) {
      sharedPref = SharedPrefs(sharedPreferences: value);      
    });
  }

  @action
  visibilityPass() {
    sufixIcon = !sufixIcon;
    obscureText = sufixIcon;
  }

  @action
  bool checkPinLength(String pin) {
    if ((pin.length < 5) || pin.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @action
  Future getPlatform() async {
    if (Platform.isAndroid) {
      path = await AndroidPathProvider.downloadsPath;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      path = directory.path;
    }
  }

  @action
  changeLoginWithPin(bool changeMode) {
    pinCreated = !pinCreated;
  }

  @action
  Future getPermissionStorage() async {
    await sharedPrefs();
    if (Platform.isIOS) {
      bool storage = await Permission.storage.status.isGranted;
      if (storage) {
        sharedPref?.setPermissionStorage(storage);
      } else {
        sharedPref?.setPermissionStorage(storage);
      }
    } else {
      bool storage = true;
      // Only check for storage < Android 13 && sdkInt < 33
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      storage = await Permission.storage.status.isGranted;

      if (storage == false) {
        requestPermission(Permission.storage);
      } else if (storage) {
        sharedPref?.setPermissionStorage(true);
      } else {
        sharedPref?.setPermissionStorage(false);
      }
    }
  }

  @action
  Future<String> pinDecrypt() async {
    await sharedPrefs();
    String getEncryptPin = sharedPref?.getPin() ?? '0';
    String pinDecrypt = getEncryptPin != '0'
        ? await EncryptDecrypt.decrypt(getEncryptPin)
        : getEncryptPin;
    return pinDecrypt;
  }

  @action
  Future<void> requestPermission(Permission permission) async {
    await sharedPrefs();
    final status = await permission.request();
    if (status.isGranted) {
      sharedPref?.setPermissionStorage(true);
    } else {
      sharedPref?.setPermissionStorage(false);
    }
  }

  @action
  String? validarEmail(String value) {
    String pattern = CoreStrings.regExpValidateEmail;
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return null;
    } else if (!regExp.hasMatch(value)) {
      return CoreStrings.emailInvalid;
    } else {
      return null;
    }
  }

  @action
  Future<bool> checkPin(String pin) async {
    await sharedPrefs();
    String pinEncrypt = sharedPref?.getPin() ?? '';
    String pinDecrypt = await EncryptDecrypt.decrypt(pinEncrypt);

    if (pin == pinDecrypt) {
      return true;
    } else {
      return false;
    }
  }

  @action
  Future<bool> pinIsValid() async {
    await sharedPrefs();
    String checkPin = sharedPref?.getPin() ?? '';
    if (checkPin.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @action
  bool checkField() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      exception = CoreStrings.manyEmptyFields;
      return false;
    } else {
      return true;
    }
  }

  @action
  Future<bool> login(String login, String password) async {
    try {
      return await AuthService().login(login, password);
    } on AuthException catch (e) {
      exception = e.message;
      return false;
    }
  }

  @action
  Future<bool> register(String login, String password) async {
    try {
      await AuthService().register(login, password);
      exception = CoreStrings.userCreateSucess;
      return true;
    } on AuthException catch (e) {
      exception = e.message;
      return false;
    }
  }

  @action
  Future<bool> resetPassword(String email) async {
    try {
      await AuthService().resetPassword(email);
      exception =
          'Um email foi enviado para $email. O email contém um link para redefinir sua senha!';
      return true;
    } on AuthException catch (e) {
      exception = e.message;
      return false;
    }
  }
}
