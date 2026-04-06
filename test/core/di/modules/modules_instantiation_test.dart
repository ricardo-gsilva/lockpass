import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/di/modules/add_item_module.dart';
import 'package:lockpass/core/di/modules/config_module.dart';
import 'package:lockpass/core/di/modules/home_module.dart';
import 'package:lockpass/core/di/modules/list_item_module.dart';
import 'package:lockpass/core/di/modules/login_module.dart';
import 'package:lockpass/core/di/modules/session_module.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/vault/vault_service.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/services/file_picker/file_picker_service.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/core/session/presentation/controller/lock_screen_controller.dart';
import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/add_item/domain/usecases/create_item_usecase.dart';
import 'package:lockpass/features/add_item/domain/usecases/load_item_groups_usecase.dart';
import 'package:lockpass/features/add_item/presentation/controller/add_item_controller.dart';
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
import 'package:lockpass/features/home/domain/usecases/check_if_should_show_pin_alert_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/create_automatic_backup_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/get_current_user_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/set_hide_create_pin_usecase.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/list_item/domain/usecases/authenticate_with_pin_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/check_if_has_deleted_items_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/decrypt_item_password_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/delete_item_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/delete_permanentetly_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/edit_item_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/load_items_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/move_to_trash_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/reauthenticate_with_credentials_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/restore_item_usecase.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/login/domain/usecases/check_pin_availability_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_email_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_pin_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/register_user_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/reset_password_usecase.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockPinService extends Mock implements PinService {}

class _MockItensRepository extends Mock implements ItensRepository {}

class _MockDekManager extends Mock implements DekManager {}

class _MockVaultService extends Mock implements VaultService {}

class _MockBackupService extends Mock implements BackupService {}

class _MockFilePickerService extends Mock implements FilePickerService {}

class _MockPrefsDatasource extends Mock implements SharedPreferencesDatasource {}

class _MockSessionLockService extends Mock implements SessionLockService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DI modules instantiate registrations (no plugin impls)', () {
    setUp(() async {
      await getIt.reset();
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('registerLoginModule builds usecases + controller', () {
      getIt.registerSingleton<AuthService>(_MockAuthService());
      getIt.registerSingleton<PinService>(_MockPinService());
      getIt.registerSingleton<SessionLockService>(_MockSessionLockService());

      registerLoginModule();

      expect(getIt<CheckPinAvailabilityUseCase>(), isA<CheckPinAvailabilityUseCase>());
      expect(getIt<LoginWithEmailUseCase>(), isA<LoginWithEmailUseCase>());
      expect(getIt<LoginWithPinUseCase>(), isA<LoginWithPinUseCase>());
      expect(getIt<RegisterUserUseCase>(), isA<RegisterUserUseCase>());
      expect(getIt<ResetPasswordUseCase>(), isA<ResetPasswordUseCase>());

      final controller = getIt<LoginController>();
      addTearDown(controller.close);
      expect(controller, isA<LoginController>());
    });

    test('registerHomeModule builds usecases + controller', () {
      getIt.registerSingleton<PinService>(_MockPinService());
      getIt.registerSingleton<SharedPreferencesDatasource>(_MockPrefsDatasource());
      getIt.registerSingleton<ItensRepository>(_MockItensRepository());
      getIt.registerSingleton<BackupService>(_MockBackupService());
      getIt.registerSingleton<AuthService>(_MockAuthService());

      registerHomeModule();

      expect(getIt<CheckIfShouldShowPinAlertUseCase>(), isA<CheckIfShouldShowPinAlertUseCase>());
      expect(getIt<CreateAutomaticBackupUseCase>(), isA<CreateAutomaticBackupUseCase>());
      expect(getIt<SetHideCreatePinAlertUseCase>(), isA<SetHideCreatePinAlertUseCase>());
      expect(getIt<GetCurrentUserUseCase>(), isA<GetCurrentUserUseCase>());

      final controller = getIt<HomeController>();
      addTearDown(controller.close);
      expect(controller, isA<HomeController>());
    });

    test('registerAddItemModule builds usecases + controller', () {
      getIt.registerSingleton<AuthService>(_MockAuthService());
      getIt.registerSingleton<ItensRepository>(_MockItensRepository());
      getIt.registerSingleton<DekManager>(_MockDekManager());

      registerAddItemModule();

      expect(getIt<CreateItemUseCase>(), isA<CreateItemUseCase>());
      expect(getIt<LoadItemGroupsUseCase>(), isA<LoadItemGroupsUseCase>());

      final controller = getIt<AddItemController>();
      addTearDown(controller.close);
      expect(controller, isA<AddItemController>());
    });

    test('registerListItemModule builds usecases + controller', () {
      getIt.registerSingleton<AuthService>(_MockAuthService());
      getIt.registerSingleton<PinService>(_MockPinService());
      getIt.registerSingleton<ItensRepository>(_MockItensRepository());
      getIt.registerSingleton<DekManager>(_MockDekManager());

      registerListItemModule();

      expect(getIt<LoadItemsUseCase>(), isA<LoadItemsUseCase>());
      expect(getIt<EditItemUseCase>(), isA<EditItemUseCase>());
      expect(getIt<DeleteItemUseCase>(), isA<DeleteItemUseCase>());
      expect(getIt<MoveItemToTrashUseCase>(), isA<MoveItemToTrashUseCase>());
      expect(getIt<RestoreItemUseCase>(), isA<RestoreItemUseCase>());
      expect(getIt<DeleteItemPermanentlyUseCase>(), isA<DeleteItemPermanentlyUseCase>());
      expect(getIt<ReauthenticateWithCredentialsUseCase>(), isA<ReauthenticateWithCredentialsUseCase>());
      expect(getIt<AuthenticateTrashWithPinUseCase>(), isA<AuthenticateTrashWithPinUseCase>());
      expect(getIt<CheckHasDeletedItemsUseCase>(), isA<CheckHasDeletedItemsUseCase>());
      expect(getIt<DecryptItemPasswordUseCase>(), isA<DecryptItemPasswordUseCase>());

      final controller = getIt<ListItemController>();
      addTearDown(controller.close);
      expect(controller, isA<ListItemController>());
    });

    test('registerSessionModule builds usecases + controller', () {
      getIt.registerSingleton<AuthService>(_MockAuthService());
      getIt.registerSingleton<PinService>(_MockPinService());
      getIt.registerSingleton<SessionLockService>(_MockSessionLockService());
      getIt.registerSingleton<SharedPreferencesDatasource>(_MockPrefsDatasource());

      registerSessionModule();

      final controller = getIt<LockScreenController>();
      addTearDown(controller.close);
      expect(controller, isA<LockScreenController>());
    });

    test('registerConfigModule builds usecases + controller (microtask init safe)', () async {
      final auth = _MockAuthService();
      when(() => auth.currentUserId).thenReturn('uid');
      getIt.registerSingleton<AuthService>(auth);
      getIt.registerSingleton<PinService>(_MockPinService());
      getIt.registerSingleton<ItensRepository>(_MockItensRepository());
      getIt.registerSingleton<VaultService>(_MockVaultService());
      getIt.registerSingleton<BackupService>(_MockBackupService());
      getIt.registerSingleton<FilePickerService>(_MockFilePickerService());
      getIt.registerSingleton<SharedPreferencesDatasource>(_MockPrefsDatasource());

      // Ensure controller init doesn't crash when it calls GetPinStatusUseCase.
      final pin = getIt<PinService>();
      when(() => pin.hasPin(any())).thenAnswer((_) async => true);

      registerConfigModule();

      expect(getIt<GetPinStatusUseCase>(), isA<GetPinStatusUseCase>());
      expect(getIt<ReauthenticateAndRemovePinUseCase>(), isA<ReauthenticateAndRemovePinUseCase>());
      expect(getIt<DeleteAccountUseCase>(), isA<DeleteAccountUseCase>());
      expect(getIt<SignOutUseCase>(), isA<SignOutUseCase>());
      expect(getIt<SavePinUseCase>(), isA<SavePinUseCase>());
      expect(getIt<UpdatePinUseCase>(), isA<UpdatePinUseCase>());
      expect(getIt<ConfirmAndRemovePinUseCase>(), isA<ConfirmAndRemovePinUseCase>());
      expect(getIt<UpdatePasswordUseCase>(), isA<UpdatePasswordUseCase>());
      expect(getIt<CreateManualBackupUseCase>(), isA<CreateManualBackupUseCase>());
      expect(getIt<ShareBackupUseCase>(), isA<ShareBackupUseCase>());
      expect(getIt<RestoreManualBackupUseCase>(), isA<RestoreManualBackupUseCase>());
      expect(getIt<RestoreAutomaticBackupUseCase>(), isA<RestoreAutomaticBackupUseCase>());
      expect(getIt<SelectZipFileUseCase>(), isA<SelectZipFileUseCase>());
      expect(getIt<SetLockTimeoutUseCase>(), isA<SetLockTimeoutUseCase>());
      expect(getIt<GetLockTimeoutUseCase>(), isA<GetLockTimeoutUseCase>());

      final controller = getIt<ConfigController>();
      addTearDown(controller.close);
      expect(controller, isA<ConfigController>());

      // Allow the controller's microtask init to run.
      await Future<void>.delayed(Duration.zero);
    });
  });
}
