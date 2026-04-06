import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';
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
import 'package:lockpass/features/list_item/presentation/state/list_item_status.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/delete_item_bottom_sheet.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/item_details_bottom_sheet.dart';
import 'package:lockpass/features/list_item/presentation/widgets/item_edit_view_widget.dart';

class _NoOpLoadItemsUseCase implements LoadItemsUseCase {
  @override
  Future<({List<ItensEntity> items, List<ItensEntity> sorted, bool hasDeleted, ListViewModeEnum mode})> call(
    ListViewModeEnum currentMode,
  ) async {
    return (items: <ItensEntity>[], sorted: <ItensEntity>[], hasDeleted: false, mode: currentMode);
  }
}

class _NoOpDecryptItemPasswordUseCase implements DecryptItemPasswordUseCase {
  @override
  ItensEntity call(ItensEntity item) => item;
}

class _RecordingEditItemUseCase implements EditItemUseCase {
  ItensEntity? lastItem;

  @override
  Future<ItensEntity> call(ItensEntity item) async {
    lastItem = item;
    return item;
  }
}

class _RecordingMoveToTrashUseCase implements MoveItemToTrashUseCase {
  ItensEntity? lastItem;
  int calls = 0;

  @override
  Future<void> call(ItensEntity item) async {
    calls += 1;
    lastItem = item;
  }
}

class _RecordingRestoreItemUseCase implements RestoreItemUseCase {
  ItensEntity? lastItem;
  int calls = 0;

  @override
  Future<void> call(ItensEntity item) async {
    calls += 1;
    lastItem = item;
  }
}

class _RecordingDeletePermanentlyUseCase implements DeleteItemPermanentlyUseCase {
  ItensEntity? lastItem;
  int calls = 0;

  @override
  Future<void> call(ItensEntity item) async {
    calls += 1;
    lastItem = item;
  }
}

class _NoOpDeleteItemUseCase implements DeleteItemUseCase {
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
    required this.editUseCase,
    required this.moveToTrashUseCase,
    required this.restoreUseCase,
    required this.deletePermanentlyUseCase,
  }) : super(
          loadItemsUseCase: _NoOpLoadItemsUseCase(),
          decryptItemPasswordUseCase: _NoOpDecryptItemPasswordUseCase(),
          editItemUseCase: editUseCase,
          deleteItemUseCase: _NoOpDeleteItemUseCase(),
          moveItemToTrashUseCase: moveToTrashUseCase,
          restoreItemUseCase: restoreUseCase,
          deleteItemPermanentlyUseCase: deletePermanentlyUseCase,
          reauthenticateWithCredentialsUseCase: _NoOpReauthenticateWithCredentialsUseCase(),
          authenticateTrashWithPinUseCase: _NoOpAuthenticateTrashWithPinUseCase(),
          checkHasDeletedItemsUseCase: _NoOpCheckHasDeletedItemsUseCase(),
        );

  final _RecordingEditItemUseCase editUseCase;
  final _RecordingMoveToTrashUseCase moveToTrashUseCase;
  final _RecordingRestoreItemUseCase restoreUseCase;
  final _RecordingDeletePermanentlyUseCase deletePermanentlyUseCase;

  void seedForTest(ListItemState state) {
    emit(state);
  }

  @override
  Future<void> loadItems() async {
    // no-op in widget tests to avoid async/state loops.
  }
}

Widget _app({
  required ListItemController controller,
  required ItensEntity item,
}) {
  return MaterialApp(
    navigatorKey: AppRoutes.navigatorKey,
    home: Scaffold(
      body: BlocProvider.value(
        value: controller,
        child: ItemDetailsBottomSheet(item: item),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ItemDetailsBottomSheet (widget)', () {
    testWidgets('toggles edit mode and saves updated item', (tester) async {
      final item = ItensEntity(
        userId: 'u',
        id: 1,
        group: 'Email',
        service: 'Gmail',
        login: 'user@gmail.com',
        password: 'pw',
      );

      final editUseCase = _RecordingEditItemUseCase();
      final controller = _TestListItemController(
        editUseCase: editUseCase,
        moveToTrashUseCase: _RecordingMoveToTrashUseCase(),
        restoreUseCase: _RecordingRestoreItemUseCase(),
        deletePermanentlyUseCase: _RecordingDeletePermanentlyUseCase(),
      );

      controller.seedForTest(
        ListItemState(
          status: const ListItemLoaded(),
          listMode: ListViewModeEnum.list,
          selectedItem: item,
          allItems: [item],
          filteredItems: [item],
          allGroups: const [GroupsEntity(groupName: 'Email')],
        ),
      );

      await tester.pumpWidget(_app(controller: controller, item: item));

      expect(find.text(item.login), findsWidgets);
      expect(find.text(CoreStrings.close), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      expect(find.byType(ItemEditViewWidget), findsOneWidget);
      expect(find.text(CoreStrings.save), findsOneWidget);

      final dynamic state = tester.state(find.byType(ItemDetailsBottomSheet));
      final serviceController = state.serviceController as TextEditingController;
      final emailController = state.emailController as TextEditingController;

      final serviceFieldFinder = find.byWidgetPredicate(
        (widget) => widget is TextFormField && widget.controller == serviceController,
      );
      expect(serviceFieldFinder, findsOneWidget);

      final emailFieldFinder = find.byWidgetPredicate(
        (widget) => widget is TextFormField && widget.controller == emailController,
      );
      expect(emailFieldFinder, findsOneWidget);

      await tester.enterText(serviceFieldFinder, 'Google');
      await tester.enterText(emailFieldFinder, 'user@example.com');
      await tester.pump();

      final saveButton = find.widgetWithText(ElevatedButton, CoreStrings.save);
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pump();

      expect(editUseCase.lastItem, isNotNull);
      expect(editUseCase.lastItem?.service, 'Google');

      // OverlayToast schedules delayed removal; advance time to avoid pending timers.
      await tester.pump(const Duration(seconds: 7));
      await tester.pump();
    });

    testWidgets('trash mode restore and delete permanently', (tester) async {
      final item = ItensEntity(
        userId: 'u',
        id: 1,
        group: 'Email',
        service: 'Gmail',
        login: 'user@gmail.com',
        password: 'pw',
        isDeleted: true,
      );

      final restoreUseCase = _RecordingRestoreItemUseCase();
      final deletePermanentlyUseCase = _RecordingDeletePermanentlyUseCase();
      final controller = _TestListItemController(
        editUseCase: _RecordingEditItemUseCase(),
        moveToTrashUseCase: _RecordingMoveToTrashUseCase(),
        restoreUseCase: restoreUseCase,
        deletePermanentlyUseCase: deletePermanentlyUseCase,
      );

      controller.seedForTest(
        ListItemState(
          status: const ListItemLoaded(),
          listMode: ListViewModeEnum.trash,
          selectedItem: item,
          allItems: [item],
          filteredItems: [item],
          allGroups: const [GroupsEntity(groupName: 'Email')],
        ),
      );

      await tester.pumpWidget(_app(controller: controller, item: item));

      final restoreButton = find.widgetWithText(ElevatedButton, CoreStrings.restore);
      await tester.ensureVisible(restoreButton);
      await tester.tap(restoreButton);
      await tester.pump();
      expect(restoreUseCase.calls, 1);
      expect(restoreUseCase.lastItem?.id, 1);

      await tester.pump(const Duration(seconds: 7));
      await tester.pump();

      final deleteButton = find.widgetWithText(ElevatedButton, CoreStrings.delete);
      await tester.ensureVisible(deleteButton);
      await tester.tap(deleteButton);
      // Pump a fixed duration to allow the bottom sheet animation to complete without
      // risking long-running pumpAndSettle loops.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();

      expect(find.text(CoreStrings.deletePermanently), findsOneWidget);

      final confirmSheetFinder = find.byType(ConfirmationBottomSheet);
      expect(confirmSheetFinder, findsOneWidget);

      // Avoid tapping a button that may be off-screen in the bottom sheet.
      final sheet = tester.widget<ConfirmationBottomSheet>(confirmSheetFinder);
      sheet.onConfirm();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(deletePermanentlyUseCase.calls, 1);
      expect(deletePermanentlyUseCase.lastItem?.id, 1);
      expect(find.text(CoreStrings.deletePermanently), findsNothing);

      await tester.pump(const Duration(seconds: 7));
      await tester.pump();
    });
  });
}
