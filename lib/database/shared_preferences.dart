import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String pinKey = 'pin';
  static const String permissionStorageKey = 'permissionStorage';
  static const String visibleInfoCreatePinKey = 'visibleInfoCreatePin';
  
  Future<bool> setSavePin(String pin) async {
    return sharedPreferences.setString(pinKey, pin);
  }

  String getPin() {
    return sharedPreferences.getString(pinKey)?? '';
  }

  Future<bool> setPermissionStorage(bool permissionStorage) async {
    return sharedPreferences.setBool(permissionStorageKey, permissionStorage);
  }

  bool getPermissionStorage() {
    return sharedPreferences.getBool(permissionStorageKey)?? false;
  }

  Future<bool> setVisibleInfoCreatePin(bool visibleInfoCreatePin) async {
    return sharedPreferences.setBool(visibleInfoCreatePinKey, visibleInfoCreatePin);
  }

  bool getVisibleInfoCreatePin() {
    return sharedPreferences.getBool(visibleInfoCreatePinKey)?? false;
  }

  removePin() async {
    sharedPreferences.remove(pinKey);
  }
}