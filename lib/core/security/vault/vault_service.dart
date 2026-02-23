import 'dart:io';

import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';

abstract class VaultService {
  Future<bool> hasStoragePermission();
  Future<void> requestStoragePermission();
  Future<void> initializeVaultEnvironment();
  Future<bool> getHideCreatePinInfo();
  Future<void> setHideCreatePinInfo(bool value);
  Future<SharedPreferencesDatasource> prefs();
  Future<void> createAutomaticBackup();
  Future<void> importAutomaticBackup();
  Future<void> importManualBackup(String zipPath);
  Future<File> generateBackupZip();
  Future<void> clearUserPreferences();
  Future<void> resetCreatePinInfo();
  Future<void> shareManualBackup();
}