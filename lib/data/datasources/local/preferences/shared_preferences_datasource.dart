import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDatasource {
  SharedPreferencesDatasource({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String permissionStorageKey = 'permissionStorage';
  // static const String visibleInfoCreatePinKey = 'visibleInfoCreatePin';
  static const String hideCreatePinAlertKey = 'hideCreatePinAlertKey';

  Future<bool> setPermissionStorage(bool value) async {
    return sharedPreferences.setBool(permissionStorageKey, value);
  }

  bool getPermissionStorage() {
    return sharedPreferences.getBool(permissionStorageKey) ?? false;
  }

  Future<bool> setHideCreatePinAlert(bool value){
    return sharedPreferences.setBool(hideCreatePinAlertKey, value);
  }
  // Future<bool> setVisibleCreatePinInfo(bool value) async {
  //   return sharedPreferences.setBool(hideCreatePinAlertKey, value);
  // }

  bool getHideCreatePinAlert(){
    return sharedPreferences.getBool(hideCreatePinAlertKey) ?? false;
  }
  // bool getVisibleCreatePinInfo() {
  //   return sharedPreferences.getBool(hideCreatePinAlertKey) ?? false;
  // }

  Future<void> clearUserData() async {
    await sharedPreferences.remove(hideCreatePinAlertKey);
  }
}