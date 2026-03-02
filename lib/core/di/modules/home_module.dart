import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/features/home/domain/usecases/check_if_should_show_pin_alert_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/create_automatic_backup_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/get_current_user_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/set_hide_create_pin_usecase.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';

void registerHomeModule() {
  // UseCases

  getIt.registerLazySingleton<CheckIfShouldShowPinAlertUseCase>(
    () => CheckIfShouldShowPinAlertUseCase(
      getIt(), // PinService
      getIt(), // SharedPreferencesDatasource
    ),
  );

  getIt.registerLazySingleton<CreateAutomaticBackupUseCase>(
    () => CreateAutomaticBackupUseCase(
      getIt(), // ItensRepository
      getIt(), // VaultService
    ),
  );

  getIt.registerLazySingleton<SetHideCreatePinAlertUseCase>(
    () => SetHideCreatePinAlertUseCase(
      getIt(), // SharedPreferencesDatasource
    ),
  );

  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(
      getIt(), // AuthService
    ),
  );

  // Controller

  getIt.registerFactory<HomeController>(
    () => HomeController(
      checkIfShouldShowPinAlertUseCase: getIt(),
      createAutomaticBackupUseCase: getIt(),
      setHideCreatePinAlertUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
    ),
  );
}