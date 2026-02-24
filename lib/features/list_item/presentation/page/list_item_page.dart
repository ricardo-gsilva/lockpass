import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/components/textformfield_custom.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_enum.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_status.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/security_validation_bottom_sheet.dart';
import 'package:lockpass/features/list_item/presentation/widgets/list_item_grouped_widget.dart';
import 'package:lockpass/features/list_item/presentation/widgets/list_item_widget.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';

class ListItemPage extends StatefulWidget {
  final ListViewEnum? viewMode;
  const ListItemPage({
    super.key,
    this.viewMode,
  });

  @override
  State<ListItemPage> createState() => _ListItemPageState();
}

class _ListItemPageState extends State<ListItemPage> {
  DataBaseHelper db = DataBaseHelper();
  late final ListItemController listItemController;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    listItemController = getIt<ListItemController>();
    listItemController.loadItems();
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus || _searchController.text.isNotEmpty) {
      listItemController.toggleSearchMode(true);
    } else {
      listItemController.toggleSearchMode(false);
    }
  }

  Future showDelete(ItensEntity item) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CoreColors.secondColor,
          title: const Text(CoreStrings.delete),
          content: const Text(CoreStrings.deleteThisLogin),
          actions: <Widget>[
            TextButtonCustom(
                colorText: CoreColors.textPrimary,
                text: CoreStrings.cancel,
                fontSize: 16,
                onPressed: () {
                  Navigator.of(context).pop(false);
                }),
            ButtonCustom(
              colorText: CoreColors.textPrimary,
              backgroundButton: CoreColors.buttonColorSecond,
              text: CoreStrings.delete,
              fontSize: 16,
              onPressed: () async {
                listItemController.deleteItem(item);
              },
            ),
          ],
        );
      },
    );
  }

  String _text(ListItemState state) {
    if (state.listMode == ListViewModeEnum.trash) {
      return "Modo Lixeira";
    }

    if (state.hasDeletedItems) {
      return "Mostrar itens Excluídos?";
    }

    return "Lixeira Vazia!";
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: listItemController,
      child: BlocListener<ListItemController, ListItemState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          switch (state.status) {
            case ListItemError(:final message):
              OverlayToast.showError(content: message);
              break;
            case ListItemActionSuccess(:final message):
              OverlayToast.showSuccess(content: message);
              break;
            default:
              break;
          }
        },
        child: BlocBuilder<ListItemController, ListItemState>(
          buildWhen: (previous, current) =>
              previous.filteredItems != current.filteredItems ||
              previous.allItems != current.allItems ||
              previous.isSearch != current.isSearch ||
              previous.listMode != current.listMode,
          builder: (context, state) {
            return GestureDetector(
              onTap: () => _searchFocusNode.unfocus(),
              child: Scaffold(
                body: Container(
                  color: state.listMode == ListViewModeEnum.list
                      ? CoreColors.secondColor
                      : CoreColors.backgroundModeTrash,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: CoreColors.primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(34),
                            bottomRight: Radius.circular(34),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormFieldCustom(
                                readOnly: state.allItems.isEmpty,
                                enabled: state.allItems.isNotEmpty,
                                label: CoreStrings.searchLogin,
                                colorTextLabel: CoreColors.textSecundary,
                                colorFocusedBorder: CoreColors.focusedBorder,
                                colorBorder: CoreColors.unselectBottomBar,
                                keyboardType: TextInputType.text,
                                controller: _searchController,
                                cursorColor: CoreColors.textSecundary,
                                colorTextInput: CoreColors.textSecundary,
                                focusNode: _searchFocusNode,
                                onChanged: (value) {
                                  listItemController.searchList(value);
                                },
                                icon: IconButtonCustom(
                                  color: CoreColors.textSecundary,
                                  icon: _searchFocusNode.hasFocus
                                      ? CoreIcons.close
                                      : CoreIcons.search,
                                  onPressed: () {
                                    _searchController.clear();
                                    listItemController.searchList('');
                                    _searchFocusNode.unfocus();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                children: [
                                  IconButtonCustom(
                                    color: CoreColors.textSecundary,
                                    icon: Icons.history,
                                    onPressed: () {
                                      _searchController.clear();
                                      listItemController.searchList('');
                                      _searchFocusNode.unfocus();
                                    },
                                  ),
                                  Expanded(
                                    child: TextCustom(
                                      text: _text(state),
                                      fontSize: 18,
                                      color: CoreColors.textSecundary,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Switch(
                                    activeThumbColor: CoreColors.primaryColor,
                                    activeTrackColor:
                                        CoreColors.buttonColorSecond,
                                    thumbColor: WidgetStateProperty.resolveWith(
                                        (states) {
                                      if (states
                                          .contains(WidgetState.disabled)) {
                                        return CoreColors.textTertiary
                                            .withValues(alpha: 0.4);
                                      }
                                      return CoreColors.primaryColor;
                                    }),
                                    trackColor: WidgetStateProperty.resolveWith(
                                        (states) {
                                      if (states
                                          .contains(WidgetState.disabled)) {
                                        return CoreColors.buttonColorPrimary
                                            .withValues(alpha: 0.3);
                                      }
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return CoreColors.buttonColorSecond;
                                      }
                                      return CoreColors.buttonColorPrimary;
                                    }),
                                    inactiveThumbColor: CoreColors.primaryColor,
                                    inactiveTrackColor:
                                        CoreColors.buttonColorPrimary,
                                    value: state.listMode ==
                                        ListViewModeEnum.trash,
                                    onChanged: state.hasDeletedItems
                                        ? (value) async {
                                            if (value) {
                                              final result =
                                                  await showCustomBottomSheet<
                                                      bool>(
                                                context: context,
                                                child:
                                                    const SecurityValidationBottomSheet(),
                                              );
                                              if (result == true) {
                                                listItemController.setViewMode(
                                                  ListViewModeEnum.trash,
                                                );
                                              }
                                            } else {
                                              listItemController.setViewMode(
                                                ListViewModeEnum.list,
                                              );
                                            }
                                          }
                                        : null,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.allItems.isNotEmpty &&
                          state.filteredItems.isEmpty &&
                          !state.isSearch)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: TextCustom(
                              text: "Nenhum item foi encontrado na busca!",
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: widget.viewMode == ListViewEnum.list
                              ? BlocProvider.value(
                                  value: listItemController,
                                  child: ListItemWidget(),
                                )
                              : BlocProvider.value(
                                  value: listItemController,
                                  child: ListItemGroupedWidget(),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
