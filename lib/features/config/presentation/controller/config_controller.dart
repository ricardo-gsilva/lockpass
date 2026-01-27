import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../state/config_state.dart';

class ConfigController extends Cubit<ConfigState> {
  final VaultService _vaultService;
  final AuthService _authService;

  ConfigController({
    required VaultService vaultService,
    required AuthService authService,
  }) : _vaultService = vaultService,
      _authService = authService,
   super(const ConfigState());

  void clearMessages() {
    emit(state.copyWith(errorMessage: '', successMessage: ''));
  }

  String get _uid {
    final uid = _vaultService.userId;
    if (uid.isEmpty) throw Exception('Usuário não autenticado.');
    return uid;
  }

  void resetPinForm() {
    emit(state.copyWith(
      isFormValid: false,
      pinValidate: false,
    ));
  }

  void onFormChanged({
    required bool isFormValid,
    required bool isUpdate,
    required String currentPin,
    String? newPin,
  }) {
    final _currentPin = currentPin.isNotNullOrBlank && currentPin.trim().length == 5;
    final _newPin = newPin.isNotNullOrBlank && newPin?.trim().length == 5;

    if(!isUpdate){
      if(!_newPin){
        emit(state.copyWith(pinValidate: false, isFormValid: false));
        return;
      }

      emit(state.copyWith(pinValidate: true, isFormValid: true),);
    }

    if(!_currentPin || !_newPin){
      emit(state.copyWith(
        pinValidate: false,
        isFormValid: false,
        ),);      
    }   

    emit(state.copyWith(
      pinValidate: true,
      isFormValid: isFormValid,
    ));
  }

  // -------------------------
  // Initial load
  // -------------------------
  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _vaultService.initializePreferences();
      await getPinVerification();
      await verifyPlatform();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<bool> reauthenticate({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        successMessage: '',
        errorMessage: '',
      ));
      await _authService.reauthenticateWithPassword(
        email: email,
        password: password,
      );
      emit(state.copyWith(
        successMessage: "Identidade confirmada. Agora crie um novo PIN.",
        isLoading: false,
        hasPin: false,
      ));
      removePin();
      return true;
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Não foi possível confirmar sua identidade. Verifique e-mail e senha e tente novamente.",        
      ));
      return false;
    }    
  }

  // -------------------------
  // Auth
  // -------------------------
  Future<bool> deleteAccount() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _vaultService.initializePreferences();
      await AuthService().deleteAccount();
      final prefs =  await _vaultService.prefs();
      await prefs.removePin(_uid);

      emit(state.copyWith(
        isLoading: false,
        successMessage: 'Conta removida com sucesso.',
        hasPin: false,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return false;
    }
  }

  Future<bool> signOut() async {
    emit(state.copyWith(isLoading: true));
    try {
      await AuthService().sigInOut();
      emit(state.copyWith(isLoading: false, successMessage: 'Saiu da conta.'));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return false;
    }
  }

  // -------------------------
  // PIN
  // -------------------------

  Future<bool> verifyCurrentPin(String typedPin) async {
    await _vaultService.initializePreferences();

    final uid = _authService.currentUserId;
    if (uid.isEmpty) return false;

    final prefs = await _vaultService.prefs();    
    final savedEncrypted = prefs.getPin(uid);
    if (savedEncrypted.isEmpty || savedEncrypted == '0') return false;

    final savedDecrypted = await EncryptDecrypt.decrypt(savedEncrypted);

    return typedPin.trim() == savedDecrypted.trim();
  }

  bool pinIsValid(String pin) {
    final exp = RegExp(CoreStrings.regExpValidatePin);
    return exp.hasMatch(pin);
  }

  Future<void> saveNewPin(String newAndUpdatePin) async {
    await _vaultService.initializePreferences();
    final prefs = await _vaultService.prefs();
    try {
      final newPin = pinIsValid(newAndUpdatePin);
      if(!newPin){
        emit(state.copyWith(
          pinValidate: false,
          errorMessage: 'PIN inválido. Consulta as regras de criaçāo no botāo de informação.',
        ));
        return;
      }

      final pinEncrypt = await EncryptDecrypt.encrypted(newAndUpdatePin);
      await prefs.setSavePin(_uid, pinEncrypt);

      emit(state.copyWith(
        pinValidate: true,
        successMessage: 'PIN salvo com sucesso.',
        hasPin: true,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> saveUpdatePin(String currentPin, String newAndUpdatePin) async {
    await _vaultService.initializePreferences();
    final prefs = await _vaultService.prefs();
    try {
      final isValidCurrentAndUpdatePin = pinIsValid(currentPin) && pinIsValid(newAndUpdatePin);
      final checkingCurrentPin = await verifyCurrentPin(currentPin);
      if(!isValidCurrentAndUpdatePin){
        emit(state.copyWith(
          pinValidate: false,
          errorMessage: 'PIN inválido. Consulte as regras para criação do PIN no botão de informação.',
        ));
        return;
      }

      if(!checkingCurrentPin){
        emit(state.copyWith(
          pinValidate: false,
          errorMessage: 'O PIN informado não corresponde ao PIN cadastrado.',
        ));
        return;
      }

      final pinEncrypt = await EncryptDecrypt.encrypted(newAndUpdatePin);
      await prefs.setSavePin(_uid, pinEncrypt);

      emit(state.copyWith(
        pinValidate: true,
        successMessage: 'PIN salvo com sucesso.',
        hasPin: true,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> savePin(String currentPin, String newAndUpdatePin, bool hasPin) async {
    try {
      emit(state.copyWith(isLoading: true,));
      clearMessages();
      if (hasPin) {
        await saveUpdatePin(currentPin, newAndUpdatePin);
      } else {
        await saveNewPin(newAndUpdatePin);
      }
       emit(state.copyWith(
          isLoading: false,
        ));      
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> removePin() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _vaultService.initializePreferences();
      final prefs = await _vaultService.prefs();
      await prefs.removePin(_uid);
      await prefs.setVisibleInfoCreatePin(false);

      await getPinVerification();

      emit(state.copyWith(
        isLoading: false,
        successMessage: 'PIN removido.',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> getPinVerification() async {
    await _vaultService.initializePreferences();
    final prefs = await _vaultService.prefs();
    final encryptPin = prefs.getPin(_uid);
    final decryptPin = await EncryptDecrypt.decrypt(encryptPin);

    final pinInt = int.tryParse(decryptPin) ?? 0;
    emit(state.copyWith(hasPin: pinInt != 0));
  }

  Future<String> pinDecrypt() async {
    await _vaultService.initializePreferences();
    final prefs = await _vaultService.prefs();
    final encryptPin = prefs.getPin(_uid);

    final decrypted = encryptPin != '0'
        ? await EncryptDecrypt.decrypt(encryptPin)
        : encryptPin;

    return decrypted;
  }

  // -------------------------
  // Platform
  // -------------------------
  Future<void> verifyPlatform() async {
    if (Platform.isAndroid) {
      final p = await AndroidPathProvider.downloadsPath;
      emit(state.copyWith(isAndroid: true, path: p));
    } else {
      final directory = await getApplicationDocumentsDirectory();
      emit(state.copyWith(isAndroid: false, path: directory.path));
    }
  }

  // -------------------------
  // Permission
  // -------------------------
  Future<void> requestPermission(Permission permission) async {
    await _vaultService.initializePreferences();
    final prefs = await _vaultService.prefs();
    final status = await permission.request();

    if (status.isGranted) {      
      await prefs.setPermissionStorage(true);
      emit(state.copyWith(successMessage: 'Permissão concedida.'));
    } else {
      await prefs.setPermissionStorage(false);
      emit(state.copyWith(errorMessage: 'Permissão negada.'));
    }
  }

  Future<bool> checkPermission() async {
    await _vaultService.initializePreferences();
    final prefs = await _vaultService.prefs();
    return prefs.getPermissionStorage();
  }

  void togglePasswordVisibility() {
    final newSufixIcon = !state.sufixIcon;
    emit(state.copyWith(
      sufixIcon: newSufixIcon,
      obscureText: newSufixIcon, // seu padrão atual
    ));
  }

  // -------------------------
  // File picker
  // -------------------------
  Future<void> selectFile() async {
    emit(state.copyWith(isLoading: true));
    try {
      final directory = CoreStrings.appName;

      final picked = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        initialDirectory: directory,
        lockParentWindow: true,
      );

      final file = picked?.files.firstOrNull;

      if (file == null) {
        emit(state.copyWith(isLoading: false, selectedFile: false));
        return;
      }

      emit(state.copyWith(
        isLoading: false,
        selectedFile: true,
        selectedFileName: file.name,
      ));
    } on PlatformException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        selectedFile: false,
        errorMessage: e.message ?? e.toString(),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        selectedFile: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // -------------------------
  // Zip encryption
  // -------------------------
  bool isZipFileEncrypted() {
    final fileName = state.selectedFileName;
    final basePath = state.path;

    if (fileName.isEmpty || basePath.isEmpty) {
      emit(state.copyWith(errorMessage: 'Arquivo ou caminho inválido.'));
      return false;
    }

    final zipFile = File('$basePath/$fileName');
    final input = InputFileStream(zipFile.path);

    try {
      final signature = input.readUint32();
      if (signature != ZipFile.zipFileSignature) {
        throw ArchiveException(CoreStrings.invalidSignatureZip);
      }

      input.readUint16(); // version
      final flags = input.readUint16();

      final encryptionType = (flags & 0x1) != 0
          ? ZipFile.encryptionZipCrypto
          : ZipFile.encryptionNone;

      final crypted = encryptionType != ZipFile.encryptionNone;
      emit(state.copyWith(isCrypted: crypted));
      return crypted;
    } finally {
      input.close();
    }
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
