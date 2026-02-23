import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/services/pin_service.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/core/services/auth_service.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_status.dart';

class ListItemController extends Cubit<ListItemState> {
  final AuthService _authService;
  final ItensRepository _itensRepository;
  final PinService _pinService;

  ListItemController({
    required AuthService authService,
    required ItensRepository itensRepository,
    required PinService pinService,
  })  : _authService = authService,
        _itensRepository = itensRepository,
        _pinService = pinService,
        super(const ListItemState());

  String get _uid => _authService.currentUserId;

  Future<void> loadItems() async {
    if (_uid.isEmpty) {
      emit(state.copyWith(
        status: ListItemError('Usuário não autenticado'),
      ));
      return;
    }

    emit(state.copyWith(status: ListItemLoading()));

    try {
      final deleted = await _itensRepository.getDeletedItensByUser(_uid);
      final hasDeleted = deleted.isNotEmpty;
      final nextListMode = hasDeleted ? state.listMode : ListViewModeEnum.list;
      final items = nextListMode == ListViewModeEnum.trash
          ? deleted
          : await _itensRepository.getActiveItensByUser(_uid);

      final sortedItems = [...items]
        ..sort((a, b) => (a.service).compareTo(b.service));

      final groups = _buildGroups(sortedItems);

      emit(state.copyWith(
        allItems: items,
        filteredItems: sortedItems,
        allGroups: groups,
        hasDeletedItems: hasDeleted,
        status: const ListItemLoaded(),
        listMode: nextListMode,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError('Erro ao carregar itens'),
      ));
    }
  }

  void setViewMode(ListViewModeEnum mode) {
    emit(state.copyWith(listMode: mode));
    loadItems();
  }

  List<GroupsEntity> _buildGroups(List<ItensEntity> items) {
    final groups =
        items.map((e) => e.group).whereType<String>().toSet().toList()..sort();

    return groups.map((name) => GroupsEntity(groupName: name)).toList();
  }

  void onBottomSheetClosed() {
    emit(
      state.copyWith(
        selectedItem: null,
        canSave: false,
      ),
    );
  }

  List<GroupsEntity> buildTypesFromFiltered(List<ItensEntity> items) {
    final groupedItems = <String, List<ItensEntity>>{};

    for (final item in items) {
      final key = item.group;
      groupedItems.putIfAbsent(key, () => []).add(item);
    }

    return groupedItems.keys.map((t) => GroupsEntity(groupName: t)).toList();
  }

  // void toggleItemPasswordVisibility([bool? value]) {
  //   emit(
  //     state.copyWith(
  //       showItemPassword: value ?? !state.showItemPassword,
  //     ),
  //   );
  // }

  ItensEntity decryptedPass(ItensEntity item) {
    final uid = _authService.currentUserId;

    if (uid.isNullOrBlank) {
      return item;
    }

    final passVisible = EncryptDecrypt.decrypt(item.password, uid);

    return item.copyWith(password: passVisible);
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

  // void toggleItemEditing() {
  //   emit(state.copyWith(isEditingItem: !state.isEditingItem));
  // }
  
  Future<void> editItem(ItensEntity item) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      final uid = _authService.currentUserId;

      if (uid.isNullOrBlank) {
        emit(state.copyWith(
          status: ListItemError('Usuário não autenticado.'),
        ));
        return;
      }

      final encrypted = EncryptDecrypt.encrypt(item.password, uid);
      final itemToSave = item.copyWith(userId: uid, password: encrypted);

      await _itensRepository.updateItem(itemToSave);

      final updatedList = _updateItemInList(state.allItems, itemToSave);
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
    } catch (e) {
      emit(state.copyWith(
        status: ListItemError('Não foi possível atualizar o item.'),
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
      return e.service.toLowerCase().contains(query) ||
          e.login.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> deleteItem(ItensEntity item) async {
    emit(state.copyWith(status: const ListItemLoading()));

    try {
      await _itensRepository.deleteItem(item);

      await loadItems();

      emit(state.copyWith(
        status: ListItemActionSuccess('Item removido com sucesso'),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ListItemError('Erro ao excluir item! Tente novamente.'),
      ));
    }
  }

  void searchList(String search) {
    final query = search.trim().toLowerCase();
    emit(state.copyWith(isSearch: false));

    if (query.isEmpty) {
      final sorted = [...state.allItems]
        ..sort((a, b) => a.service.compareTo(b.service));

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

  void toggleSearchMode(bool hasFocus) {
    emit(state.copyWith(isSearch: hasFocus));
  }

  void enableTrashMode() {
    emit(state.copyWith(
      listMode: ListViewModeEnum.trash,
    ));
  }

  void disableTrashMode() {
    emit(state.copyWith(
      listMode: ListViewModeEnum.list,
    ));
  }

  Future<void> moveToTrash(ItensEntity item) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      await _itensRepository.softDeleteItem(item);
      await loadItems();

      emit(state.copyWith(
        status: ListItemActionSuccess('Item movido para lixeira'),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError('Erro ao mover item para lixeira'),
      ));
    }
  }

  Future<void> restoreItem(ItensEntity item) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      await _itensRepository.restoreItem(item);
      await loadItems();

      emit(state.copyWith(
        status: ItemRestoredSuccess(),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError('Erro ao restaurar item'),
      ));
    }
  }

  Future<void> deletePermanently(ItensEntity item) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      await _itensRepository.deleteItem(item);

      await loadItems();

      emit(state.copyWith(
        status: ItemDeletedPermanentlySuccess(),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ListItemError('Erro ao excluir permanentemente'),
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
      final isValid = await _authService.reauthenticateWithPassword(
        email: email,
        password: password,
      );

      if (!isValid) {
        emit(state.copyWith(status: TrashAuthFailure("Credenciais inválidas."),
        ));
        return;
      }

      emit(state.copyWith(status: TrashAuthSuccess()));
    } catch (_) {
      emit(state.copyWith(status: TrashAuthFailure("Erro ao validar credenciais."),
      ));
    }
  }

  Future<void> authenticateWithPin(String pin) async {
    emit(state.copyWith(status: ListItemLoading()));

    try {
      final isValid = await _pinService.validatePin(_uid, pin);

      if (!isValid) {
        emit(state.copyWith(status: TrashAuthFailure("PIN incorreto."),
        ));
        return;
      }

      emit(state.copyWith(status: TrashAuthSuccess()));
    } catch (_) {
      emit(state.copyWith(status: TrashAuthFailure("Erro ao validar PIN."),
      ));
    }
  }

  Future<void> checkIfHasDeletedItems() async {
    if (_uid.isEmpty) return;

    final hasDeleted = await _itensRepository.hasDeletedItensByUser(_uid);

    emit(state.copyWith(
      hasDeletedItems: hasDeleted,
    ));
  }
}
