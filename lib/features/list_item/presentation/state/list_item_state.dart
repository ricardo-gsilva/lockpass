import 'package:lockpass/features/home/presentation/enums/list_view_enum.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';

class ListItemState {
  // 🔹 Dados brutos
  final List<ItensEntity> allItems;
  final List<GroupsEntity> allGroups;

  // 🔹 Estado de visualização
  final ListViewEnum viewMode;
  final String? selectedType;
  final String? expandedTypeKey;
  final List<ItensEntity> filteredItems;
  final bool isLoading;
  final String errorMessage;
  final String successMessage;
  final bool showItemPassword;
  final bool isEditingItem;
  final bool isSavingItem;
  final bool isFormValid;
  final bool hasChanges;
  final ItensEntity? selectedItem;
  final String searchText;
  final bool itemRemoved;

  const ListItemState({
    this.allItems = const [],
    this.allGroups = const [],
    this.viewMode = ListViewEnum.list,
    this.selectedType,
    this.expandedTypeKey,
    this.filteredItems = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.successMessage = '',
    this.showItemPassword = false,
    this.hasChanges = false,
    this.isEditingItem = false,
    this.isFormValid = false,
    this.isSavingItem = false,
    this.selectedItem,
    this.searchText = '',
    this.itemRemoved = false
  });

  ListItemState copyWith({
    List<ItensEntity>? allItems,
    List<GroupsEntity>? allGroups,
    ListViewEnum? viewMode,
    String? selectedType,
    String? expandedTypeKey,
    List<ItensEntity>? filteredItems,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? showItemPassword,
    bool? isEditingItem,
    bool? isSavingItem,
    bool? isFormValid,
    bool? hasChanges,
    ItensEntity? selectedItem,
    String? searchText,
    bool? itemRemoved,
    
  }) {
    return ListItemState(
      allItems: allItems ?? this.allItems,
      allGroups: allGroups ?? this.allGroups,
      viewMode: viewMode ?? this.viewMode,
      selectedType: selectedType ?? this.selectedType,
      expandedTypeKey: expandedTypeKey ?? this.expandedTypeKey,
      filteredItems: filteredItems ?? this.filteredItems,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      showItemPassword: showItemPassword ?? this.showItemPassword,
      isEditingItem: isEditingItem ?? this.isEditingItem,
      isSavingItem: isSavingItem ?? this.isSavingItem,
      isFormValid: isFormValid ?? this.isFormValid,
      hasChanges: hasChanges ?? this.hasChanges,
      selectedItem: selectedItem ?? this.selectedItem,
      searchText: searchText ?? this.searchText,
      itemRemoved: itemRemoved ?? this.itemRemoved,
    );
  }
}