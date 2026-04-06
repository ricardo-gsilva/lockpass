import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/di/service_locator.dart';
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
import 'package:lockpass/features/list_item/presentation/enums/list_view_enum.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/page/list_item_page.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';

class _FakeLoadItemsUseCase implements LoadItemsUseCase {
  _FakeLoadItemsUseCase({required this.result});

  final ({List<ItensEntity> items, List<ItensEntity> sorted, bool hasDeleted, ListViewModeEnum mode}) result;

  @override
  Future<({List<ItensEntity> items, List<ItensEntity> sorted, bool hasDeleted, ListViewModeEnum mode})> call(
    ListViewModeEnum currentMode,
  ) async {
    return result;
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
  _FakeCheckHasDeletedItemsUseCase(this.value);
  final bool value;

  @override
  Future<bool> call() async => value;
}

class _TestListItemController extends ListItemController {
  _TestListItemController({
    required ({List<ItensEntity> items, List<ItensEntity> sorted, bool hasDeleted, ListViewModeEnum mode}) loadResult,
    required bool hasDeletedItems,
  }) : super(
          loadItemsUseCase: _FakeLoadItemsUseCase(result: loadResult),
          decryptItemPasswordUseCase: _FakeDecryptItemPasswordUseCase(),
          editItemUseCase: _FakeEditItemUseCase(),
          deleteItemUseCase: _FakeDeleteItemUseCase(),
          moveItemToTrashUseCase: _FakeMoveToTrashUseCase(),
          restoreItemUseCase: _FakeRestoreItemUseCase(),
          deleteItemPermanentlyUseCase: _FakeDeletePermanentlyUseCase(),
          reauthenticateWithCredentialsUseCase: _FakeReauthenticateWithCredentialsUseCase(),
          authenticateTrashWithPinUseCase: _FakeAuthenticateTrashWithPinUseCase(),
          checkHasDeletedItemsUseCase: _FakeCheckHasDeletedItemsUseCase(hasDeletedItems),
        );

  void seedForTest(ListItemState state) {
    emit(state);
  }

  @override
  Future<void> loadItems() async {
    // no-op in widget tests to avoid async/state loops during initState
  }

  @override
  void toggleSearchMode(bool hasFocus) {
    if (state.isSearch == hasFocus) return;
    super.toggleSearchMode(hasFocus);
  }
}

ListItemController _controller({
  required ({List<ItensEntity> items, List<ItensEntity> sorted, bool hasDeleted, ListViewModeEnum mode}) loadResult,
  required bool hasDeletedItems,
}) {
  return _TestListItemController(
    loadResult: loadResult,
    hasDeletedItems: hasDeletedItems,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    if (getIt.isRegistered<ListItemController>()) {
      getIt.unregister<ListItemController>();
    }
  });

  Widget _app() {
    return const MaterialApp(
      home: ListItemPage(viewMode: ListViewEnum.list),
    );
  }

  group('ListItemPage (widget)', () {
    testWidgets('shows empty message when no deleted items', (tester) async {
      final controller = _controller(
        loadResult: (
          items: <ItensEntity>[],
          sorted: <ItensEntity>[],
          hasDeleted: false,
          mode: ListViewModeEnum.list,
        ),
        hasDeletedItems: false,
      );
      (controller as _TestListItemController).seedForTest(const ListItemState(
        listMode: ListViewModeEnum.list,
        hasDeletedItems: false,
        allItems: <ItensEntity>[],
        filteredItems: <ItensEntity>[],
      ));
      getIt.registerSingleton<ListItemController>(controller);

      await tester.pumpWidget(_app());
      expect(find.text(CoreStrings.emptyTrash), findsOneWidget);

      // Dispose page to trigger its dispose() without awaiting controller.close().
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('shows question when there are deleted items', (tester) async {
      final controller = _controller(
        loadResult: (
          items: <ItensEntity>[],
          sorted: <ItensEntity>[],
          hasDeleted: true,
          mode: ListViewModeEnum.list,
        ),
        hasDeletedItems: true,
      );
      (controller as _TestListItemController).seedForTest(const ListItemState(
        listMode: ListViewModeEnum.list,
        hasDeletedItems: true,
        allItems: <ItensEntity>[],
        filteredItems: <ItensEntity>[],
      ));
      getIt.registerSingleton<ListItemController>(controller);

      await tester.pumpWidget(_app());
      expect(find.text(CoreStrings.showDeletedItemsQuestion), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('typing into search calls controller.searchList and can show noItemsFoundInSearch', (tester) async {
      final item = ItensEntity(
        userId: 'u1',
        id: 1,
        group: 'Email',
        service: 'Gmail',
        login: 'user@gmail.com',
        password: 'secret',
      );
      final controller = _controller(
        loadResult: (
          items: [item],
          sorted: [item],
          hasDeleted: false,
          mode: ListViewModeEnum.list,
        ),
        hasDeletedItems: false,
      );
      (controller as _TestListItemController).seedForTest(ListItemState(
        listMode: ListViewModeEnum.list,
        hasDeletedItems: false,
        allItems: [item],
        filteredItems: [item],
      ));
      getIt.registerSingleton<ListItemController>(controller);

      await tester.pumpWidget(_app());

      expect(find.byType(TextFormField), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'zzzzz');
      await tester.pump();

      expect(find.text(CoreStrings.noItemsFoundInSearch), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  });
}
