import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/listItem/presentation/state/list_item_state.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/services/auth_service.dart';

class ListItemController extends Cubit<ListItemState> {
  final AuthService _authService;
  final DataBaseHelper _db;
  final ItensRepository _itensRepository;

  ListItemController({
    required AuthService authService,
    required DataBaseHelper db,
    required ItensRepository itensRepository,
  })  : _authService = authService,
        _db = db,
        _itensRepository = itensRepository,
        super(const ListItemState());

  String get _uid => _authService.currentUserId;

  // ===============================
  // LOAD INICIAL
  // ===============================
  Future<void> loadItems() async {
    if (_uid.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Usuário não autenticado',
      ));
      return;
    }

    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final items = await _db.getItensByUser(_uid);

      final sortedItems = [...items]
        ..sort((a, b) => (a.service).compareTo(b.service));

        final groups = sortedItems
          .map((e) => e.group)
          .whereType<String>()
          .toSet()
          .toList()
        ..sort();

      final groupEntities =
          groups.map((name) => GroupsEntity(groupName: name)).toList();

      emit(state.copyWith(
        allItems: items,
        allGroups: groupEntities,
        filteredItems: sortedItems,
        isLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar itens',
      ));
    }
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: '', successMessage: ''));
  }

  // ===============================
  // FILTRO POR TIPO (LISTA SIMPLES)
  // ===============================
  void applyFilter(String? type) {
    final filtered = type == null
        ? state.allItems
        : state.allItems.where((e) => e.group == type).toList();

    filtered.sort(
      (a, b) => (a.service).compareTo(b.service),
    );

    emit(state.copyWith(
      selectedType: type,
      filteredItems: filtered,
    ));
  }

  // ===============================
  // EXPAND / COLLAPSE GROUP
  // ===============================
  // void toggleGroup(String typeKey) {
  //   emit(state.copyWith(
  //     expandedTypeKey:
  //         state.expandedTypeKey == typeKey ? null : typeKey,
  //   ));
  // }

  // ===============================
  // SET DATA (caso venha de fora)
  // ===============================
  void setData({
    required List<ItensEntity> itens,
    required List<GroupsEntity> types,
  }) {
    final sortedItems = [...itens]
      ..sort((a, b) => (a.service).compareTo(b.service));

    emit(state.copyWith(
      allItems: itens,
      allGroups: types,
      filteredItems: sortedItems,
    ));
  }

  ///Efetuanbdo teste
  ///
  List<GroupsEntity> buildTypesFromFiltered(List<ItensEntity> items) {
    final groupedItems = <String, List<ItensEntity>>{};

    for (final item in items) {
      final key = item.group;
      groupedItems.putIfAbsent(key, () => []).add(item);
    }

    return groupedItems.keys.map((t) => GroupsEntity(groupName: t)).toList();
  }

  void toggleItemPasswordVisibility([bool? value]) {
    emit(
      state.copyWith(
        showItemPassword: value ?? !state.showItemPassword,
      ),
    );
  }

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
        // se já estava aberto → fecha
        return group.copyWith(visible: !group.visible);
      } else {
        // fecha todos os outros
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
    final hasChanges = originalItem.group != currentItem.group ||
        originalItem.service != currentItem.service ||
        originalItem.site != currentItem.site ||
        originalItem.email != currentItem.email ||
        originalItem.login != currentItem.login ||
        originalItem.password != currentItem.password;

    emit(state.copyWith(
      isFormValid: isFormValid,
      hasChanges: hasChanges,
    ));
  }

  void toggleItemEditing() {
    emit(state.copyWith(isEditingItem: !state.isEditingItem));
  }

  Future<void> editItem(ItensEntity item) async {
    emit(state.copyWith(
      isLoading: true,
      successMessage: '',
      errorMessage: '',
    ));

    try {
      final uid = _authService.currentUserId;

      if (uid.isNullOrBlank) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Usuário não autenticado.',
        ));
        return;
      }

      final encrypted = EncryptDecrypt.encrypt(item.password, uid);

      final itemToSave = item.copyWith(userId: uid, password: encrypted);

      // await _db.updateItem(itemToSave);
      await _itensRepository.updateItem(itemToSave);

      final updatedList = _updateItemInList(state.allItems, itemToSave);

      final updatedFiltered = _applySearch(updatedList, state.searchText);

      emit(state.copyWith(
        selectedItem: item,
        isLoading: false,
        successMessage: 'Item atualizado com sucesso!',
        isEditingItem: false,
        hasChanges: false,
        allItems: updatedList,
        filteredItems: updatedFiltered,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Não foi possível atualizar o item.',
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
    try {
      emit(state.copyWith(isLoading: true, errorMessage: ''));

      await _db.deleteItem(item);

      final updatedAllItems = state.allItems
          .where((e) => e.id != item.id) // ajuste se o campo não for `id`
          .toList();

      final updatedFilteredItems = updatedAllItems.where((e) {
        return state.filteredItems.isEmpty ||
            state.filteredItems.any((f) => f.id == e.id);
      }).toList();

      emit(state.copyWith(
        allItems: updatedAllItems,
        filteredItems: updatedFilteredItems,
        isLoading: false,
        successMessage: 'Item removido com sucesso',
        itemRemoved: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao excluir item! Tente novamente.',
        itemRemoved: false,
      ));
    }
  }
}
