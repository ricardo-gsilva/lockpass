import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesDatasource', () {
    late SharedPreferences prefs;
    late SharedPreferencesDatasource datasource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      datasource = SharedPreferencesDatasource(sharedPreferences: prefs);
    });

    test('set/get permissionStorage', () async {
      expect(datasource.getPermissionStorage(), isFalse);
      await datasource.setPermissionStorage(true);
      expect(datasource.getPermissionStorage(), isTrue);
    });

    test('set/get hideCreatePinAlert and clearUserData', () async {
      expect(datasource.getHideCreatePinAlert(), isFalse);
      await datasource.setHideCreatePinAlert(true);
      expect(datasource.getHideCreatePinAlert(), isTrue);

      await datasource.clearUserData();
      expect(datasource.getHideCreatePinAlert(), isFalse);
    });

    test('set/get lock timeout uses default 60', () async {
      expect(datasource.getLockTimeout(), 60);
      await datasource.setLockTimeout(120);
      expect(datasource.getLockTimeout(), 120);
    });
  });
}

