import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';

abstract class VaultService {
  Future<bool> hasStoragePermission();
  Future<void> requestStoragePermission();
  Future<SharedPreferencesDatasource> prefs();
  Future<void> clearUserPreferences();
}