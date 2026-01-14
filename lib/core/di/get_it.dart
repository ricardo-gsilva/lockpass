import 'package:get_it/get_it.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/core/vault/vault_service_impl.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/services/auth_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<VaultService>(() => VaultServiceImpl());

  // Controllers (factory = nova instância por página/uso)
  getIt.registerFactory<LoginController>(() => LoginController(
        authService: getIt<AuthService>(),
        vaultService: getIt<VaultService>(),
      ));
}
