import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/session/domain/usecases/get_lock_timeout__session_usercase.dart';
import 'package:lockpass/core/session/domain/usecases/get_pin_status_session_usecase.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_credentials_usecase.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_pin_usecase.dart';
import 'package:lockpass/core/session/presentation/controller/lock_screen_controller.dart';

void registerSessionModule() {
  // UseCases
  getIt.registerLazySingleton<UnlockWithCredentialsUseCase>(
    () => UnlockWithCredentialsUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<UnlockWithPinUseCase>(
    () => UnlockWithPinUseCase(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton<GetLockTimeoutSessionUseCase>(
    () => GetLockTimeoutSessionUseCase(getIt()),
  );

    getIt.registerLazySingleton<GetPinStatusSessionUseCase>(
    () => GetPinStatusSessionUseCase(getIt(), getIt()),
  );

  // Controller
  getIt.registerFactory<LockScreenController>(
    () => LockScreenController(
      unlockWithPinUseCase: getIt(),
      unlockWithCredentialUseCase: getIt(),
      getLockTimeoutSessionUseCase: getIt(),
      getPinStatusSessionUseCase: getIt(),
    ),
  );
}