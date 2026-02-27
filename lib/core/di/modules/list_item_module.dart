import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/features/list_item/domain/usecases/authenticate_with_pin_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/check_if_has_deleted_items_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/delete_permanentetly_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/load_items_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/edit_item_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/delete_item_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/move_to_trash_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/restore_item_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/reauthenticate_with_credentials_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/decrypt_item_password_usecase.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';

void registerListItemModule() {
  // UseCases
  getIt.registerLazySingleton<LoadItemsUseCase>(
    () => LoadItemsUseCase(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton<EditItemUseCase>(
    () => EditItemUseCase(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton<DeleteItemUseCase>(
    () => DeleteItemUseCase(getIt()),
  );

  getIt.registerLazySingleton<MoveItemToTrashUseCase>(
    () => MoveItemToTrashUseCase(getIt()),
  );

  getIt.registerLazySingleton<RestoreItemUseCase>(
    () => RestoreItemUseCase(getIt()),
  );

  getIt.registerLazySingleton<DeleteItemPermanentlyUseCase>(
    () => DeleteItemPermanentlyUseCase(getIt()),
  );

  getIt.registerLazySingleton<ReauthenticateWithCredentialsUseCase>(
    () => ReauthenticateWithCredentialsUseCase(getIt()),
  );

  getIt.registerLazySingleton<AuthenticateTrashWithPinUseCase>(
    () => AuthenticateTrashWithPinUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<CheckHasDeletedItemsUseCase>(
    () => CheckHasDeletedItemsUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<DecryptItemPasswordUseCase>(
    () => DecryptItemPasswordUseCase(getIt()),
  );

  // Controller
  getIt.registerFactory<ListItemController>(
    () => ListItemController(
      loadItemsUseCase: getIt(),
      editItemUseCase: getIt(),
      deleteItemUseCase: getIt(),
      moveItemToTrashUseCase: getIt(),
      restoreItemUseCase: getIt(),
      deleteItemPermanentlyUseCase: getIt(),
      reauthenticateWithCredentialsUseCase: getIt(),
      authenticateTrashWithPinUseCase: getIt(),
      checkHasDeletedItemsUseCase: getIt(),
      decryptItemPasswordUseCase: getIt(),
    ),
  );
}