import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/vault/vault_service_impl.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VaultServiceImpl', () {
    test('clearUserPreferences clears user-related keys in prefs datasource', () async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesDatasource.hideCreatePinAlertKey: true,
      });
      final prefs = await SharedPreferences.getInstance();
      final datasource = SharedPreferencesDatasource(sharedPreferences: prefs);

      final service = VaultServiceImpl(
        sharedPrefs: datasource,
        dbHelper: DataBaseHelper(),
      );

      await service.clearUserPreferences();

      expect(datasource.getHideCreatePinAlert(), isFalse);
    });

    test('hasStoragePermission returns true on non-Android platforms', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final datasource = SharedPreferencesDatasource(sharedPreferences: prefs);

      final service = VaultServiceImpl(
        sharedPrefs: datasource,
        dbHelper: DataBaseHelper(),
      );

      final granted = await service.hasStoragePermission();
      expect(granted, isTrue);
    });
  });
}

