import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDatasource {
  SharedPreferencesDatasource({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String permissionStorageKey = 'permissionStorage';
  static const String hideCreatePinAlertKey = 'hideCreatePinAlertKey';
  static const String lockTimeoutSeconds = 'lockTimeoutSeconds';

  Future<bool> setPermissionStorage(bool value) async {
    return sharedPreferences.setBool(permissionStorageKey, value);
  }

  bool getPermissionStorage() {
    return sharedPreferences.getBool(permissionStorageKey) ?? false;
  }

  Future<bool> setHideCreatePinAlert(bool value) {
    return sharedPreferences.setBool(hideCreatePinAlertKey, value);
  }

  bool getHideCreatePinAlert() {
    return sharedPreferences.getBool(hideCreatePinAlertKey) ?? false;
  }

  Future<void> clearUserData() async {
    await sharedPreferences.remove(hideCreatePinAlertKey);
  }

  Future<bool> setLockTimeout(int value) async {
    return sharedPreferences.setInt(lockTimeoutSeconds, value);
  }
  
  int getLockTimeout() {
    return sharedPreferences.getInt(lockTimeoutSeconds) ?? 60;
  }
}
