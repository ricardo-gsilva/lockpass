import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDatasource {
  SharedPreferencesDatasource({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String permissionStorageKey = 'permissionStorage';
  static const String visibleInfoCreatePinKey = 'visibleInfoCreatePin';

  Future<bool> setPermissionStorage(bool value) async {
    return sharedPreferences.setBool(permissionStorageKey, value);
  }

  bool getPermissionStorage() {
    return sharedPreferences.getBool(permissionStorageKey) ?? false;
  }

  Future<bool> setVisibleCreatePinInfo(bool value) async {
    return sharedPreferences.setBool(visibleInfoCreatePinKey, value);
  }

  bool getVisibleCreatePinInfo() {
    return sharedPreferences.getBool(visibleInfoCreatePinKey) ?? false;
  }

  Future<void> clearUserData() async {
    await sharedPreferences.remove(visibleInfoCreatePinKey);
  }
}