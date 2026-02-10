// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefs {
//   SharedPrefs({required this.sharedPreferences});

//   final SharedPreferences sharedPreferences;

//   static const String permissionStorageKey = 'permissionStorage';
//   static const String visibleInfoCreatePinKey = 'visibleInfoCreatePin';
//   String _pinKey(String userId) => 'pin_$userId';

//   Future<bool> setSavePin(String userId, String pin) async {
//     return sharedPreferences.setString(_pinKey(userId), pin);
//   }

//   String getPin(String userId) {
//     return sharedPreferences.getString(_pinKey(userId)) ?? '';
//   }

//   Future<void> removePin(String userId) async {
//     sharedPreferences.remove(_pinKey(userId));
//   }

//   Future<bool> setPermissionStorage(bool permissionStorage) async {
//     return sharedPreferences.setBool(permissionStorageKey, permissionStorage);
//   }

//   bool getPermissionStorage() {
//     return sharedPreferences.getBool(permissionStorageKey) ?? false;
//   }

//   ///remover
//   Future<bool> setVisibleInfoCreatePin(bool visibleInfoCreatePin) async {
//     return sharedPreferences.setBool(
//         visibleInfoCreatePinKey, visibleInfoCreatePin);
//   }

//   Future<bool> setHideCreatePinInfo(bool hideCreatePinInfo) async {
//     return sharedPreferences.setBool(
//         visibleInfoCreatePinKey, hideCreatePinInfo);
//   }

//   ///remover
//   bool getVisibleInfoCreatePin() {
//     return sharedPreferences.getBool(visibleInfoCreatePinKey) ?? false;
//   }

//   bool getHideCreatePinInfo() {
//     return sharedPreferences.getBool(visibleInfoCreatePinKey) ?? false;
//   }

//   Future<void> clearUserData(String userId) async {
//     await removePin(userId);
//     await sharedPreferences.remove(visibleInfoCreatePinKey);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs({required this.sharedPreferences});

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