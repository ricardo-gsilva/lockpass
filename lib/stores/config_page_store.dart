// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/database/shared_preferences.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'config_page_store.g.dart';

class ConfigPageStore = _ConfigPageStore with _$ConfigPageStore;

abstract class _ConfigPageStore with Store{
  CoreStrings strings = CoreStrings();
  SharedPrefs? sharedPref;

  @observable
  TextEditingController pinController = TextEditingController(text: '');
  
  @observable
  Color? colorPin;

  @observable
  int pin = 0;

  @observable
  String? textPin = CoreStrings.registerPin;

  @observable
  bool pinValidate = false;

  @observable
  int valuePin = 0;

  @observable
  String path = '';

  @observable
  double height = 0;

  @observable
  double percent = 0;

  @observable
  bool isAndroid = true;
  
  @observable
  TextEditingController uploadPath = TextEditingController();

  @observable
  List<PlatformFile>? _paths;

  @observable
  String directory = '';

  @observable
  bool isCrypted = false;

  @observable
  File zipFile = File('');
  
  @observable
  bool selectedFile = false;

  @computed
  bool get visibleRemovePin => textPin != CoreStrings.registerPin;

  @action
  sharedPrefs() async {    
    SharedPreferences.getInstance().then((value) {
      sharedPref = SharedPrefs(sharedPreferences: value);      
    });
  }

  @action
  Future<bool> deleteAccount() async {
    await sharedPrefs();
    try {
      await AuthService().deleteAccount();
      sharedPref?.removePin();
      return true;
    } catch (e) {
      return false;
    }
  }

  @action  
  bool checkPinLength(String pin){    
    if((pin.length < 5) || pin.isEmpty){
      return false;      
    } else {
      validatePin(pin);
      return true;      
    }
  }

  @action
  validatePin(String pin) async {    
    RegExp exp = RegExp(CoreStrings.regExpValidatePin);
    valuePin = pin.isEmpty ? 0 : int.parse(pin);
      if(exp.hasMatch(pin)){
        pinValidate = true;
      } else {
        pinValidate = false;
      }
  }

  @action
  savePin(String pin) async {
    await sharedPrefs();
    final String pinEncrypt = await EncryptDecrypt.encrypted(pin);    
    await sharedPref?.setSavePin(pinEncrypt);
  }

  @action
  removePin() async{
    await sharedPrefs();
    sharedPref?.removePin();
    sharedPref?.setVisibleInfoCreatePin(false);
    getPinVerification();
  }

  @action
  getPinVerification() async {
    await sharedPrefs();
    String getEncryptPin = sharedPref?.getPin()?? '';
    String pinDecrypt = await EncryptDecrypt.decrypt(getEncryptPin);

    pin = int.parse(pinDecrypt);

    if(pin != 0){
      colorPin = CoreColors.textPrimary;
      textPin = CoreStrings.updatePin;
    } else { 
      colorPin = CoreColors.pinIsEmpty;
      textPin = CoreStrings.registerPin;
    }
  } 

  @action
  verifyPlatform() async {
    if (Platform.isAndroid) {
      path = await AndroidPathProvider.downloadsPath;
      isAndroid = true;
    } else {
      final directory = await getApplicationDocumentsDirectory();   
      path = directory.path;
      isAndroid = false;
    }
  }

  Future<void> requestPermission(Permission permission) async {
    await sharedPrefs();
    final status = await permission.request();
      if(status.isGranted){
        sharedPref?.setPermissionStorage(true);
      } else {
        sharedPref?.setPermissionStorage(false);
      }
  }

  @action
  Future<bool> checkPermission() async {
    await sharedPrefs();
    bool storage = sharedPref?.getPermissionStorage()?? false;
    if(storage){
      return true;
    } else {
      return false;
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
  selectFile() async {
    directory = CoreStrings.appName;
    _paths = null;
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        initialDirectory: directory,
        lockParentWindow: true,
      ))?.files;
      _paths?.map((e){
        uploadPath.text = e.name;
      }).toList();
      selectedFile = true;
    } on PlatformException catch (e) {
      selectedFile = false;
      e.toString();
    } catch (e) {
      selectedFile = false;
      e.toString();
    }      
  }

  @action
  bool isZipFileEncrypted() {
    zipFile = File('$path/${uploadPath.text}');
    final input = InputFileStream(zipFile.path);
    try {
      final signature = input.readUint32();
      if (signature != ZipFile.zipFileSignature) {
        throw ArchiveException(CoreStrings.invalidSignatureZip);
      }
      final version = input.readUint16();
      final flags = input.readUint16();
      final encryptionType = (flags & 0x1) != 0
          ? ZipFile.encryptionZipCrypto
          : ZipFile.encryptionNone;
      isCrypted = encryptionType != ZipFile.encryptionNone;
      return isCrypted;
    } finally {
      input.close();
    }
  }
}