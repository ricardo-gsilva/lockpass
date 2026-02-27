import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/core/security/backup/backup_service_impl.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/dek/secure_storage/secure_storage_dek_store.dart';
import 'package:lockpass/core/security/crypto/dek/secure_storage/secure_storage_dek_store_impl.dart';
import 'package:lockpass/core/security/vault/vault_service.dart';
import 'package:lockpass/core/security/vault/vault_service_impl.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
import 'package:lockpass/core/services/file_picker/file_picker_service.dart';
import 'package:lockpass/core/services/file_picker/file_picker_service_impl.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/core/services/pin/pin_service_impl.dart';
import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:lockpass/data/repositories/itens_repository_impl.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> registerCoreModule() async {
  final prefs = await SharedPreferences.getInstance();

  // External
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Database
  getIt.registerLazySingleton<DataBaseHelper>(
    () => DataBaseHelper(),
  );

  // Datasource
  getIt.registerLazySingleton<SharedPreferencesDatasource>(
    () => SharedPreferencesDatasource(
      sharedPreferences: getIt(),
    ),
  );

  // Services
  getIt.registerLazySingleton<SessionLockService>(
    () => SessionLockService(),
  );

  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(),
  );

  getIt.registerLazySingleton<PinService>(
    () => PinServiceImpl(),
  );

  getIt.registerLazySingleton<VaultService>(
    () => VaultServiceImpl(
      sharedPrefs: getIt(),
      dbHelper: getIt(),
    ),
  );

  getIt.registerLazySingleton<BackupService>(
    () => BackupServiceImpl(
      dbHelper: getIt(),
    ),
  );

  getIt.registerLazySingleton<FilePickerService>(
    () => FilePickerServiceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<ItensRepository>(
    () => ItensRepositoryImpl(
      dbHelper: getIt(),
    ),
  );

  // Crypto / DEK
  getIt.registerLazySingleton<SecureStorageDekStore>(
    () => SecureStorageDekStoreImpl(),
  );

  getIt.registerLazySingleton<DekManager>(
    () => DekManager(getIt<SecureStorageDekStore>()),
  );
}
