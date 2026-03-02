import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/features/config/domain/usecases/confirm_and_remove_pin_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/create_manual_backup_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/delete_account_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/get_lock_timeout_usercase.dart';
import 'package:lockpass/features/config/domain/usecases/get_pin_status_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/reauthenticate_and_remove_pin_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/restore_automatic_backup_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/restore_manual_backup_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/save_pin_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/select_zip_file_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/set_lock_timeout_usercase.dart';
import 'package:lockpass/features/config/domain/usecases/share_backup_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/sign_out_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/update_password_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/update_pin_usecase.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';

void registerConfigModule() {

  // ===== UseCases =====

  getIt.registerLazySingleton<GetPinStatusUseCase>(
    () => GetPinStatusUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<ReauthenticateAndRemovePinUseCase>(
    () => ReauthenticateAndRemovePinUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<SavePinUseCase>(
    () => SavePinUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<UpdatePinUseCase>(
    () => UpdatePinUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<ConfirmAndRemovePinUseCase>(
    () => ConfirmAndRemovePinUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<UpdatePasswordUseCase>(
    () => UpdatePasswordUseCase(getIt()),
  );

  getIt.registerLazySingleton<CreateManualBackupUseCase>(
    () => CreateManualBackupUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<ShareBackupUseCase>(
    () => ShareBackupUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<RestoreManualBackupUseCase>(
    () => RestoreManualBackupUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<RestoreAutomaticBackupUseCase>(
    () => RestoreAutomaticBackupUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<SelectZipFileUseCase>(
    () => SelectZipFileUseCase(getIt()),
  );

  getIt.registerLazySingleton<SetLockTimeoutUseCase>(
    () => SetLockTimeoutUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetLockTimeoutUseCase>(
    () => GetLockTimeoutUseCase(getIt()),
  );

  // ===== Controller =====

  getIt.registerFactory<ConfigController>(
    () => ConfigController(
      itensRepository: getIt(),
      getPinStatusUseCase: getIt(),
      reauthAndRemovePinUseCase: getIt(),
      deleteAccountUseCase: getIt(),
      signOutUseCase: getIt(),
      savePinUseCase: getIt(),
      updatePinUseCase: getIt(),
      confirmAndRemovePinUseCase: getIt(),
      updatePasswordUseCase: getIt(),
      createManualBackupUseCase: getIt(),
      shareBackupUseCase: getIt(),
      restoreManualBackupUseCase: getIt(),
      restoreAutomaticBackupUseCase: getIt(),
      selectZipFileUseCase: getIt(),
      setLockTimeoutUseCase: getIt(),
      getLockTimeoutUseCase: getIt(),
    ),
  );
}