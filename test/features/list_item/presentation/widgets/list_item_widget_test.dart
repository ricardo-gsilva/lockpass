import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
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
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';
import 'package:lockpass/features/list_item/presentation/widgets/list_item_widget.dart';

class _FakeLoadItemsUseCase implements LoadItemsUseCase {
  @override
  Future<({List<ItensEntity> items, List<ItensEntity> sorted, bool hasDeleted, ListViewModeEnum mode})> call(
    ListViewModeEnum currentMode,
  ) async {
    return (items: <ItensEntity>[], sorted: <ItensEntity>[], hasDeleted: false, mode: currentMode);
  }
}

class _FakeDecryptItemPasswordUseCase implements DecryptItemPasswordUseCase {
  @override
  ItensEntity call(ItensEntity item) => item;
}

class _FakeEditItemUseCase implements EditItemUseCase {
  @override
  Future<ItensEntity> call(ItensEntity item) async => item;
}

class _FakeDeleteItemUseCase implements DeleteItemUseCase {
  @override
  Future<void> call(ItensEntity item) async {}
}

class _FakeMoveToTrashUseCase implements MoveItemToTrashUseCase {
  @override
  Future<void> call(ItensEntity item) async {}
}

class _FakeRestoreItemUseCase implements RestoreItemUseCase {
  @override
  Future<void> call(ItensEntity item) async {}
}

class _FakeDeletePermanentlyUseCase implements DeleteItemPermanentlyUseCase {
  @override
  Future<void> call(ItensEntity item) async {}
}

class _FakeReauthenticateWithCredentialsUseCase implements ReauthenticateWithCredentialsUseCase {
  @override
  Future<void> call({required String email, required String password}) async {}
}

class _FakeAuthenticateTrashWithPinUseCase implements AuthenticateTrashWithPinUseCase {
  @override
  Future<void> call(String pin) async {}
}

class _FakeCheckHasDeletedItemsUseCase implements CheckHasDeletedItemsUseCase {
  @override
  Future<bool> call() async => false;
}

ListItemController _controllerWithState(ListItemState state) {
  final controller = ListItemController(
    loadItemsUseCase: _FakeLoadItemsUseCase(),
    decryptItemPasswordUseCase: _FakeDecryptItemPasswordUseCase(),
    editItemUseCase: _FakeEditItemUseCase(),
    deleteItemUseCase: _FakeDeleteItemUseCase(),
    moveItemToTrashUseCase: _FakeMoveToTrashUseCase(),
    restoreItemUseCase: _FakeRestoreItemUseCase(),
    deleteItemPermanentlyUseCase: _FakeDeletePermanentlyUseCase(),
    reauthenticateWithCredentialsUseCase: _FakeReauthenticateWithCredentialsUseCase(),
    authenticateTrashWithPinUseCase: _FakeAuthenticateTrashWithPinUseCase(),
    checkHasDeletedItemsUseCase: _FakeCheckHasDeletedItemsUseCase(),
  );

  controller.emit(state);
  return controller;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _app(ListItemController controller) {
    return MaterialApp(
      home: BlocProvider.value(
        value: controller,
        child: const Scaffold(body: ListItemWidget()),
      ),
    );
  }

  group('ListItemWidget (widget)', () {
    testWidgets('shows empty state when filteredItems is empty', (tester) async {
      final controller = _controllerWithState(const ListItemState(filteredItems: []));
      addTearDown(controller.close);

      await tester.pumpWidget(_app(controller));

      expect(find.text(CoreStrings.noItemsFound), findsOneWidget);
      expect(find.byKey(CoreKeys.listTileListItem), findsNothing);
    });

    testWidgets('renders items in list mode with expected keys', (tester) async {
      final item = ItensEntity(
        userId: 'u1',
        id: 1,
        group: 'Email',
        service: 'Gmail',
        login: 'user@gmail.com',
        password: 'secret',
      );
      final controller = _controllerWithState(
        ListItemState(
          listMode: ListViewModeEnum.list,
          filteredItems: [item],
        ),
      );
      addTearDown(controller.close);

      await tester.pumpWidget(_app(controller));

      expect(find.byKey(CoreKeys.listTileListItem), findsOneWidget);
      expect(find.byKey(CoreKeys.titleLeadingListTile), findsOneWidget);
      expect(find.byKey(CoreKeys.subTitleLeadingListTile), findsOneWidget);
      expect(find.text('Gmail'), findsOneWidget);
      expect(find.text('user@gmail.com'), findsOneWidget);
    });
  });
}

