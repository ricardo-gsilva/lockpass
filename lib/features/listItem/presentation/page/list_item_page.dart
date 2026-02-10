import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/features/listItem/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/home/presentation/enums/list_view_enum.dart';
import 'package:lockpass/features/listItem/presentation/state/list_item_state.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/icon_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class ListItem1 extends StatefulWidget {
  // final int mode;
  // final List<ItensModel> itens;
  // final List<TypeModel> listTypes;
  // final VoidCallback? getData;

  const ListItem1(
      {
      // required this.mode,
      // required this.itens,
      // required this.listTypes,
      // this.getData,
      super.key});

  @override
  State<ListItem1> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem1> {
  DataBaseHelper db = DataBaseHelper();
  late final ListItemController listItemController;

  @override
  void initState() {
    super.initState();
    listItemController = getIt<ListItemController>();
    listItemController.loadItems();
  }

  // void showInfo(ItensModel itensModel) {
  //   showDialog(
  //       context: context,
  //       builder: (_) {
  //         return CardItemPage(itens: itensModel, listType: widget.listTypes);
  //       });
  // }

  Future showDelete(ItensModel itens) async {
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
              onPressed: () {
                db.deleteItem(itens);
                // widget.getData!();
                Navigator.of(context).pop(true);
                showToast(CoreStrings.itemRemoved,
                    context: context, position: StyledToastPosition.top);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: listItemController,
      child: BlocListener<ListItemController, ListItemState>(
        listenWhen: (previous, current) => false,
        listener: (context, state) => false,
        child: BlocBuilder<ListItemController, ListItemState>(
            builder: (context, state) {
          return Scaffold(
            backgroundColor: CoreColors.secondColor,
            body: Container(
              color: CoreColors.secondColor,
              child: state.viewMode == ListViewEnum.list
                  ? listView()
                  : groupedList(),
            ),
          );
        }),
      ),
    );
  }

  Widget listView() {
    return BlocBuilder<ListItemController, ListItemState>(
        builder: (context, state) {
      if (state.filteredItems.isEmpty) {
        return SizedBox.shrink();
      }

      return ListView.builder(
          itemCount: state.filteredItems.length,
          itemBuilder: (context, index) {
            final item = state.filteredItems[index];

            return Dismissible(
              key: Key(item.login ?? index.toString()),
              background: Container(
                color: CoreColors.deleteItem,
              ),
              confirmDismiss: (DismissDirection direction) async {
                return await showDelete(item);
              },
              onDismissed: (direction) {},
              child: ListTile(
                key: CoreKeys.listTileListItem,
                leading: IconCustom(
                  key: CoreKeys.iconLeadingListTile,
                  icon: CoreIcons.visibility,
                  color: CoreColors.textPrimary,
                ),
                title: TextCustom(
                  key: CoreKeys.titleLeadingListTile,
                  text: item.service.toString(),
                  color: CoreColors.textPrimary,
                ),
                subtitle: TextCustom(
                  key: CoreKeys.subTitleLeadingListTile,
                  text: item.login ?? '',
                ),
                onTap: () {
                  // showInfo(widget.itens[index]);
                  //TODO: Vai virar bottom sheet
                },
                onLongPress: () {
                  // showDelete(widget.itens[index]);
                  //TODO: Vai virar bottom sheet
                },
              ),
            );
          });
    });
  }

  Widget groupedList() {
    return BlocBuilder<ListItemController, ListItemState>(
      builder: (context, state) {
        if (state.allTypes.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.allTypes.length,
          itemBuilder: (context, groupIndex) {
            final type = state.allTypes[groupIndex];
            final isExpanded = state.expandedTypeKey == type.type;

            // Itens já filtrados pelo controller para esse grupo
            final groupItems = state.filteredItems
                .where((item) => item.type == type.type)
                .toList();

            return Padding(
              padding:
                  const EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: CoreColors.titleItem,
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(type.type.toString()),
                        ),
                        Visibility(
                          visible: isExpanded,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: groupItems.length,
                            itemBuilder: (context, index) {
                              final item = groupItems[index];

                              return Dismissible(
                                key: Key(item.login ?? '$groupIndex-$index'),
                                background: Container(
                                  color: CoreColors.deleteItem,
                                ),
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return await showDelete(item);
                                },
                                onDismissed: (_) {},
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                      color: CoreColors.cardItem,
                                    ),
                                    child: ListTile(
                                      title: TextCustom(
                                        text: item.service,
                                      ),
                                      subtitle: TextCustom(
                                        text: item.login ?? '',
                                      ),
                                      trailing: const Icon(
                                        CoreIcons.visibility,
                                      ),
                                      onTap: () {
                                        // TODO: Vai virar bottom sheet
                                      },
                                      onLongPress: () {
                                        // TODO: Vai virar bottom sheet
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      context
                          .read<ListItemController>()
                          .toggleGroup(type.type ?? '');
                    },
                    icon: isExpanded
                        ? const Icon(CoreIcons.visibleListLoginsOff)
                        : const Icon(CoreIcons.visibleListLogins),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
