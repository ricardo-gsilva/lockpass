import 'package:lockpass/features/home/presentation/enums/home_tab_enum.dart';
import 'package:lockpass/features/home/presentation/enums/list_view_enum.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';

class HomeState {
  final HomeTab currentTab;
  final List<ItensModel> allItems;
  final List<TypeModel> allTypes;
  final List<ItensModel> filteredItems;
  final ListViewEnum viewMode;
  final String? selectedType;
  final String? expandedTypeKey;
  final bool searchTextField;
  final String searchText;
  final int selectedIndex;
  final bool isLoading;
  final String errorMessage;
  final String successMessage;
  final bool showPinAlert;
  final bool hideCreatePinInfo;
  final String? path;
  final bool itemRemoved;
  final String? userEmail;
  final bool isEditingItem;
  final bool showItemPassword;
  final bool isSavingItem;
  final bool isFormValid;
  final bool hasChanges;
  final ItensModel? selectedItem;
  
  const HomeState({
    this.currentTab = HomeTab.list,
    this.allItems = const [],
    this.allTypes = const [],
    this.filteredItems = const [],
    this.viewMode = ListViewEnum.list,
    this.selectedType,
    this.expandedTypeKey,
    this.searchTextField = false,
    this.searchText = '',
    this.selectedIndex = 0,
    this.isLoading = false,
    this.errorMessage = '',
    this.successMessage = '',
    this.showPinAlert = false,
    this.hideCreatePinInfo = false,
    this.path,
    this.itemRemoved = false,
    this.userEmail = '',
    this.isEditingItem = false,
    this.isSavingItem = false,
    this.showItemPassword = false,
    this.isFormValid = false,
    this.hasChanges = false,
    this.selectedItem,
  });

  HomeState copyWith({
    HomeTab? currentTab,
    List<ItensModel>? allItems,
    List<TypeModel>? allTypes,
    List<ItensModel>? filteredItems,
    ListViewEnum? viewMode,
    String? selectedType,
    String? expandedTypeKey,
    bool? searchTextField,
    String? searchText,
    int? selectedIndex,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? showPinAlert,
    bool? hideCreatePinInfo,
    String? path,
    bool? itemRemoved,
    String? userEmail,
    bool? isEditingItem,
    bool? showItemPassword,
    bool? isSavingItem,
    bool? isFormValid,
    bool? hasChanges,
    ItensModel? selectedItem,
  }) {
    return HomeState(
      currentTab: currentTab ?? this.currentTab,
      allItems: allItems ?? this.allItems,
      allTypes: allTypes ?? this.allTypes,
      filteredItems: filteredItems ?? this.filteredItems,
      viewMode: viewMode ?? this.viewMode,
      selectedType: selectedType ?? this.selectedType,
      expandedTypeKey: expandedTypeKey ?? this.expandedTypeKey,
      searchTextField: searchTextField ?? this.searchTextField,
      searchText: searchText ?? this.searchText,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      showPinAlert: showPinAlert ?? this.showPinAlert,
      hideCreatePinInfo: hideCreatePinInfo ?? this.hideCreatePinInfo,
      path: path ?? this.path,
      itemRemoved: itemRemoved ?? this.itemRemoved,
      userEmail: userEmail ?? this.userEmail,
      isEditingItem: isEditingItem ?? this.isEditingItem,
      showItemPassword: showItemPassword ?? this.showItemPassword,
      isSavingItem: isSavingItem ?? this.isSavingItem,
      isFormValid: isFormValid ?? this.isFormValid,
      hasChanges: hasChanges ?? this.hasChanges,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }
}   