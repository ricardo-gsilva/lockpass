import 'package:lockpass/data/datasources/local/shared_preferences_datasource.dart';

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
  Future<bool> getHideCreatePinInfo();
  Future<void> setHideCreatePinInfo(bool value);
  Future<SharedPreferencesDatasource> prefs();
}