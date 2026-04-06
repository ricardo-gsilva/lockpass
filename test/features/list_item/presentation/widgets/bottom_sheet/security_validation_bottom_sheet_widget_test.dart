import 'dart:async';

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
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_status.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/security_validation_bottom_sheet.dart';

import '../../../../../test_utils/widget_test_pump.dart';

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

class _NoOpEditItemUseCase implements EditItemUseCase {
  @override
  Future<ItensEntity> call(ItensEntity item) async => item;
}

class _NoOpDeleteItemUseCase implements DeleteItemUseCase {
  @override
  Future<void> call(ItensEntity item) async {}
}

class _NoOpMoveToTrashUseCase implements MoveItemToTrashUseCase {
  @override
  Future<void> call(ItensEntity item) async {}
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
  Future<bool> call() async => true;
}

class _TestListItemController extends ListItemController {
  _TestListItemController() : super(
    loadItemsUseCase: _NoOpLoadItemsUseCase(),
    decryptItemPasswordUseCase: _NoOpDecryptItemPasswordUseCase(),
    editItemUseCase: _NoOpEditItemUseCase(),
    deleteItemUseCase: _NoOpDeleteItemUseCase(),
    moveItemToTrashUseCase: _NoOpMoveToTrashUseCase(),
    restoreItemUseCase: _NoOpRestoreItemUseCase(),
    deleteItemPermanentlyUseCase: _NoOpDeletePermanentlyUseCase(),
    reauthenticateWithCredentialsUseCase: _NoOpReauthenticateWithCredentialsUseCase(),
    authenticateTrashWithPinUseCase: _NoOpAuthenticateTrashWithPinUseCase(),
    checkHasDeletedItemsUseCase: _NoOpCheckHasDeletedItemsUseCase(),
  );

  int authenticateCalls = 0;
  ({bool pinOrEmailAndPassword, String? pin, String? email, String? password})? lastArgs;

  @override
  Future<void> authenticateTrashMode({
    required bool pinOrEmailAndPassword,
    String? pin,
    String? email,
    String? password,
  }) async {
    authenticateCalls += 1;
    lastArgs = (
      pinOrEmailAndPassword: pinOrEmailAndPassword,
      pin: pin,
      email: email,
      password: password,
    );

    emit(state.copyWith(status: const TrashAuthSuccess()));
  }

  void seed(ListItemState state) => emit(state);
}

class _OpenBottomSheetHost extends StatefulWidget {
  const _OpenBottomSheetHost({required this.onResult});

  final void Function(Future<bool?> result) onResult;

  @override
  State<_OpenBottomSheetHost> createState() => _OpenBottomSheetHostState();
}

class _OpenBottomSheetHostState extends State<_OpenBottomSheetHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final result = showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const SecurityValidationBottomSheet(),
      );
      widget.onResult(result);
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('HOST'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    if (getIt.isRegistered<ListItemController>()) {
      getIt.unregister<ListItemController>();
    }
  });

  group('SecurityValidationBottomSheet (widget)', () {
    testWidgets('authenticates with PIN and pops with true on success', (tester) async {
      final controller = _TestListItemController();
      addTearDown(controller.close);
      controller.seed(const ListItemState(status: ListItemLoaded()));
      getIt.registerSingleton<ListItemController>(controller);

      final completer = Completer<bool?>();

      await tester.pumpWidget(
        MaterialApp(
          home: _OpenBottomSheetHost(
            onResult: (future) => future.then(completer.complete),
          ),
        ),
      );

      await pumpModal(tester);

      await tester.enterText(find.byType(TextFormField).first, '12345');
      await tester.pump();

      final showDeletedButton = find.widgetWithText(ElevatedButton, CoreStrings.showDeleted);
      await tester.tap(showDeletedButton);
      await pumpModal(tester);
      await flushToasts(tester);

      expect(controller.authenticateCalls, 1);
      expect(controller.lastArgs?.pinOrEmailAndPassword, isFalse);
      expect(controller.lastArgs?.pin, '12345');

      expect(await completer.future, isTrue);
    });
  });
}
