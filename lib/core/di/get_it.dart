import 'package:get_it/get_it.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/core/vault/vault_service_impl.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/features/addItem/presentation/controller/add_item_controller.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/services/auth_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<VaultService>(() => 
  VaultServiceImpl(getIt<AuthService>()));
  getIt.registerLazySingleton<DataBaseHelper>(() => DataBaseHelper());


  // Controllers (factory = nova instância por página/uso)
  getIt.registerFactory<LoginController>(() => LoginController(
        authService: getIt<AuthService>(),
        vaultService: getIt<VaultService>(),
      ));
  getIt.registerFactory<HomeController>(() => HomeController(
        db: getIt<DataBaseHelper>(),
        vaultService: getIt<VaultService>(),
      ));
  getIt.registerFactory<AddItemController>(() => AddItemController(
        db: getIt<DataBaseHelper>(),
      ));
  getIt.registerFactory<ConfigController>(() => ConfigController(
        vaultService: getIt<VaultService>(),
        authService: getIt<AuthService>(),
      ));
}
