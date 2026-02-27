import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
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
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';

class ConfigController extends Cubit<ConfigState> {
  final GetPinStatusUseCase _getPinStatusUseCase;
  final ReauthenticateAndRemovePinUseCase _reauthAndRemovePinUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final SignOutUseCase _signOutUseCase;
  final SavePinUseCase _savePinUseCase;
  final UpdatePinUseCase _updatePinUseCase;
  final ConfirmAndRemovePinUseCase _confirmAndRemovePinUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final CreateManualBackupUseCase _createManualBackupUseCase;
  final ShareBackupUseCase _shareBackupUseCase;
  final RestoreManualBackupUseCase _restoreManualBackupUseCase;
  final RestoreAutomaticBackupUseCase _restoreAutomaticBackupUseCase;
  final SelectZipFileUseCase _selectZipFileUseCase;
  final SetLockTimeoutUseCase _setLockTimeoutUseCase;
  final GetLockTimeoutUseCase _getLockTimeoutUseCase;

  ConfigController({
    required ItensRepository itensRepository,
    required GetPinStatusUseCase getPinStatusUseCase,
    required ReauthenticateAndRemovePinUseCase reauthAndRemovePinUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required SignOutUseCase signOutUseCase,
    required SavePinUseCase savePinUseCase,
    required UpdatePinUseCase updatePinUseCase,
    required ConfirmAndRemovePinUseCase confirmAndRemovePinUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
    required CreateManualBackupUseCase createManualBackupUseCase,
    required ShareBackupUseCase shareBackupUseCase,
    required RestoreManualBackupUseCase restoreManualBackupUseCase,
    required RestoreAutomaticBackupUseCase restoreAutomaticBackupUseCase,
    required SelectZipFileUseCase selectZipFileUseCase,
    required SetLockTimeoutUseCase setLockTimeoutUseCase,
    required GetLockTimeoutUseCase getLockTimeoutUseCase,
  })  : _getPinStatusUseCase = getPinStatusUseCase,
        _reauthAndRemovePinUseCase = reauthAndRemovePinUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _signOutUseCase = signOutUseCase,
        _savePinUseCase = savePinUseCase,
        _updatePinUseCase = updatePinUseCase,
        _confirmAndRemovePinUseCase = confirmAndRemovePinUseCase,
        _updatePasswordUseCase = updatePasswordUseCase,
        _createManualBackupUseCase = createManualBackupUseCase,
        _shareBackupUseCase = shareBackupUseCase,
        _restoreManualBackupUseCase = restoreManualBackupUseCase,
        _restoreAutomaticBackupUseCase = restoreAutomaticBackupUseCase,
        _selectZipFileUseCase = selectZipFileUseCase,
        _setLockTimeoutUseCase = setLockTimeoutUseCase,
        _getLockTimeoutUseCase = getLockTimeoutUseCase,
        super(const ConfigState()) {
    _initialize();
  }

  void _initialize() async {
    emit(state.copyWith(isAndroid: Platform.isAndroid));
    await getPinVerification();
  }

  Future<void> getPinVerification() async {
    emit(state.copyWith(status: const ConfigLoading()));

    try {
      final hasPin = await _getPinStatusUseCase();
      emit(state.copyWith(
        status: const ConfigInitial(),
        hasPin: hasPin,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ConfigError(CoreStrings.pinVerificationError),
      ));
    }
  }

  void _emitStatus(ConfigStatus status) {
    emit(state.copyWith(status: status));
  }

  void resetPinForm() {
    emit(state.copyWith(
        // isFormValid: false,
        // pinValidate: false,
        ));
  }

  Future<void> reauthenticate({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: ConfigLoading()));

    try {
      await _reauthAndRemovePinUseCase(
        email: email,
        password: password,
      );

      emit(state.copyWith(
        status: ConfigPinResetSuccess(CoreStrings.identityConfirmedAndPinRemoved),
        hasPin: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ConfigError(CoreStrings.identityValidationError),
      ));
    }
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: ConfigLoading()));

    final stopwatch = Stopwatch()..start();
    const minDuration = Duration(milliseconds: 600);

    try {
      await _deleteAccountUseCase();

      await _ensureMinDuration(stopwatch, minDuration);

      emit(state.copyWith(
        status: ConfigSuccess(CoreStrings.accountRemovedSuccess),
      ));
    } catch (_) {
      await _ensureMinDuration(stopwatch, minDuration);

      emit(state.copyWith(
        status: ConfigError(CoreStrings.deleteAccountError),
      ));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: ConfigLoading()));

    try {
      await _signOutUseCase();

      emit(state.copyWith(
        status: ConfigLogoutSuccess(),
      ));
    } on AuthErrorType catch (type) {
      _emitStatus(ConfigError(type.message));
    } on AuthException catch (e) {
      _emitStatus(ConfigError(e.message));
    } catch (e) {
      _emitStatus(ConfigError(AuthErrorType.unknown.message));
    }
  }

  Future<void> saveNewPin(String newPin) async {
    emit(state.copyWith(status: ConfigLoading()));

    try {
      await _savePinUseCase(newPin);

      emit(state.copyWith(
        status: ConfigSuccess(CoreStrings.savePinSuccess),
        hasPin: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ConfigError(e.toString()),
      ));
    }
  }

  Future<void> saveUpdatePin(
    String currentPin,
    String newPin,
  ) async {
    emit(state.copyWith(status: ConfigLoading()));

    try {
      await _updatePinUseCase(
        currentPin: currentPin,
        newPin: newPin,
      );

      emit(state.copyWith(
        status: ConfigSuccess(CoreStrings.updatePinSuccess),
        hasPin: true,
      ));
    } catch (e) {
      if (e.toString().contains("INVALID_CURRENT_PIN")) {
        emit(state.copyWith(
          status: ConfigError(CoreStrings.pinMismatchError),
        ));
      } else {
        _emitStatus(ConfigError(AuthErrorType.unknown.message));
      }
    }
  }

  Future<void> savePin(
    String currentPin,
    String newPin,
    bool hasPin,
  ) async {
    emit(state.copyWith(status: ConfigLoading()));

    try {
      if (hasPin) {
        await _updatePinUseCase(
          currentPin: currentPin,
          newPin: newPin,
        );
      } else {
        await _savePinUseCase(newPin);
      }

      emit(state.copyWith(
        status: ConfigPinCreatedSuccess(CoreStrings.savePinSuccess),
        hasPin: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ConfigError(CoreStrings.savePinError),
      ));
    }
  }

  Future<void> _ensureMinDuration(
    Stopwatch stopwatch,
    Duration minDuration,
  ) async {
    final elapsed = stopwatch.elapsed;
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }
  }

  Future<void> confirmAndRemovePin(String typedPin) async {
    emit(state.copyWith(status: ConfigLoading()));

    try {
      await _confirmAndRemovePinUseCase(typedPin);

      emit(state.copyWith(
        status: ConfigPinRemoveSuccess(CoreStrings.removePinSuccess),
        hasPin: false,
      ));
    } catch (e) {
      if (e.toString().contains("INVALID_PIN")) {
        _emitStatus(ConfigError(CoreStrings.pinMismatchError));
      } else {
        _emitStatus(ConfigError(CoreStrings.removePinError));
      }
    }
  }

  void resetSelectedFolder() {
    emit(state.copyWith(
        // selectedFolder: false,
        // selectedFolderPath: '',
        // folderName: '',
        ));
  }

  Future<String?> selectZipFile() async {
    try {
      return await _selectZipFileUseCase();
    } catch (_) {
      emit(state.copyWith(
        status: ConfigError(CoreStrings.selectFileError),
      ));
      return null;
    }
  }

  Future<void> createManualBackup() async {
    emit(state.copyWith(status: const ConfigLoading()));

    try {
      await _createManualBackupUseCase();

      emit(state.copyWith(
        status: const ConfigBackupSaved(CoreStrings.backupCreatedSuccess),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ConfigError(CoreStrings.createManualBackupError),
      ));
    }
  }

  Future<void> shareExportBackup() async {
    emit(state.copyWith(
      status: const ConfigLoading(),
    ));

    try {
      await _shareBackupUseCase();

      emit(state.copyWith(
        status: ConfigBackupShared(CoreStrings.backupSharedSuccess),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ConfigError(CoreStrings.shareBackupError),
      ));
    }
  }

  Future<void> restoreManualBackup(String path) async {
    if (path.isNullOrBlank) {
      emit(state.copyWith(
        status: ConfigError(CoreStrings.noFileSelected),
      ));
      return;
    }

    emit(state.copyWith(status: const ConfigLoading()));

    try {
      await _restoreManualBackupUseCase(path);

      emit(state.copyWith(
        status: ConfigRestoreBackupManualSuccess(CoreStrings.backupRestoredSuccess),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ConfigError(CoreStrings.restoreFileInvalidError),
      ));
    }
  }

  Future<void> restoreAutomaticBackup() async {
    emit(state.copyWith(
      status: const ConfigLoading(),
    ));

    try {
      await _restoreAutomaticBackupUseCase();

      emit(state.copyWith(
        status: ConfigRestoreBackupAutomaticSuccess(CoreStrings.restoreAutomaticBackupSuccess),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ConfigError(CoreStrings.restoreAutomaticBackupError),
      ));
    }
  }

  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    emit(state.copyWith(
      status: const ConfigLoading(),
    ));

    try {
      await _updatePasswordUseCase(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      emit(state.copyWith(
        status: ConfigResetPasswordSuccess(CoreStrings.changePasswordSuccess),
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: ConfigError(e.message),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ConfigError(
          CoreStrings.changePasswordError,
        ),
      ));
    }
  }

  void clearStatus() => emit(state.copyWith(status: const ConfigInitial()));

  Future<void> setLockTimeout(int value) async {
    _emitStatus(const ConfigLoading());
    try {
      final setTime = await _setLockTimeoutUseCase(value);
      if (!setTime) {
        _emitStatus(ConfigError(CoreStrings.saveLockTimerImpossible));
        return;
      }
      _emitStatus(ConfigSuccess(CoreStrings.saveLockTimerSuccess));
    } catch (_) {
      _emitStatus(ConfigError(CoreStrings.saveLockTimerError));
    }
  }

  int getLockTimeout() {
    return _getLockTimeoutUseCase();
  }
}
