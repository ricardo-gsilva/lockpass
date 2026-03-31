import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockItensRepository extends Mock implements ItensRepository {}

class _MockGetPinStatusUseCase extends Mock implements GetPinStatusUseCase {}

class _MockReauthenticateAndRemovePinUseCase extends Mock
    implements ReauthenticateAndRemovePinUseCase {}

class _MockDeleteAccountUseCase extends Mock implements DeleteAccountUseCase {}

class _MockSignOutUseCase extends Mock implements SignOutUseCase {}

class _MockSavePinUseCase extends Mock implements SavePinUseCase {}

class _MockUpdatePinUseCase extends Mock implements UpdatePinUseCase {}

class _MockConfirmAndRemovePinUseCase extends Mock
    implements ConfirmAndRemovePinUseCase {}

class _MockUpdatePasswordUseCase extends Mock implements UpdatePasswordUseCase {}

class _MockCreateManualBackupUseCase extends Mock
    implements CreateManualBackupUseCase {}

class _MockShareBackupUseCase extends Mock implements ShareBackupUseCase {}

class _MockRestoreManualBackupUseCase extends Mock
    implements RestoreManualBackupUseCase {}

class _MockRestoreAutomaticBackupUseCase extends Mock
    implements RestoreAutomaticBackupUseCase {}

class _MockSelectZipFileUseCase extends Mock implements SelectZipFileUseCase {}

class _MockSetLockTimeoutUseCase extends Mock implements SetLockTimeoutUseCase {}

class _MockGetLockTimeoutUseCase extends Mock implements GetLockTimeoutUseCase {}

class TestConfigController extends ConfigController {
  TestConfigController({
    ConfigState seed = const ConfigState(),
    bool isAndroidOverride = true,
    this.lockTimeoutValue = 0,
  }) : super(
          itensRepository: _MockItensRepository(),
          getPinStatusUseCase: _MockGetPinStatusUseCase(),
          reauthAndRemovePinUseCase: _MockReauthenticateAndRemovePinUseCase(),
          deleteAccountUseCase: _MockDeleteAccountUseCase(),
          signOutUseCase: _MockSignOutUseCase(),
          savePinUseCase: _MockSavePinUseCase(),
          updatePinUseCase: _MockUpdatePinUseCase(),
          confirmAndRemovePinUseCase: _MockConfirmAndRemovePinUseCase(),
          updatePasswordUseCase: _MockUpdatePasswordUseCase(),
          createManualBackupUseCase: _MockCreateManualBackupUseCase(),
          shareBackupUseCase: _MockShareBackupUseCase(),
          restoreManualBackupUseCase: _MockRestoreManualBackupUseCase(),
          restoreAutomaticBackupUseCase: _MockRestoreAutomaticBackupUseCase(),
          selectZipFileUseCase: _MockSelectZipFileUseCase(),
          setLockTimeoutUseCase: _MockSetLockTimeoutUseCase(),
          getLockTimeoutUseCase: _MockGetLockTimeoutUseCase(),
          isAndroidOverride: isAndroidOverride,
        ) {
    emit(seed);
  }

  int signOutCalls = 0;
  int deleteAccountCalls = 0;
  int clearStatusCalls = 0;
  int setLockTimeoutCalls = 0;
  int createManualBackupCalls = 0;
  int shareBackupCalls = 0;
  int selectZipFileCalls = 0;
  int restoreManualBackupCalls = 0;
  int restoreAutomaticBackupCalls = 0;

  ({String currentPin, String newPin, bool hasPin})? lastSavePinArgs;
  String? lastConfirmAndRemovePinArg;
  ({String currentPassword, String newPassword})? lastUpdatePasswordArgs;
  int? lastSetLockTimeoutArg;
  String? lastRestoreManualBackupPath;

  int lockTimeoutValue;
  String? selectZipFileReturnPath;

  @override
  Future<void> getPinVerification() async {
    // no-op for widget tests: avoid background state changes.
  }

  @override
  void clearStatus() {
    clearStatusCalls += 1;
    super.clearStatus();
  }

  @override
  Future<void> signOut() async {
    signOutCalls += 1;
    emit(state.copyWith(status: const ConfigLogoutSuccess()));
  }

  @override
  Future<void> deleteAccount() async {
    deleteAccountCalls += 1;
    emit(state.copyWith(status: const ConfigDeleteAccountSuccess()));
  }

  @override
  Future<void> savePin(String currentPin, String newPin, bool hasPin) async {
    lastSavePinArgs = (currentPin: currentPin, newPin: newPin, hasPin: hasPin);
    emit(state.copyWith(status: const ConfigPinCreatedSuccess('ok'), hasPin: true));
  }

  @override
  Future<void> confirmAndRemovePin(String typedPin) async {
    lastConfirmAndRemovePinArg = typedPin;
    emit(state.copyWith(status: const ConfigPinRemoveSuccess('ok'), hasPin: false));
  }

  @override
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    lastUpdatePasswordArgs = (currentPassword: currentPassword, newPassword: newPassword);
    emit(state.copyWith(status: const ConfigResetPasswordSuccess('ok')));
  }

  @override
  Future<void> setLockTimeout(int value) async {
    setLockTimeoutCalls += 1;
    lastSetLockTimeoutArg = value;
    emit(state.copyWith(status: const ConfigSuccess('ok')));
  }

  @override
  int getLockTimeout() => lockTimeoutValue;

  @override
  Future<void> createManualBackup() async {
    createManualBackupCalls += 1;
    emit(state.copyWith(status: const ConfigBackupSaved('ok')));
  }

  @override
  Future<void> shareExportBackup() async {
    shareBackupCalls += 1;
    emit(state.copyWith(status: const ConfigBackupShared('ok')));
  }

  @override
  Future<String?> selectZipFile() async {
    selectZipFileCalls += 1;
    return selectZipFileReturnPath;
  }

  @override
  Future<void> restoreManualBackup(String path) async {
    restoreManualBackupCalls += 1;
    lastRestoreManualBackupPath = path;
    emit(state.copyWith(status: const ConfigRestoreBackupManualSuccess('ok')));
  }

  @override
  Future<void> restoreAutomaticBackup() async {
    restoreAutomaticBackupCalls += 1;
    emit(state.copyWith(status: const ConfigRestoreBackupAutomaticSuccess('ok')));
  }
}

class OpenBottomSheetHost extends StatefulWidget {
  const OpenBottomSheetHost({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<OpenBottomSheetHost> createState() => _OpenBottomSheetHostState();
}

class _OpenBottomSheetHostState extends State<OpenBottomSheetHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => widget.child,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('HOST')));
  }
}
