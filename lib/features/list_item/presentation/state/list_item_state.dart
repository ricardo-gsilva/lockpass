import 'package:equatable/equatable.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_status.dart';

class ListItemState extends Equatable {
  final ListItemStatus status;
  final List<ItensEntity> allItems;
  final List<GroupsEntity> allGroups;
  final List<ItensEntity> filteredItems;
  final bool isSearch;
  final ListViewModeEnum listMode;
  final bool hasDeletedItems;
  final bool canSave;
  final ItensEntity? selectedItem;
  final String searchText;

  const ListItemState({
    this.status = const ListItemInitial(),
    this.allItems = const [],
    this.allGroups = const [],
    this.filteredItems = const [],
    this.isSearch = false,
    this.listMode = ListViewModeEnum.list,
    this.hasDeletedItems = false,
    this.canSave = false,
    this.selectedItem,
    this.searchText = '',
  });

  static const _noValue = Object();

  ListItemState copyWith({
    ListItemStatus? status,
    List<ItensEntity>? allItems,
    List<GroupsEntity>? allGroups,
    List<ItensEntity>? filteredItems,
    bool? isSearch,
    ListViewModeEnum? listMode,
    bool? hasDeletedItems,
    bool? canSave,
    Object? selectedItem = _noValue,
    bool? pinOrEmailAndPassword,
    String? searchText,
  }) {
    return ListItemState(
      status: status ?? this.status,
      allItems: allItems ?? this.allItems,
      allGroups: allGroups ?? this.allGroups,
      filteredItems: filteredItems ?? this.filteredItems,
      isSearch: isSearch ?? this.isSearch,
      listMode: listMode ?? this.listMode,
      hasDeletedItems: hasDeletedItems ?? this.hasDeletedItems,
      canSave: canSave ?? this.canSave,
      selectedItem: selectedItem == _noValue?  this.selectedItem : selectedItem as ItensEntity?,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allItems,
        allGroups,
        filteredItems,
        isSearch,
        listMode,
        hasDeletedItems,
        canSave,
        selectedItem,
      ];
}
