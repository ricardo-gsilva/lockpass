import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
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
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_status.dart';

class ListItemController extends Cubit<ListItemState> {
  final LoadItemsUseCase _loadItemsUseCase;
  final DecryptItemPasswordUseCase _decryptItemPasswordUseCase;
  final EditItemUseCase _editItemUseCase;
  final DeleteItemUseCase _deleteItemUseCase;
  final MoveItemToTrashUseCase _moveItemToTrashUseCase;
  final RestoreItemUseCase _restoreItemUseCase;
  final DeleteItemPermanentlyUseCase _deleteItemPermanentlyUseCase;
  final ReauthenticateWithCredentialsUseCase _reauthenticateWithCredentialsUseCase;
  final AuthenticateTrashWithPinUseCase _authenticateTrashWithPinUseCase;
  final CheckHasDeletedItemsUseCase _checkHasDeletedItemsUseCase;

  ListItemController({
    required LoadItemsUseCase loadItemsUseCase,
    required DecryptItemPasswordUseCase decryptItemPasswordUseCase,
    required EditItemUseCase editItemUseCase,
    required DeleteItemUseCase deleteItemUseCase,
    required MoveItemToTrashUseCase moveItemToTrashUseCase,
    required RestoreItemUseCase restoreItemUseCase,
    required DeleteItemPermanentlyUseCase deleteItemPermanentlyUseCase,
    required ReauthenticateWithCredentialsUseCase reauthenticateWithCredentialsUseCase,
    required AuthenticateTrashWithPinUseCase authenticateTrashWithPinUseCase,
    required CheckHasDeletedItemsUseCase checkHasDeletedItemsUseCase,
  })  : _loadItemsUseCase = loadItemsUseCase,
        _decryptItemPasswordUseCase = decryptItemPasswordUseCase,
        _editItemUseCase = editItemUseCase,
        _deleteItemUseCase = deleteItemUseCase,
        _moveItemToTrashUseCase = moveItemToTrashUseCase,
        _restoreItemUseCase = restoreItemUseCase,
        _deleteItemPermanentlyUseCase = deleteItemPermanentlyUseCase,
        _reauthenticateWithCredentialsUseCase = reauthenticateWithCredentialsUseCase,
        _authenticateTrashWithPinUseCase = authenticateTrashWithPinUseCase,
        _checkHasDeletedItemsUseCase = checkHasDeletedItemsUseCase,
        super(const ListItemState());

  Future<void> loadItems() async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      final result = await _loadItemsUseCase(state.listMode);

      print(result);

      final groups = _buildGroups(result.sorted);

      emit(state.copyWith(
        allItems: result.items,
        filteredItems: result.sorted,
        allGroups: groups,
        hasDeletedItems: result.hasDeleted,
        listMode: result.mode,
        status: const ListItemLoaded(),
      ));
    } on AuthErrorType catch (type) {
      emit(state.copyWith(
        status: ListItemError(type.message),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError(CoreStrings.loadItemsError),
      ));
    }
  }

  List<GroupsEntity> _buildGroups(List<ItensEntity> items) {
    final groups = items.map((e) => e.group).whereType<String>().toSet().toList()..sort();

    return groups.map((name) => GroupsEntity(groupName: name)).toList();
  }

  void setViewMode(ListViewModeEnum mode) {
    emit(state.copyWith(listMode: mode));
    loadItems();
  }

  void onBottomSheetClosed() {
    emit(
      state.copyWith(
        selectedItem: null,
        canSave: false,
      ),
    );
  }

  ItensEntity decryptedPass(ItensEntity item) {
    return _decryptItemPasswordUseCase(item);
  }

  void toggleGroup(GroupsEntity groups) {
    final updatedGroups = state.allGroups.map((group) {
      if (group.groupName == groups.groupName) {
        return group.copyWith(visible: !group.visible);
      } else {
        return group.copyWith(visible: false);
      }
    }).toList();

    emit(state.copyWith(
      allGroups: updatedGroups,
    ));
  }

  void onFormChanged({
    required ItensEntity originalItem,
    required ItensEntity currentItem,
    required bool isFormValid,
  }) {
    final hasChanges = originalItem != currentItem;
    final canSave = hasChanges && isFormValid;
    if (canSave == state.canSave) return;
    emit(state.copyWith(canSave: canSave));
  }

  Future<void> editItem(ItensEntity item) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      final updatedItem = await _editItemUseCase(item);

      final updatedList = _updateItemInList(state.allItems, updatedItem);

      final updatedFiltered = _applySearch(updatedList, state.searchText);

      final groupEntities = _buildGroups(updatedFiltered);

      emit(state.copyWith(
        selectedItem: item,
        allItems: updatedList,
        filteredItems: updatedFiltered,
        allGroups: groupEntities,
        canSave: false,
        status: ItemUpdatedSuccess(),
      ));
    } on AuthErrorType catch (type) {
      emit(state.copyWith(
        status: ListItemError(type.message),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError(CoreStrings.updateItemError),
      ));
    }
  }

  List<ItensEntity> _updateItemInList(
    List<ItensEntity> list,
    ItensEntity updatedItem,
  ) {
    return list.map((e) {
      if (e.id == updatedItem.id) return updatedItem;
      return e;
    }).toList();
  }

  List<ItensEntity> _applySearch(
    List<ItensEntity> list,
    String search,
  ) {
    if (search.isEmpty) return list;

    final query = search.toLowerCase();

    return list.where((e) {
      return e.service.toLowerCase().contains(query) || e.login.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> deleteItem(ItensEntity item) async {
    emit(state.copyWith(status: const ListItemLoading()));

    try {
      await _deleteItemUseCase(item);

      await loadItems();

      emit(state.copyWith(
        status: ListItemActionSuccess(CoreStrings.itemRemovedSuccess),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError(CoreStrings.deleteItemError),
      ));
    }
  }

  void searchList(String search) {
    final query = search.trim().toLowerCase();
    emit(state.copyWith(isSearch: false));

    if (query.isEmpty) {
      final sorted = [...state.allItems]..sort((a, b) => a.service.compareTo(b.service));

      final updatedTypes = buildTypesFromFiltered(sorted);

      emit(state.copyWith(
        filteredItems: sorted,
        allGroups: updatedTypes,
        isSearch: true,
        searchText: search,
      ));
      return;
    }

    final filtered = state.allItems.where((e) {
      return e.service.toLowerCase().contains(query) ||
          e.login.toLowerCase().contains(query) ||
          e.email.toLowerCase().contains(query) ||
          (e.site ?? '').toLowerCase().contains(query) ||
          e.group.toLowerCase().contains(query);
    }).toList();

    filtered.sort(
      (a, b) => a.service.compareTo(b.service),
    );

    final updatedTypes = buildTypesFromFiltered(filtered);

    emit(state.copyWith(
      filteredItems: filtered,
      allGroups: updatedTypes,
    ));
  }

  List<GroupsEntity> buildTypesFromFiltered(List<ItensEntity> items) {
    final groupedItems = <String, List<ItensEntity>>{};

    for (final item in items) {
      final key = item.group;
      groupedItems.putIfAbsent(key, () => []).add(item);
    }

    return groupedItems.keys.map((t) => GroupsEntity(groupName: t)).toList();
  }

  void toggleSearchMode(bool hasFocus) {
    emit(state.copyWith(isSearch: hasFocus));
  }

  Future<void> moveToTrash(ItensEntity item) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      await _moveItemToTrashUseCase(item);

      await loadItems();

      emit(state.copyWith(
        status: ListItemActionSuccess(CoreStrings.movedToTrashSuccess),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError(CoreStrings.moveToTrashError),
      ));
    }
  }

  Future<void> restoreItem(ItensEntity item) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      await _restoreItemUseCase(item);

      await loadItems();

      emit(state.copyWith(
        status: ItemRestoredSuccess(),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError(CoreStrings.restoreItemError),
      ));
    }
  }

  Future<void> deletePermanently(ItensEntity item) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      await _deleteItemPermanentlyUseCase(item);

      await loadItems();

      emit(state.copyWith(
        status: ItemDeletedPermanentlySuccess(),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError(CoreStrings.deletePermanentlyError),
      ));
    }
  }

  Future<void> authenticateTrashMode({
    required bool pinOrEmailAndPassword,
    String? pin,
    String? email,
    String? password,
  }) async {
    if (!pinOrEmailAndPassword) {
      await authenticateWithPin(pin ?? '');
    } else {
      await authenticateWithCredentials(
        email ?? '',
        password ?? '',
      );
    }
  }

  Future<void> authenticateWithCredentials(
    String email,
    String password,
  ) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      await _reauthenticateWithCredentialsUseCase(
        email: email,
        password: password,
      );

      emit(state.copyWith(
        status: TrashAuthSuccess(),
      ));
    } on AuthErrorType catch (type) {
      emit(state.copyWith(
        status: TrashAuthFailure(type.message),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: TrashAuthFailure(CoreStrings.credentialsValidationError),
      ));
    }
  }

  Future<void> authenticateWithPin(String pin) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      await _authenticateTrashWithPinUseCase(pin);

      emit(state.copyWith(
        status: TrashAuthSuccess(),
      ));
    } on AuthErrorType catch (type) {
      emit(state.copyWith(
        status: TrashAuthFailure(type.message),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: TrashAuthFailure(CoreStrings.pinValidationError),
      ));
    }
  }

  Future<void> checkIfHasDeletedItems() async {
    final hasDeleted = await _checkHasDeletedItemsUseCase();

    emit(state.copyWith(
      hasDeletedItems: hasDeleted,
    ));
  }
}