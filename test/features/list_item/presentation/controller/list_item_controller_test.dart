import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
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
import 'package:mocktail/mocktail.dart';

class _MockLoadItemsUseCase extends Mock implements LoadItemsUseCase {}

class _MockEditItemUseCase extends Mock implements EditItemUseCase {}

class _MockDeleteItemUseCase extends Mock implements DeleteItemUseCase {}

class _MockMoveToTrashUseCase extends Mock implements MoveItemToTrashUseCase {}

class _MockRestoreItemUseCase extends Mock implements RestoreItemUseCase {}

class _MockDeleteItemPermanentlyUseCase extends Mock
    implements DeleteItemPermanentlyUseCase {}

class _MockReauthenticateWithCredentialsUseCase extends Mock
    implements ReauthenticateWithCredentialsUseCase {}

class _MockAuthenticateTrashWithPinUseCase extends Mock
    implements AuthenticateTrashWithPinUseCase {}

class _MockCheckHasDeletedItemsUseCase extends Mock
    implements CheckHasDeletedItemsUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(ListViewModeEnum.list);
  });

  late _MockLoadItemsUseCase loadItemsUseCase;
  late _MockEditItemUseCase editItemUseCase;
  late _MockDeleteItemUseCase deleteItemUseCase;
  late _MockMoveToTrashUseCase moveToTrashUseCase;
  late _MockRestoreItemUseCase restoreItemUseCase;
  late _MockDeleteItemPermanentlyUseCase deleteItemPermanentlyUseCase;
  late _MockReauthenticateWithCredentialsUseCase reauthenticateWithCredentialsUseCase;
  late _MockAuthenticateTrashWithPinUseCase authenticateTrashWithPinUseCase;
  late _MockCheckHasDeletedItemsUseCase checkHasDeletedItemsUseCase;

  ListItemController buildController() {
    return ListItemController(
      loadItemsUseCase: loadItemsUseCase,
      editItemUseCase: editItemUseCase,
      deleteItemUseCase: deleteItemUseCase,
      moveItemToTrashUseCase: moveToTrashUseCase,
      restoreItemUseCase: restoreItemUseCase,
      deleteItemPermanentlyUseCase: deleteItemPermanentlyUseCase,
      reauthenticateWithCredentialsUseCase: reauthenticateWithCredentialsUseCase,
      authenticateTrashWithPinUseCase: authenticateTrashWithPinUseCase,
      checkHasDeletedItemsUseCase: checkHasDeletedItemsUseCase,
    );
  }

  setUp(() {
    loadItemsUseCase = _MockLoadItemsUseCase();
    editItemUseCase = _MockEditItemUseCase();
    deleteItemUseCase = _MockDeleteItemUseCase();
    moveToTrashUseCase = _MockMoveToTrashUseCase();
    restoreItemUseCase = _MockRestoreItemUseCase();
    deleteItemPermanentlyUseCase = _MockDeleteItemPermanentlyUseCase();
    reauthenticateWithCredentialsUseCase = _MockReauthenticateWithCredentialsUseCase();
    authenticateTrashWithPinUseCase = _MockAuthenticateTrashWithPinUseCase();
    checkHasDeletedItemsUseCase = _MockCheckHasDeletedItemsUseCase();
  });

  group('ListItemController', () {
    blocTest<ListItemController, ListItemState>(
      'loadItems emits loading then loaded state',
      build: () {
        const itemA = ItensEntity(
          userId: 'uid',
          id: 1,
          group: 'G',
          service: 'A',
          login: 'l',
          password: 'p',
        );
        const itemB = ItensEntity(
          userId: 'uid',
          id: 2,
          group: 'G',
          service: 'B',
          login: 'l',
          password: 'p',
        );

        when(() => loadItemsUseCase.call(any())).thenAnswer(
          (_) async => (
            items: [itemA, itemB],
            sorted: [itemA, itemB],
            hasDeleted: true,
            mode: ListViewModeEnum.list,
          ),
        );

        return buildController();
      },
      act: (cubit) => cubit.loadItems(),
      expect: () => [
        const ListItemState(status: ListItemLoading()),
        ListItemState(
          status: const ListItemLoaded(),
          allItems: const [
            ItensEntity(
              userId: 'uid',
              id: 1,
              group: 'G',
              service: 'A',
              login: 'l',
              password: 'p',
            ),
            ItensEntity(
              userId: 'uid',
              id: 2,
              group: 'G',
              service: 'B',
              login: 'l',
              password: 'p',
            ),
          ],
          filteredItems: const [
            ItensEntity(
              userId: 'uid',
              id: 1,
              group: 'G',
              service: 'A',
              login: 'l',
              password: 'p',
            ),
            ItensEntity(
              userId: 'uid',
              id: 2,
              group: 'G',
              service: 'B',
              login: 'l',
              password: 'p',
            ),
          ],
          allGroups: const [
            GroupsEntity(groupName: 'G'),
          ],
          hasDeletedItems: true,
          listMode: ListViewModeEnum.list,
        ),
      ],
    );

    blocTest<ListItemController, ListItemState>(
      'loadItems emits AuthErrorType message on AuthErrorType exception',
      build: () {
        when(() => loadItemsUseCase.call(any()))
            .thenThrow(AuthErrorType.requiresRecentLogin);
        return buildController();
      },
      act: (cubit) => cubit.loadItems(),
      expect: () => [
        const ListItemState(status: ListItemLoading()),
        ListItemState(
          status: ListItemError(AuthErrorType.requiresRecentLogin.message),
        ),
      ],
    );

    blocTest<ListItemController, ListItemState>(
      'searchList with empty query restores sorted list and updates searchText',
      build: buildController,
      seed: () => const ListItemState(
        allItems: [
          ItensEntity(userId: 'u', id: 1, group: 'G', service: 'B', login: 'l', password: 'p'),
          ItensEntity(userId: 'u', id: 2, group: 'G', service: 'A', login: 'l', password: 'p'),
        ],
        filteredItems: [
          ItensEntity(userId: 'u', id: 1, group: 'G', service: 'B', login: 'l', password: 'p'),
        ],
        allGroups: [
          GroupsEntity(groupName: 'G'),
        ],
        isSearch: true,
        searchText: 'x',
      ),
      act: (cubit) => cubit.searchList(''),
      expect: () => [
        const ListItemState(
          allItems: [
            ItensEntity(userId: 'u', id: 1, group: 'G', service: 'B', login: 'l', password: 'p'),
            ItensEntity(userId: 'u', id: 2, group: 'G', service: 'A', login: 'l', password: 'p'),
          ],
          filteredItems: [
            ItensEntity(userId: 'u', id: 1, group: 'G', service: 'B', login: 'l', password: 'p'),
          ],
          allGroups: [
            GroupsEntity(groupName: 'G'),
          ],
          isSearch: false,
          searchText: 'x',
        ),
        const ListItemState(
          allItems: [
            ItensEntity(userId: 'u', id: 1, group: 'G', service: 'B', login: 'l', password: 'p'),
            ItensEntity(userId: 'u', id: 2, group: 'G', service: 'A', login: 'l', password: 'p'),
          ],
          filteredItems: [
            ItensEntity(userId: 'u', id: 2, group: 'G', service: 'A', login: 'l', password: 'p'),
            ItensEntity(userId: 'u', id: 1, group: 'G', service: 'B', login: 'l', password: 'p'),
          ],
          allGroups: [
            GroupsEntity(groupName: 'G'),
          ],
          isSearch: true,
          searchText: '',
        ),
      ],
    );

    blocTest<ListItemController, ListItemState>(
      'searchList filters items by query',
      build: buildController,
      seed: () => const ListItemState(
        allItems: [
          ItensEntity(userId: 'u', id: 1, group: 'Email', service: 'Gmail', login: 'l', password: 'p'),
          ItensEntity(userId: 'u', id: 2, group: 'Social', service: 'Twitter', login: 'x', password: 'p'),
        ],
      ),
      act: (cubit) => cubit.searchList('gma'),
      expect: () => [
        const ListItemState(
          allItems: [
            ItensEntity(userId: 'u', id: 1, group: 'Email', service: 'Gmail', login: 'l', password: 'p'),
            ItensEntity(userId: 'u', id: 2, group: 'Social', service: 'Twitter', login: 'x', password: 'p'),
          ],
          filteredItems: [
            ItensEntity(userId: 'u', id: 1, group: 'Email', service: 'Gmail', login: 'l', password: 'p'),
          ],
          allGroups: [
            GroupsEntity(groupName: 'Email'),
          ],
        ),
      ],
    );

    blocTest<ListItemController, ListItemState>(
      'toggleGroup expands selected group and collapses others',
      build: buildController,
      seed: () => const ListItemState(
        allGroups: [
          GroupsEntity(groupName: 'A', visible: false),
          GroupsEntity(groupName: 'B', visible: true),
        ],
      ),
      act: (cubit) => cubit.toggleGroup(const GroupsEntity(groupName: 'A')),
      expect: () => const [
        ListItemState(
          allGroups: [
            GroupsEntity(groupName: 'A', visible: true),
            GroupsEntity(groupName: 'B', visible: false),
          ],
        ),
      ],
    );

    blocTest<ListItemController, ListItemState>(
      'onFormChanged enables canSave only when item changed and valid',
      build: buildController,
      act: (cubit) {
        const original = ItensEntity(
          userId: 'u',
          id: 1,
          group: 'G',
          service: 'S',
          login: 'L',
          password: 'P',
        );
        const same = ItensEntity(
          userId: 'u',
          id: 1,
          group: 'G',
          service: 'S',
          login: 'L',
          password: 'P',
        );
        const changed = ItensEntity(
          userId: 'u',
          id: 1,
          group: 'G',
          service: 'S2',
          login: 'L',
          password: 'P',
        );

        cubit.onFormChanged(originalItem: original, currentItem: same, isFormValid: true);
        cubit.onFormChanged(originalItem: original, currentItem: changed, isFormValid: false);
        cubit.onFormChanged(originalItem: original, currentItem: changed, isFormValid: true);
      },
      expect: () => const [
        ListItemState(canSave: true),
      ],
    );

    blocTest<ListItemController, ListItemState>(
      'deleteItem emits action success after loadItems completes',
      build: () {
        const item = ItensEntity(userId: 'u', id: 1, group: 'G', service: 'S', login: 'L', password: 'P');
        when(() => deleteItemUseCase.call(item)).thenAnswer((_) async {});
        when(() => loadItemsUseCase.call(any())).thenAnswer(
          (_) async => (
            items: const <ItensEntity>[],
            sorted: const <ItensEntity>[],
            hasDeleted: false,
            mode: ListViewModeEnum.list,
          ),
        );
        return buildController();
      },
      act: (cubit) => cubit.deleteItem(
        const ItensEntity(userId: 'u', id: 1, group: 'G', service: 'S', login: 'L', password: 'P'),
      ),
      expect: () => [
        const ListItemState(status: ListItemLoading()),
        const ListItemState(status: ListItemLoaded()),
        const ListItemState(status: ListItemActionSuccess(CoreStrings.itemRemovedSuccess)),
      ],
    );

    blocTest<ListItemController, ListItemState>(
      'authenticateTrashMode uses pin branch when pinOrEmailAndPassword is false',
      build: () {
        when(() => authenticateTrashWithPinUseCase.call('12345'))
            .thenAnswer((_) async {});
        return buildController();
      },
      act: (cubit) => cubit.authenticateTrashMode(
        pinOrEmailAndPassword: false,
        pin: '12345',
      ),
      expect: () => const [
        ListItemState(status: ListItemLoading()),
        ListItemState(status: TrashAuthSuccess()),
      ],
    );

    blocTest<ListItemController, ListItemState>(
      'authenticateTrashMode uses credentials branch when pinOrEmailAndPassword is true',
      build: () {
        when(
          () => reauthenticateWithCredentialsUseCase.call(
            email: 'a@b.com',
            password: '123456',
          ),
        ).thenAnswer((_) async {});
        return buildController();
      },
      act: (cubit) => cubit.authenticateTrashMode(
        pinOrEmailAndPassword: true,
        email: 'a@b.com',
        password: '123456',
      ),
      expect: () => const [
        ListItemState(status: ListItemLoading()),
        ListItemState(status: TrashAuthSuccess()),
      ],
    );
  });
}
