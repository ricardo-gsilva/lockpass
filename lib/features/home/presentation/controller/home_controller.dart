import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/paths/lockpass_paths.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/home/presentation/enums/home_tab_enum.dart';
import 'package:lockpass/features/home/presentation/enums/list_view_enum.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../state/home_state.dart';

class HomeController extends Cubit<HomeState> {
  final DataBaseHelper _db;
  final VaultService _vaultService;
  final AuthService _authService;
  final ItensRepository _itensRepository;

  HomeController({
    required DataBaseHelper db,
    required VaultService vaultService,
    required AuthService authService,
    required ItensRepository itensRepository,
  })  : _db = db,
        _vaultService = vaultService,
        _authService = authService,
        _itensRepository = itensRepository,
        super(const HomeState());

  // ============================
  // INIT (novo)
  // ============================
  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(
      userEmail: _authService.currentUserEmail,
    ));
    await _vaultService.initializeVaultEnvironment();
    await getPlatform();
    // await getPin();
    await getData();
    await createAutomaticBackup();
    emit(state.copyWith(isLoading: false));
    print("✅ HOME CONTROLLER INIT()");
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: '', successMessage: ''));
  }

  // 🔹 UID seguro (sem exception)
  String get _uid => _authService.currentUserId;

  // ============================
  // visibleSearch() (igual)
  // ============================
  void visibleSearch() {
    emit(state.copyWith(searchTextField: !state.searchTextField));
  }

  // ============================
  // getPin() (igual ao da store)
  // Agora: lê o bool pelo settings + verifica pin pelo vault
  // ============================
  Future<bool> getPin() async {
    // bool salvo: "não mostrar novamente o aviso"
    final hide = await _vaultService.getHideCreatePinInfo();

    if (hide) {
      emit(state.copyWith(showPinAlert: false, hideCreatePinInfo: true));
      return false;
    }

    final hasPin = await _vaultService.hasPin();
    final show = !hasPin;

    emit(state.copyWith(showPinAlert: show, hideCreatePinInfo: false));

    return show;
  }

  // ============================
  // checkBoxVisibleInfoPin(bool check) (igual)
  // Agora: grava apenas no settings
  // ============================
  Future<void> setHideCreatePinInfo(bool check) async {
    emit(state.copyWith(hideCreatePinInfo: check));
    await _vaultService.setHideCreatePinInfo(check);
    await getPin();
  }

  // ============================
  // visibleIconSearch(int index) (igual)
  // ============================
  bool visibleIconSearch(int index) {
    return index == 0;
  }

  // ============================
  // getPlatform() (mantido no controller só se você quiser)
  // MAS o ideal é usar vaultService.getStoragePath()
  // ============================
  Future<void> getPlatform() async {
    final path = await _vaultService.getStoragePath();
    emit(state.copyWith(path: path));
  }

  // ============================
  // getData() (igual)
  // ============================

  Future<void> getData() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      if (_uid.isEmpty) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final items = await _db.getItensByUser(_uid);

      final sortedItems = [...items]
        ..sort((a, b) => (a.service).compareTo(b.service));

      // final groups = sortedItems
      //     .map((e) => e.group)
      //     .whereType<String>()
      //     .toSet()
      //     .map((group) => GroupsEntity.fromMap({'groupName': group}))
      //     .toList();
      final groups = sortedItems
          .map((e) => e.group)
          .whereType<String>()
          .toSet()
          .toList()
        ..sort();

      final groupEntities =
          groups.map((name) => GroupsEntity(groupName: name)).toList();

      emit(state.copyWith(
        allItems: sortedItems,
        filteredItems: sortedItems,
        allGroups: groupEntities,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar itens',
      ));
    }
  }

  // ============================
  // searchList(String search) (igual)
  // ============================
  void searchList(String search) {
    final query = search.toLowerCase();

    final filtered = state.allItems.where((e) {
      return (e.service.toLowerCase().contains(query)) ||
          (e.login.toLowerCase().contains(query));
    }).toList();

    filtered.sort(
      (a, b) => (a.service).compareTo(b.service),
    );

    final updatedTypes = buildTypesFromFiltered(filtered);

    emit(state.copyWith(
      filteredItems: filtered,
      allGroups: updatedTypes,
    ));
  }

  // ============================
  // loadingWidget(List<ItensEntity> list) (igual)
  // ============================
  bool loadingWidget(List<ItensEntity> list) {
    // if (list.isEmpty && state.selectedIndex == 0) {
    if (list.isEmpty && state.currentTab == HomeTab.list) {
      return true;
    } else if (list.isNotEmpty && state.currentTab == HomeTab.list) {
      // } else if (list.isNotEmpty && state.selectedIndex == 0) {
      return false;
    } else {
      return false;
    }
  }

  // ============================
  // filterList(List<ItensEntity> itens, String search) (igual)
  // ============================
  void filterList(String search) {
    final searchLower = search.toLowerCase();

    // 🔹 filtra a partir da fonte única
    final filteredItems = state.allItems.where((item) {
      return (item.login).toLowerCase().contains(searchLower) ||
          (item.service).toLowerCase().contains(searchLower);
    }).toList();

    // // 🔹 extrai os tipos únicos a partir do resultado
    // final groups = filteredItems
    //     .map((e) => e.group)
    //     .whereType<String>()
    //     .toSet()
    //     .map((t) => GroupsEntity.fromMap({'type': t}))
    //     .toList();

    final previousGroups = state.allGroups;

    final groupNames = filteredItems
        .map((e) => e.group)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    final groups = groupNames.map((name) {
      final existing = previousGroups.firstWhere(
        (g) => g.groupName == name,
        orElse: () => GroupsEntity(groupName: name),
      );

      return GroupsEntity(
        groupName: name,
        visible: existing.visible,
      );
    }).toList();

    emit(state.copyWith(
      filteredItems: filteredItems,
      allGroups: groups,
    ));
  }

  Future<void> createAutomaticBackup() async {
    try {
      final dbDir = await LockPassPaths.dbDir;
      final dbFile = File(p.join(dbDir.path, 'lockpass_itens.db'));

      // Verifica se o banco existe antes de tentar copiar
      if (await dbFile.exists()) {
        final appDir = await getApplicationDocumentsDirectory();
        final backupFile = File(p.join(appDir.path, 'LPB_automatic.zip'));

        if (await backupFile.exists()) {
          await backupFile
              .delete(); // Remove o arquivo antigo antes de criar o novo
          print("🗑️ Backup antigo removido para atualização.");
        }

        // Cria o ZIP (sobrescrevendo o anterior se existir)
        await ZipFile.createFromDirectory(
          sourceDir: dbDir,
          zipFile: backupFile,
        );
        print("✅ Backup automático atualizado com sucesso.");
      }
    } catch (e) {
      // Como é silencioso, apenas logamos o erro para não atrapalhar o login do usuário
      print("❌ Erro ao gerar backup automático: $e");
    }
  }

  // ============================
  // screens() (antes retornava List<Widget>)
  // ⚠️ Agora NÃO existe no controller (correto)
  // ============================
  // A lista de telas deve ficar na HomePage, usando state.selectedIndex.
  // Então removemos screens().

  // ============================
  // requestPermission(Permission permission)
  // ⚠️ removido da controller
  // ============================
  // Isso é responsabilidade do VaultService.
  // (Home não deveria lidar com permission_handler)

  // ============================
  // onItemTapped(int index) (igual)
  // ============================
  void onItemTapped(int index) {
    final tab = _mapIndexToTab(index);
    if (tab == HomeTab.list) {
      final nextView = state.viewMode == ListViewEnum.list
          ? ListViewEnum.grouped
          : ListViewEnum.list;
      getData();
      emit(state.copyWith(
          currentTab: tab,
          selectedIndex: index,
          viewMode: nextView,
          searchTextField: false));
    } else {
      emit(state.copyWith(
        currentTab: tab,
        selectedIndex: index,
      ));
    }
  }

  HomeTab _mapIndexToTab(int index) {
    switch (index) {
      case 0:
        return HomeTab.list;
      case 1:
        return HomeTab.add;
      case 2:
        return HomeTab.config;
      default:
        return HomeTab.list;
    }
  }

  void toggleGroup(GroupsEntity group) {
    final updatedTypes = state.allGroups.map((group) {
      if (group.groupName == group.groupName) {
        // se já estava aberto → fecha
        return group.copyWith(visible: !group.visible);
      } else {
        // fecha todos os outros
        return group.copyWith(visible: false);
      }
    }).toList();

    emit(state.copyWith(
      allGroups: updatedTypes,
    ));
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

  List<GroupsEntity> updatedallGroups() {
    final groupedItems = <String, List<ItensEntity>>{};

    for (final item in state.filteredItems) {
      final key = item.group;
      groupedItems.putIfAbsent(key, () => []).add(item);
    }

    final groupKeys = groupedItems.keys.toList();

    return groupKeys.map((t) => GroupsEntity(groupName: t)).toList();
  }

  List<GroupsEntity> buildTypesFromFiltered(List<ItensEntity> items) {
    final groupedItems = <String, List<ItensEntity>>{};

    for (final item in items) {
      final key = item.group;
      groupedItems.putIfAbsent(key, () => []).add(item);
    }

    return groupedItems.keys.map((group) => GroupsEntity(groupName: group)).toList();
  }

  void toggleItemEditing() {
    emit(state.copyWith(isEditingItem: !state.isEditingItem));
  }

  void toggleItemPasswordVisibility([bool? value]) {
    emit(
      state.copyWith(
        showItemPassword: value ?? !state.showItemPassword,
      ),
    );
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

  ItensEntity decryptedPass(ItensEntity item) {
    final uid = _authService.currentUserId;

    if (uid.isNullOrBlank) {
      return item;
    }

    final passVisible = EncryptDecrypt.decrypt(item.password, uid);

    return item.copyWith(password: passVisible);
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

  void updateGroup(String group) {
    final updatedItem = state.selectedItem?.copyWith(group: group);

    emit(state.copyWith(
      selectedItem: updatedItem,
    ));
  }
}
