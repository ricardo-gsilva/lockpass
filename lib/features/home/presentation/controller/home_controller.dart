import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import '../state/home_state.dart';

class HomeController extends Cubit<HomeState> {
  final DataBaseHelper _db;
  final VaultService _vaultService;

  HomeController({
    required DataBaseHelper db,
    required VaultService vaultService,
  }) : _db = db,
        _vaultService = vaultService,
  super(const HomeState());

  // ============================
  // INIT (novo)
  // ============================
  Future<void> init() async {
    await _vaultService.initializeVaultEnvironment();
    await getPlatform();
    await getPin();
    await getData();
    print("✅ HOME CONTROLLER INIT()");

  }

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
      emit(state.copyWith(
        showPinAlert: false,
        isChecked: true        
      ));
      return false;
    }
    
    final hasPin = await _vaultService.hasPin();
    final show = !hasPin;

    emit(state.copyWith(
      showPinAlert: show,
      isChecked: false
    ));

    return show;
  }

  // ============================
  // checkBoxVisibleInfoPin(bool check) (igual)
  // Agora: grava apenas no settings
  // ============================
  Future<void> setHideCreatePinInfo(bool check) async {
    emit(state.copyWith(isChecked: check));
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
    if (state.mode == 0) {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if(uid.isNullOrBlank) return;

      final list = await _db.getItensByUser(uid);

      emit(state.copyWith(
        listItens: list,
      ));

      // Mantém comportamento original
      filterList(list, state.searchText);

      if (list.isNotEmpty) {
        searchList(state.searchText);
      }
    }
  }

  // ============================
  // searchList(String search) (igual)
  // ============================
  List<ItensModel> searchList(String search) {
    emit(state.copyWith(searchText: search));
    filterList(state.listItens, search);
    return state.filterItens;
  }

  // ============================
  // loadingWidget(List<ItensModel> list) (igual)
  // ============================
  bool loadingWidget(List<ItensModel> list) {
    if (list.isEmpty && state.selectedIndex == 0) {
      return true;
    } else if (list.isNotEmpty && state.selectedIndex == 0) {
      return false;
    } else {
      return false;
    }
  }

  // ============================
  // filterList(List<ItensModel> itens, String search) (igual)
  // ============================
  void filterList(List<ItensModel> itens, String search) {
    final searchLower = search.toLowerCase();

    final filterItens = itens
        .where((e) => (e.login ?? '').toLowerCase().contains(searchLower))
        .toList();

    final filterType = <String>[];
    for (final item in filterItens) {
      filterType.add(item.type.toString());
    }

    final typeLenghtClear = filterType.toSet().toList();

    final types = <TypeModel>[];
    for (final t in typeLenghtClear) {
      types.add(TypeModel.fromMap({"type": t}));
    }

    final listTypes = types.toSet().toList();

    emit(state.copyWith(
      filterItens: filterItens,
      filterType: filterType,
      typeLenghtClear: typeLenghtClear,
      type: types,
      listTypes: listTypes,
    ));
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
  Future<void> onItemTapped(int index) async {
    int mode = state.mode;

    if (index > 0) {
      if (mode == 1 || mode == 0) {
        mode = 1;
      }
    } else if (index == 0 && mode == 0) {
      mode = 1;
    } else {
      mode = 0;
    }

    emit(state.copyWith(
      selectedIndex: index,
      mode: mode,
    ));

    if (mode == 0) {
      await getData();
    }

    filterList(state.listItens, state.searchText);
  }
}
