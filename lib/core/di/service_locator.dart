import 'package:get_it/get_it.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/core/vault/vault_service_impl.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/addItem/presentation/controller/add_item_controller.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/listItem/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/splash/presentation/controller/splash_controller.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:lockpass/services/pin_service.dart';
import 'package:lockpass/data/repositories/itens_repository_impl.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<VaultService>(() => VaultServiceImpl());
  getIt.registerLazySingleton<DataBaseHelper>(() => DataBaseHelper());
  getIt.registerLazySingleton<PinService>(() => PinService());
  getIt.registerLazySingleton<ItensRepository>(() => ItensRepositoryImpl(
    getIt<DataBaseHelper>(),
  ),
);



  // Controllers (factory = nova instância por página/uso)
  getIt.registerFactory<SplashController>(() => SplashController(
        authService: getIt<AuthService>(),
        pinService: getIt<PinService>(),
      ));
  getIt.registerFactory<LoginController>(() => LoginController(
        authService: getIt<AuthService>(),
        vaultService: getIt<VaultService>(),
        pinService: getIt<PinService>(),
      ));
  getIt.registerFactory<HomeController>(() => HomeController(
        itensRepository: getIt<ItensRepository>(),
        db: getIt<DataBaseHelper>(),
        vaultService: getIt<VaultService>(),
        authService: getIt<AuthService>(),
      ));
  getIt.registerFactory<AddItemController>(() => AddItemController(
        itensRepository: getIt<ItensRepository>(),
        authService: getIt<AuthService>(),
      ));
  getIt.registerFactory<ConfigController>(() => ConfigController(
        vaultService: getIt<VaultService>(),
        authService: getIt<AuthService>(),
        db: getIt<DataBaseHelper>(),
        pinService: getIt<PinService>(),
      ));
  getIt.registerFactory<ListItemController>(() => ListItemController(
        authService: getIt<AuthService>(),
        db: getIt<DataBaseHelper>(),
        itensRepository: getIt<ItensRepository>(),
  ));
}
