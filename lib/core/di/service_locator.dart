import 'package:get_it/get_it.dart';
import 'package:lockpass/core/security/vault/vault_service.dart';
import 'package:lockpass/core/security/vault/vault_service_impl.dart';
import 'package:lockpass/core/session/presentation/controller/lock_screen_controller.dart';
import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/add_item/presentation/controller/add_item_controller.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/splash/presentation/controller/splash_controller.dart';
import 'package:lockpass/core/services/auth_service.dart';
import 'package:lockpass/core/services/pin_service.dart';
import 'package:lockpass/data/repositories/itens_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Services
  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerLazySingleton<SharedPreferencesDatasource>(
    () => SharedPreferencesDatasource(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<VaultService>(() => VaultServiceImpl(
        sharedPrefs: getIt<SharedPreferencesDatasource>(),
        dbHelper: getIt<DataBaseHelper>(),
      ));
  getIt.registerLazySingleton<DataBaseHelper>(() => DataBaseHelper());
  getIt.registerLazySingleton<PinService>(() => PinService());
  getIt.registerLazySingleton<ItensRepository>(
    () => ItensRepositoryImpl(
      getIt<DataBaseHelper>(),
    ),
  );
  getIt.registerLazySingleton<SessionLockService>(() => SessionLockService());

  // Controllers (factory = nova instância por página/uso)
  getIt.registerFactory<SplashController>(() => SplashController());
  getIt.registerFactory<LoginController>(() => LoginController(
        authService: getIt<AuthService>(),
        vaultService: getIt<VaultService>(),
        pinService: getIt<PinService>(),
        sessionLockService: getIt<SessionLockService>(),
      ));
  getIt.registerFactory<HomeController>(() => HomeController(
        itensRepository: getIt<ItensRepository>(),
        vaultService: getIt<VaultService>(),
        authService: getIt<AuthService>(),
        pinService: getIt<PinService>(),
      ));
  getIt.registerFactory<AddItemController>(() => AddItemController(
        itensRepository: getIt<ItensRepository>(),
        authService: getIt<AuthService>(),
      ));
  getIt.registerFactory<ConfigController>(() => ConfigController(
        vaultService: getIt<VaultService>(),
        authService: getIt<AuthService>(),
        pinService: getIt<PinService>(),
        itensRepository: getIt<ItensRepository>(),
      ));
  getIt.registerFactory<ListItemController>(() => ListItemController(
        authService: getIt<AuthService>(),
        itensRepository: getIt<ItensRepository>(),
        pinService: getIt<PinService>(),
      ));
  getIt.registerFactory(
    () => LockScreenController(
      pinService: getIt<PinService>(),
      sessionLock: getIt<SessionLockService>(),
      authService: getIt<AuthService>(),
    ),
  );
}
