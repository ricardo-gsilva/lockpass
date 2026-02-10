import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/features/listItem/presentation/state/list_item_state.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:lockpass/services/auth_service.dart';

class ListItemController extends Cubit<ListItemState> {
  final VaultService _vaultService;
  final AuthService _authService;
  final DataBaseHelper _db;

  ListItemController({
    required VaultService vaultService,
    required AuthService authService,
    required DataBaseHelper db,
  })  : _vaultService = vaultService,
        _authService = authService,
        _db = db,
        super(const ListItemState());

  // 🔹 UID seguro (sem exception)
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
        ..sort((a, b) => (a.service ?? '').compareTo(b.service ?? ''));

      emit(state.copyWith(
        allItems: items,
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

  // ===============================
  // FILTRO POR TIPO (LISTA SIMPLES)
  // ===============================
  void applyFilter(String? type) {
    final filtered = type == null
        ? state.allItems
        : state.allItems.where((e) => e.type == type).toList();

    filtered.sort(
      (a, b) => (a.service ?? '').compareTo(b.service ?? ''),
    );

    emit(state.copyWith(
      selectedType: type,
      filteredItems: filtered,
    ));
  }

  // ===============================
  // EXPAND / COLLAPSE GROUP
  // ===============================
  void toggleGroup(String typeKey) {
    emit(state.copyWith(
      expandedTypeKey:
          state.expandedTypeKey == typeKey ? null : typeKey,
    ));
  }

  // ===============================
  // SET DATA (caso venha de fora)
  // ===============================
  void setData({
    required List<ItensModel> itens,
    required List<TypeModel> types,
  }) {
    final sortedItems = [...itens]
      ..sort((a, b) => (a.service ?? '').compareTo(b.service ?? ''));

    emit(state.copyWith(
      allItems: itens,
      allTypes: types,
      filteredItems: sortedItems,
    ));
  }
}