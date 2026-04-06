import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/list_item/domain/usecases/authenticate_with_pin_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/check_if_has_deleted_items_usecase.dart';
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
import 'package:lockpass/features/list_item/presentation/state/list_item_status.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/delete_item_bottom_sheet.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/item_details_bottom_sheet.dart';
import 'package:lockpass/features/list_item/presentation/widgets/list_item_widget.dart';

class _NoOpLoadItemsUseCase implements LoadItemsUseCase {
  @override
  Future<({List<ItensEntity> items, List<ItensEntity> sorted, bool hasDeleted, ListViewModeEnum mode})> call(
    ListViewModeEnum currentMode,
  ) async {
    return (items: <ItensEntity>[], sorted: <ItensEntity>[], hasDeleted: false, mode: currentMode);
  }
}

class _NoOpEditItemUseCase implements EditItemUseCase {
  @override
  Future<ItensEntity> call(ItensEntity item) async => item;
}

class _NoOpDeleteItemUseCase implements DeleteItemUseCase {
  @override
  Future<void> call(ItensEntity item) async {}
}

class _RecordingMoveToTrashUseCase implements MoveItemToTrashUseCase {
  int calls = 0;
  ItensEntity? lastItem;

  @override
  Future<void> call(ItensEntity item) async {
    calls += 1;
    lastItem = item;
  }
}

class _NoOpRestoreItemUseCase implements RestoreItemUseCase {
  @override
  Future<void> call(ItensEntity item) async {}
}

class _NoOpDeletePermanentlyUseCase implements DeleteItemPermanentlyUseCase {
  @override
  Future<void> call(ItensEntity item) async {}
}

class _NoOpReauthenticateWithCredentialsUseCase implements ReauthenticateWithCredentialsUseCase {
  @override
  Future<void> call({required String email, required String password}) async {}
}

class _NoOpAuthenticateTrashWithPinUseCase implements AuthenticateTrashWithPinUseCase {
  @override
  Future<void> call(String pin) async {}
}

class _NoOpCheckHasDeletedItemsUseCase implements CheckHasDeletedItemsUseCase {
  @override
  Future<bool> call() async => false;
}

class _TestListItemController extends ListItemController {
  _TestListItemController({
    required this.moveToTrashUseCase,
  }) : super(
          loadItemsUseCase: _NoOpLoadItemsUseCase(),
          editItemUseCase: _NoOpEditItemUseCase(),
          deleteItemUseCase: _NoOpDeleteItemUseCase(),
          moveItemToTrashUseCase: moveToTrashUseCase,
          restoreItemUseCase: _NoOpRestoreItemUseCase(),
          deleteItemPermanentlyUseCase: _NoOpDeletePermanentlyUseCase(),
          reauthenticateWithCredentialsUseCase: _NoOpReauthenticateWithCredentialsUseCase(),
          authenticateTrashWithPinUseCase: _NoOpAuthenticateTrashWithPinUseCase(),
          checkHasDeletedItemsUseCase: _NoOpCheckHasDeletedItemsUseCase(),
        );

  final _RecordingMoveToTrashUseCase moveToTrashUseCase;

  void seedForTest(ListItemState state) {
    emit(state);
  }

  @override
  Future<void> loadItems() async {
    // no-op in widget tests to avoid async/state loops.
  }
}

Widget _app({required ListItemController controller}) {
  return MaterialApp(
    navigatorKey: AppRoutes.navigatorKey,
    home: Scaffold(
      body: BlocProvider.value(
        value: controller,
        child: const ListItemWidget(),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ListItemWidget (widget)', () {
    testWidgets('shows empty state when there are no filtered items', (tester) async {
      final controller = _TestListItemController(moveToTrashUseCase: _RecordingMoveToTrashUseCase());

      controller.seedForTest(
        ListItemState(
          status: const ListItemLoaded(),
          listMode: ListViewModeEnum.list,
          filteredItems: const [],
          allItems: const [],
          allGroups: const [],
        ),
      );

      await tester.pumpWidget(_app(controller: controller));

      expect(find.text(CoreStrings.noItemsFound), findsOneWidget);
    });

    testWidgets('in trash mode, tapping an item opens ItemDetailsBottomSheet', (tester) async {
      final item = ItensEntity(
        userId: 'u',
        id: 1,
        group: 'Email',
        service: 'Gmail',
        login: 'user@gmail.com',
        password: 'pw',
        isDeleted: true,
      );

      final controller = _TestListItemController(moveToTrashUseCase: _RecordingMoveToTrashUseCase());
      controller.seedForTest(
        ListItemState(
          status: const ListItemLoaded(),
          listMode: ListViewModeEnum.trash,
          filteredItems: [item],
          allItems: [item],
          allGroups: const [GroupsEntity(groupName: 'Email')],
        ),
      );

      await tester.pumpWidget(_app(controller: controller));

      await tester.tap(find.byKey(ValueKey(item.id)));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      expect(find.byType(ItemDetailsBottomSheet), findsOneWidget);
    });

    testWidgets('on long press, confirms and moves item to trash', (tester) async {
      final item = ItensEntity(
        userId: 'u',
        id: 1,
        group: 'Email',
        service: 'Gmail',
        login: 'user@gmail.com',
        password: 'pw',
      );

      final moveUseCase = _RecordingMoveToTrashUseCase();
      final controller = _TestListItemController(moveToTrashUseCase: moveUseCase);
      controller.seedForTest(
        ListItemState(
          status: const ListItemLoaded(),
          listMode: ListViewModeEnum.list,
          filteredItems: [item],
          allItems: [item],
          allGroups: const [GroupsEntity(groupName: 'Email')],
        ),
      );

      await tester.pumpWidget(_app(controller: controller));

      await tester.longPress(find.byKey(const ValueKey('listTileListItem')));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      final confirmSheetFinder = find.byType(ConfirmationBottomSheet);
      expect(confirmSheetFinder, findsOneWidget);
      expect(find.text(CoreStrings.moveToTrash), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: confirmSheetFinder,
          matching: find.text(CoreStrings.moveToTrash),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(moveUseCase.calls, 1);
      expect(moveUseCase.lastItem?.id, 1);
    });

    testWidgets('in list mode, tapping an item opens ItemDetailsBottomSheet', (tester) async {
      final item = ItensEntity(
        userId: 'u',
        id: 1,
        group: 'Email',
        service: 'Gmail',
        login: 'user@gmail.com',
        password: 'pw',
      );

      final controller = _TestListItemController(moveToTrashUseCase: _RecordingMoveToTrashUseCase());
      controller.seedForTest(
        ListItemState(
          status: const ListItemLoaded(),
          listMode: ListViewModeEnum.list,
          filteredItems: [item],
          allItems: [item],
          allGroups: const [GroupsEntity(groupName: 'Email')],
        ),
      );

      await tester.pumpWidget(_app(controller: controller));

      await tester.tap(find.byKey(const ValueKey('listTileListItem')));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      expect(find.byType(ItemDetailsBottomSheet), findsOneWidget);
    });
  });
}
