import 'package:lockpass/database/shared_preferences.dart';

abstract class VaultService {
  Future<String> getStoragePath();
  Future<bool> hasStoragePermission();
  Future<void> requestStoragePermission();
  Future<bool> hasPin();
  Future<String> getDecryptedPin();
  Future<void> createVault(String pin);
  Future<bool> verifyPin(String pin);
  Future<void> initializePreferences();
  Future<void> initializeVaultEnvironment();
  Future<bool> shouldShowCreatePinInfo();
  Future<bool> getHideCreatePinInfo();
  Future<void> setHideCreatePinInfo(bool value);
  Future<SharedPrefs> prefs();
  String get userId;

}

/*
Da LoginStore, o que é “Vault” de verdade:
sharedPrefs() → vira init()
getPlatform() → vira getStoragePath()
getPermissionStorage() + requestPermission() → 
vira hasStoragePermission() e requestStoragePermission()
pinIsValid() → vira hasPin()
pinDecrypt() → vira getDecryptedPin()
checkPin(pin) → vira verifyPin(pin)
EncryptDecrypt().isolateCreateZip(path, pin, ...) → vira createVault(pin)
*/