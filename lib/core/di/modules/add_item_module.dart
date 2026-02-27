import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/features/add_item/domain/usecases/create_item_usecase.dart';
import 'package:lockpass/features/add_item/domain/usecases/load_item_groups_usecase.dart';
import 'package:lockpass/features/add_item/presentation/controller/add_item_controller.dart';

void registerAddItemModule() {
  // UseCases
  getIt.registerLazySingleton<CreateItemUseCase>(
    () => CreateItemUseCase(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton<LoadItemGroupsUseCase>(
    () => LoadItemGroupsUseCase(getIt(), getIt(), getIt()),
  );

  // Controller
  getIt.registerFactory<AddItemController>(
    () => AddItemController(
      createItemUseCase: getIt(),
      loadItemGroupsUseCase: getIt(),
    ),
  );
}
