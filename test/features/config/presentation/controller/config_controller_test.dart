import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
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
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockItensRepository extends Mock implements ItensRepository {}

class _MockGetPinStatusUseCase extends Mock implements GetPinStatusUseCase {}

class _MockReauthAndRemovePinUseCase extends Mock
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

void main() {
  late _MockItensRepository itensRepository;
  late _MockGetPinStatusUseCase getPinStatusUseCase;
  late _MockReauthAndRemovePinUseCase reauthAndRemovePinUseCase;
  late _MockDeleteAccountUseCase deleteAccountUseCase;
  late _MockSignOutUseCase signOutUseCase;
  late _MockSavePinUseCase savePinUseCase;
  late _MockUpdatePinUseCase updatePinUseCase;
  late _MockConfirmAndRemovePinUseCase confirmAndRemovePinUseCase;
  late _MockUpdatePasswordUseCase updatePasswordUseCase;
  late _MockCreateManualBackupUseCase createManualBackupUseCase;
  late _MockShareBackupUseCase shareBackupUseCase;
  late _MockRestoreManualBackupUseCase restoreManualBackupUseCase;
  late _MockRestoreAutomaticBackupUseCase restoreAutomaticBackupUseCase;
  late _MockSelectZipFileUseCase selectZipFileUseCase;
  late _MockSetLockTimeoutUseCase setLockTimeoutUseCase;
  late _MockGetLockTimeoutUseCase getLockTimeoutUseCase;

  ConfigController buildController({bool? isAndroidOverride}) {
    return ConfigController(
      itensRepository: itensRepository,
      getPinStatusUseCase: getPinStatusUseCase,
      reauthAndRemovePinUseCase: reauthAndRemovePinUseCase,
      deleteAccountUseCase: deleteAccountUseCase,
      signOutUseCase: signOutUseCase,
      savePinUseCase: savePinUseCase,
      updatePinUseCase: updatePinUseCase,
      confirmAndRemovePinUseCase: confirmAndRemovePinUseCase,
      updatePasswordUseCase: updatePasswordUseCase,
      createManualBackupUseCase: createManualBackupUseCase,
      shareBackupUseCase: shareBackupUseCase,
      restoreManualBackupUseCase: restoreManualBackupUseCase,
      restoreAutomaticBackupUseCase: restoreAutomaticBackupUseCase,
      selectZipFileUseCase: selectZipFileUseCase,
      setLockTimeoutUseCase: setLockTimeoutUseCase,
      getLockTimeoutUseCase: getLockTimeoutUseCase,
      isAndroidOverride: isAndroidOverride,
    );
  }

  setUp(() {
    itensRepository = _MockItensRepository();
    getPinStatusUseCase = _MockGetPinStatusUseCase();
    reauthAndRemovePinUseCase = _MockReauthAndRemovePinUseCase();
    deleteAccountUseCase = _MockDeleteAccountUseCase();
    signOutUseCase = _MockSignOutUseCase();
    savePinUseCase = _MockSavePinUseCase();
    updatePinUseCase = _MockUpdatePinUseCase();
    confirmAndRemovePinUseCase = _MockConfirmAndRemovePinUseCase();
    updatePasswordUseCase = _MockUpdatePasswordUseCase();
    createManualBackupUseCase = _MockCreateManualBackupUseCase();
    shareBackupUseCase = _MockShareBackupUseCase();
    restoreManualBackupUseCase = _MockRestoreManualBackupUseCase();
    restoreAutomaticBackupUseCase = _MockRestoreAutomaticBackupUseCase();
    selectZipFileUseCase = _MockSelectZipFileUseCase();
    setLockTimeoutUseCase = _MockSetLockTimeoutUseCase();
    getLockTimeoutUseCase = _MockGetLockTimeoutUseCase();

    when(() => getPinStatusUseCase.call()).thenAnswer((_) async => false);
  });

  group('ConfigController', () {
    blocTest<ConfigController, ConfigState>(
      'initializes and loads pin status',
      build: () => buildController(isAndroidOverride: true),
      act: (_) async {
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => const [
        ConfigState(isAndroid: true),
        ConfigState(status: ConfigLoading(), isAndroid: true),
        ConfigState(status: ConfigInitial(), hasPin: false, isAndroid: true),
      ],
    );

    blocTest<ConfigController, ConfigState>(
      'signOut emits logout success',
      build: () => buildController(isAndroidOverride: true),
      setUp: () {
        when(() => signOutUseCase.call()).thenAnswer((_) async {});
      },
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.signOut();
      },
      skip: 3,
      expect: () => const [
        ConfigState(status: ConfigLoading()),
        ConfigState(status: ConfigLogoutSuccess()),
      ],
    );

    blocTest<ConfigController, ConfigState>(
      'signOut maps AuthErrorType to ConfigError',
      build: () => buildController(isAndroidOverride: true),
      setUp: () {
        when(() => signOutUseCase.call()).thenThrow(AuthErrorType.requiresRecentLogin);
      },
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.signOut();
      },
      skip: 3,
      expect: () => [
        const ConfigState(status: ConfigLoading()),
        ConfigState(status: ConfigError(AuthErrorType.requiresRecentLogin.message)),
      ],
    );

    blocTest<ConfigController, ConfigState>(
      'signOut maps AuthException to ConfigError',
      build: () => buildController(isAndroidOverride: true),
      setUp: () {
        when(() => signOutUseCase.call()).thenThrow(AuthException('Falhou'));
      },
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.signOut();
      },
      skip: 3,
      expect: () => const [
        ConfigState(status: ConfigLoading()),
        ConfigState(status: ConfigError('Falhou')),
      ],
    );

    blocTest<ConfigController, ConfigState>(
      'saveNewPin sets hasPin true on success',
      build: () => buildController(isAndroidOverride: true),
      setUp: () {
        when(() => savePinUseCase.call('12345')).thenAnswer((_) async {});
      },
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.saveNewPin('12345');
      },
      skip: 3,
      expect: () => const [
        ConfigState(status: ConfigLoading()),
        ConfigState(status: ConfigSuccess(CoreStrings.savePinSuccess), hasPin: true),
      ],
    );

    blocTest<ConfigController, ConfigState>(
      'saveUpdatePin emits pin mismatch error for INVALID_CURRENT_PIN',
      build: () => buildController(isAndroidOverride: true),
      setUp: () {
        when(
          () => updatePinUseCase.call(
            currentPin: '11111',
            newPin: '22222',
          ),
        ).thenThrow(Exception('INVALID_CURRENT_PIN'));
      },
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.saveUpdatePin('11111', '22222');
      },
      skip: 3,
      expect: () => const [
        ConfigState(status: ConfigLoading()),
        ConfigState(status: ConfigError(CoreStrings.pinMismatchError)),
      ],
    );

    blocTest<ConfigController, ConfigState>(
      'confirmAndRemovePin emits success and sets hasPin false',
      build: () => buildController(isAndroidOverride: true),
      setUp: () {
        when(() => confirmAndRemovePinUseCase.call('12345')).thenAnswer((_) async {});
      },
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.confirmAndRemovePin('12345');
      },
      skip: 3,
      expect: () => const [
        ConfigState(status: ConfigLoading()),
        ConfigState(status: ConfigPinRemoveSuccess(CoreStrings.removePinSuccess), hasPin: false),
      ],
    );

    blocTest<ConfigController, ConfigState>(
      'restoreManualBackup validates empty path',
      build: () => buildController(isAndroidOverride: true),
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.restoreManualBackup('');
      },
      skip: 3,
      expect: () => const [
        ConfigState(status: ConfigError(CoreStrings.noFileSelected), isAndroid: true),
      ],
    );

    blocTest<ConfigController, ConfigState>(
      'setLockTimeout emits error when use case returns false',
      build: () => buildController(isAndroidOverride: true),
      setUp: () {
        when(() => setLockTimeoutUseCase.call(60)).thenAnswer((_) async => false);
      },
      act: (cubit) async {
        await Future<void>.delayed(Duration.zero);
        await cubit.setLockTimeout(60);
      },
      skip: 3,
      expect: () => const [
        ConfigState(status: ConfigLoading()),
        ConfigState(status: ConfigError(CoreStrings.saveLockTimerImpossible)),
      ],
    );

    test('getLockTimeout returns value from use case', () {
      when(() => getLockTimeoutUseCase.call()).thenReturn(90);
      final controller = buildController();
      addTearDown(controller.close);
      expect(controller.getLockTimeout(), 90);
    });
  });
}
