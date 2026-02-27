import 'dart:io';

import 'package:lockpass/core/security/vault/vault_service.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:permission_handler/permission_handler.dart';

class VaultServiceImpl implements VaultService {
  final SharedPreferencesDatasource _sharedPrefs;

  VaultServiceImpl({
    required SharedPreferencesDatasource sharedPrefs,
    required DataBaseHelper dbHelper,
  })  : _sharedPrefs = sharedPrefs;

  @override
  Future<void> clearUserPreferences() async {
    await _sharedPrefs.clearUserData();
  }

  @override
  Future<SharedPreferencesDatasource> prefs() async {
    return _sharedPrefs;
  }

  @override
  Future<bool> hasStoragePermission() async {
    if (!Platform.isAndroid) return true;
    final granted = await Permission.storage.isGranted;
    await _sharedPrefs.setPermissionStorage(granted);
    return granted;
  }

  @override
  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      _sharedPrefs.setPermissionStorage(status.isGranted);
    }
  }
}
