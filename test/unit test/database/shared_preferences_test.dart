import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/database/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel('plugins.flutter.io/shared_preferences').
    setMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{}; // set initial values here if desired
    }
    return null;
  });

  group('Testing set and get PIN with SharedPreferences', () { 
    test('Testing empty PIN with SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

      final SharedPrefs sharedPrefs =
              SharedPrefs(sharedPreferences: sharedPreferences);

      const expectedPin = '';
      final actualPin = sharedPrefs.getPin();

      expect(expectedPin, actualPin);

      
    });

    test('Testing an existing PIN with SharedPreferences', () async {
      String pin = '12345';
      SharedPreferences.setMockInitialValues({
        SharedPrefs.pinKey: pin });
      
      final SharedPreferences sharedPreferences1 =
              await SharedPreferences.getInstance();

      final SharedPrefs sharedPrefs1 =
              SharedPrefs(sharedPreferences: sharedPreferences1);

      const expectedPin1 = '12345';
      final actualPin1 = sharedPrefs1.getPin();

      expect(expectedPin1, actualPin1);
    });

    test('remove Pin', () async {
      String pin = '12345';
      SharedPreferences.setMockInitialValues({
        SharedPrefs.pinKey: pin });
      
      final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

      final SharedPrefs sharedPrefs =
              SharedPrefs(sharedPreferences: sharedPreferences);

      sharedPrefs.removePin();
      const expectedPin = '';
      final actualPin = sharedPrefs.getPin();

      expect(expectedPin, actualPin);
    });
  });

  group('Testing storage access permission with SharedPreferences', () { 
    test('Testing access permission with false return in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

      final SharedPrefs sharedPrefs =
              SharedPrefs(sharedPreferences: sharedPreferences);

      const expectedPermissionStorage = false;
      final actualPermissionStorage = sharedPrefs.getPermissionStorage();

      expect(expectedPermissionStorage, actualPermissionStorage);      
    });

    test('Testing access permission with true return in SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        SharedPrefs.permissionStorageKey: true});

      final SharedPreferences sharedPreferences1 =
              await SharedPreferences.getInstance();

      final SharedPrefs sharedPrefs1 =
              SharedPrefs(sharedPreferences: sharedPreferences1);

      const expectedPermissionStorage1 = true;
      final actualPermissionStorage1 = sharedPrefs1.getPermissionStorage();

      expect(expectedPermissionStorage1, actualPermissionStorage1);
    });
  });

  group('Testing whether PIN creation exists with SharedPreferences', (){ 
    test('Testing creating a PIN with SharedPreferences returning false.', () async {
      SharedPreferences.setMockInitialValues({});

      final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

      final SharedPrefs sharedPrefs =
              SharedPrefs(sharedPreferences: sharedPreferences);

      const expectedVisibleCreatePin = false;
      final actualVisibleCreatePin = sharedPrefs.getVisibleInfoCreatePin();

      expect(expectedVisibleCreatePin, actualVisibleCreatePin);      
    });

    test('Testing the creation of a PIN with SharedPreferences returning true.', () async {
      SharedPreferences.setMockInitialValues({
        SharedPrefs.visibleInfoCreatePinKey: true});

      final SharedPreferences sharedPreferences1 =
              await SharedPreferences.getInstance();

      final SharedPrefs sharedPrefs1 =
              SharedPrefs(sharedPreferences: sharedPreferences1);

      const expectedVisibleCreatePin1 = true;
      final actualVisibleCreatePin1 = sharedPrefs1.getVisibleInfoCreatePin();

      expect(expectedVisibleCreatePin1, actualVisibleCreatePin1);
    });
  });

  
}