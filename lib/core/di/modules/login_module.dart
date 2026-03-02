import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/features/login/domain/usecases/check_pin_availability_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_email_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_pin_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/register_user_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/reset_password_usecase.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';

void registerLoginModule() {
  getIt.registerLazySingleton<CheckPinAvailabilityUseCase>(
    () => CheckPinAvailabilityUseCase(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<LoginWithEmailUseCase>(
    () => LoginWithEmailUseCase(
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<LoginWithPinUseCase>(
    () => LoginWithPinUseCase(
      getIt(),
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(
      getIt(),
    ),
  );

  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(
      getIt(),
    ),
  );

  getIt.registerFactory<LoginController>(
    () => LoginController(
      checkPinAvailabilityUseCase: getIt(),
      loginWithEmailUseCase: getIt(),
      loginWithPinUseCase: getIt(),
      registerUserUseCase: getIt(),
      resetPasswordUseCase: getIt(),
    ),
  );
}