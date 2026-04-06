import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/add_item/domain/usecases/create_item_usecase.dart';
import 'package:lockpass/features/add_item/domain/usecases/load_item_groups_usecase.dart';
import 'package:lockpass/features/add_item/presentation/controller/add_item_controller.dart';
import 'package:lockpass/features/add_item/presentation/page/add_item_page.dart';
import 'package:lockpass/features/home/domain/usecases/check_if_should_show_pin_alert_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/create_automatic_backup_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/get_current_user_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/set_hide_create_pin_usecase.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/pages/home_page.dart';
import 'package:lockpass/features/home/presentation/state/home_event.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/features/home/presentation/state/home_status.dart';
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

import '../../../../test_utils/widget_test_pump.dart';

class _TestAssetBundle extends CachingAssetBundle {
  _TestAssetBundle(this._transparentPngBytes);

  final Uint8List _transparentPngBytes;

  static final StandardMessageCodec _codec = StandardMessageCodec();

  ByteData _byteDataFromList(Uint8List bytes) => ByteData.view(bytes.buffer);

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') {
      final message = <String, List<Map<String, Object?>>>{
        CoreStrings.iconApp: <Map<String, Object?>>[
          <String, Object?>{'asset': CoreStrings.iconApp, 'dpr': null},
        ],
      };
      final encoded = _codec.encodeMessage(message);
      if (encoded == null) {
        throw FlutterError('Failed to encode AssetManifest.bin');
      }
      return encoded;
    }

    if (key == 'AssetManifest.json') {
      final json = jsonEncode({
        CoreStrings.iconApp: [
          {'asset': CoreStrings.iconApp, 'dpr': null},
        ],
      });
      return _byteDataFromList(Uint8List.fromList(utf8.encode(json)));
    }

    if (key == CoreStrings.iconApp) {
      return _byteDataFromList(_transparentPngBytes);
    }

    throw FlutterError('Unable to load asset: $key');
  }
}

class _FakeCheckIfShouldShowPinAlertUseCase implements CheckIfShouldShowPinAlertUseCase {
  @override
  Future<bool> call(String uid) async => false;
}

class _FakeCreateAutomaticBackupUseCase implements CreateAutomaticBackupUseCase {
  @override
  Future<void> call(String uid) async {}
}

class _FakeSetHideCreatePinAlertUseCase implements SetHideCreatePinAlertUseCase {
  @override
  Future<void> call(bool value) async {}
}

class _FakeGetCurrentUserUseCase implements GetCurrentUserUseCase {
  _FakeGetCurrentUserUseCase({
    required this.fakeUid,
    required this.fakeEmail,
  });

  final String fakeUid;
  final String? fakeEmail;

  @override
  String get uid => fakeUid;

  @override
  String? get email => fakeEmail;
}

class _TestHomeController extends HomeController {
  _TestHomeController({
    HomeState? seed,
    HomeEvent? emitEventOnInit,
    bool useSuperOnItemTapped = true,
  })  : _emitEventOnInit = emitEventOnInit,
        _useSuperOnItemTapped = useSuperOnItemTapped,
        super(
          checkIfShouldShowPinAlertUseCase: _FakeCheckIfShouldShowPinAlertUseCase(),
          createAutomaticBackupUseCase: _FakeCreateAutomaticBackupUseCase(),
          setHideCreatePinAlertUseCase: _FakeSetHideCreatePinAlertUseCase(),
          getCurrentUserUseCase: _FakeGetCurrentUserUseCase(fakeUid: 'uid', fakeEmail: seed?.userEmail),
        ) {
    if (seed != null) {
      emit(seed);
    }
  }

  final HomeEvent? _emitEventOnInit;
  final bool _useSuperOnItemTapped;

  bool clearEventCalled = false;
  bool? lastHideCreatePinValue;
  int? lastTappedIndex;

  @override
  Future<void> init() async {
    if (_emitEventOnInit != null) {
      emit(state.copyWith(event: _emitEventOnInit));
    }
  }

  @override
  Future<void> setHideCreatePinInfo(bool check) async {
    lastHideCreatePinValue = check;
  }

  @override
  void clearEvent() {
    clearEventCalled = true;
    super.clearEvent();
  }

  @override
  void onItemTapped(int index) {
    lastTappedIndex = index;
    if (_useSuperOnItemTapped) {
      super.onItemTapped(index);
    }
  }
}

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

class _TestListItemController extends ListItemController {
  _TestListItemController()
      : super(
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
        ) {
    emit(const ListItemState(
      listMode: ListViewModeEnum.list,
      allItems: <ItensEntity>[],
      filteredItems: <ItensEntity>[],
      hasDeletedItems: false,
    ));
  }

  @override
  Future<void> loadItems() async {
    // no-op: HomePage mounts ListItemPage, which calls loadItems in initState.
  }
}

class _FakeCreateItemUseCase implements CreateItemUseCase {
  @override
  Future<void> call(ItensEntity item, List<String> existingGroups) async {}
}

class _FakeLoadItemGroupsUseCase implements LoadItemGroupsUseCase {
  @override
  Future<List<String>> call() async => <String>[];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    if (getIt.isRegistered<HomeController>()) {
      getIt.unregister<HomeController>();
    }
    if (getIt.isRegistered<ListItemController>()) {
      getIt.unregister<ListItemController>();
    }
    if (getIt.isRegistered<AddItemController>()) {
      getIt.unregister<AddItemController>();
    }
  });

  final transparentImageBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wwAAgMBApZ5lZ0AAAAASUVORK5CYII=',
  );

  Widget _app() {
    return DefaultAssetBundle(
      bundle: _TestAssetBundle(Uint8List.fromList(transparentImageBytes)),
      child: const MaterialApp(home: HomePage()),
    );
  }

  void _register<T extends Object>(T instance) {
    if (getIt.isRegistered<T>()) {
      getIt.unregister<T>();
    }
    getIt.registerSingleton<T>(instance);
  }

  group('HomePage (widget)', () {
    testWidgets('renders base UI (app icon + bottom nav)', (tester) async {
      _register<HomeController>(
        _TestHomeController(
          seed: const HomeState(userEmail: 'a@b.com'),
        ),
      );
      _register<ListItemController>(_TestListItemController());

      await tester.pumpWidget(_app());
      await tester.pump(); // run post-frame init()

      expect(find.byKey(CoreKeys.sizedBoxIconApp), findsOneWidget);
      expect(find.byKey(CoreKeys.bottomNavigationBar), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('shows menu with userEmail when opening profile menu', (tester) async {
      _register<HomeController>(
        _TestHomeController(
          seed: const HomeState(userEmail: 'a@b.com'),
        ),
      );
      _register<ListItemController>(_TestListItemController());

      await tester.pumpWidget(_app());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.account_circle));
      await pumpModal(tester);

      expect(find.text('${CoreStrings.loggedInAs} a@b.com'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('shows loading overlay when status is HomeLoading', (tester) async {
      _register<HomeController>(
        _TestHomeController(
          seed: const HomeState(
            status: HomeLoading(),
            userEmail: 'a@b.com',
          ),
        ),
      );
      _register<ListItemController>(_TestListItemController());

      await tester.pumpWidget(_app());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('tapping list tab toggles viewMode and label group/list', (tester) async {
      _register<HomeController>(
        _TestHomeController(
          seed: const HomeState(userEmail: 'a@b.com'),
        ),
      );
      _register<ListItemController>(_TestListItemController());

      await tester.pumpWidget(_app());
      await tester.pump();

      expect(find.text(CoreStrings.group), findsOneWidget);
      expect(find.text(CoreStrings.list), findsNothing);

      await tester.tap(find.text(CoreStrings.group));
      await tester.pump();

      expect(find.text(CoreStrings.list), findsOneWidget);

      await tester.tap(find.text(CoreStrings.list));
      await tester.pump();

      expect(find.text(CoreStrings.group), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('shows create pin dialog when controller emits ShowPinDialogEvent (close button)', (tester) async {
      final controller = _TestHomeController(
        seed: const HomeState(userEmail: 'a@b.com'),
        emitEventOnInit: const ShowPinDialogEvent(),
      );
      _register<HomeController>(controller);
      _register<ListItemController>(_TestListItemController());

      await tester.pumpWidget(_app());
      await tester.pump(); // init -> emits event
      await pumpModal(tester);

      expect(find.byKey(CoreKeys.alertDialogCreatePin), findsOneWidget);
      expect(controller.clearEventCalled, isTrue);

      await tester.tap(find.byKey(CoreKeys.buttonCreatePin));
      await pumpModal(tester);

      expect(controller.lastHideCreatePinValue, isFalse);
      expect(find.byKey(CoreKeys.alertDialogCreatePin), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('create pin dialog config icon calls setHideCreatePinInfo and onItemTapped(2)', (tester) async {
      final controller = _TestHomeController(
        seed: const HomeState(userEmail: 'a@b.com'),
        emitEventOnInit: const ShowPinDialogEvent(),
        useSuperOnItemTapped: false,
      );
      _register<HomeController>(controller);
      _register<ListItemController>(_TestListItemController());

      await tester.pumpWidget(_app());
      await tester.pump();
      await pumpModal(tester);

      expect(find.byKey(CoreKeys.alertDialogCreatePin), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(
        find.descendant(
          of: find.byKey(CoreKeys.alertDialogCreatePin),
          matching: find.byIcon(CoreIcons.config),
        ),
      );
      await pumpModal(tester);

      expect(controller.lastHideCreatePinValue, isTrue);
      expect(controller.lastTappedIndex, 2);
      expect(find.byKey(CoreKeys.alertDialogCreatePin), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('tapping add tab shows AddItemPage', (tester) async {
      _register<HomeController>(
        _TestHomeController(
          seed: const HomeState(userEmail: 'a@b.com'),
        ),
      );
      _register<ListItemController>(_TestListItemController());
      _register<AddItemController>(
        AddItemController(
          createItemUseCase: _FakeCreateItemUseCase(),
          loadItemGroupsUseCase: _FakeLoadItemGroupsUseCase(),
          minSubmitDuration: Duration.zero,
          delay: (_) async {},
        ),
      );

      await tester.pumpWidget(_app());
      await tester.pump();

      await tester.tap(find.text(CoreStrings.add));
      await pumpModal(tester);

      expect(find.byType(AddItemPage), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  });
}
