import 'package:lockpass/features/home/presentation/enums/list_view_enum.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';

class ListItemState {
  // 🔹 Dados brutos
  final List<ItensModel> allItems;
  final List<TypeModel> allTypes;

  // 🔹 Estado de visualização
  final ListViewEnum viewMode;
  final String? selectedType;        // filtro ativo
  final String? expandedTypeKey;     // grupo expandido (modo grouped)

  // 🔹 Dados derivados (prontos para UI)
  final List<ItensModel> filteredItems;

  // 🔹 Estado operacional
  final bool isLoading;
  final String? errorMessage;

  const ListItemState({
    this.allItems = const [],
    this.allTypes = const [],
    this.viewMode = ListViewEnum.list,
    this.selectedType,
    this.expandedTypeKey,
    this.filteredItems = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ListItemState copyWith({
    List<ItensModel>? allItems,
    List<TypeModel>? allTypes,
    ListViewEnum? viewMode,
    String? selectedType,
    String? expandedTypeKey,
    List<ItensModel>? filteredItems,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ListItemState(
      allItems: allItems ?? this.allItems,
      allTypes: allTypes ?? this.allTypes,
      viewMode: viewMode ?? this.viewMode,
      selectedType: selectedType ?? this.selectedType,
      expandedTypeKey: expandedTypeKey ?? this.expandedTypeKey,
      filteredItems: filteredItems ?? this.filteredItems,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}