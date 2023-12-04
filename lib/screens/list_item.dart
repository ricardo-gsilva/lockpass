import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/list_item_page_store.dart';
import 'package:lockpass/screens/card_item.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/icon_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class ListItem extends StatefulWidget {
  final int mode;
  final List<ItensModel> itens;
  final List<TypeModel> listTypes;
  final VoidCallback? getData;

  const ListItem(
      {required this.mode,
      required this.itens,
      required this.listTypes,
      this.getData,
      super.key});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  DataBaseHelper db = DataBaseHelper();
  ListItemStore store = ListItemStore();

  @override
  void didUpdateWidget(covariant ListItem oldWidget) {
    if (oldWidget.mode != widget.mode) {
      store.filterList(widget.itens, widget.itens);
    }
    super.didUpdateWidget(oldWidget);
  }

  void showInfo(ItensModel itensModel) {
    showDialog(
        context: context,
        builder: (_) {
          return CardItem(itens: itensModel, listType: widget.listTypes);
        });
  }

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
                widget.getData!();
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
    return Scaffold(
        backgroundColor: CoreColors.secondColor,
        body: Container(
            color: CoreColors.secondColor,
            child: widget.mode == 0 ? listView() : groupedList()),
    );
  }

  Widget listView() {
    return Observer(builder: (_) {
      return widget.itens.isEmpty? Container() :
      ListView.builder(
          itemCount: widget.itens.length,
          itemBuilder: (context, index) {
            store.filterList(widget.itens, widget.itens);
            return Dismissible(
              key: Key(widget.itens[index].login ?? ''),
              background: Container(
                color: CoreColors.deleteItem,
              ),
              confirmDismiss: (DismissDirection direction) async {
                return await showDelete(widget.itens[index]);
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
                  text: store.alphabetList[index].service.toString(),
                  color: CoreColors.textPrimary,
                ),
                subtitle: TextCustom(
                  key: CoreKeys.subTitleLeadingListTile,
                  text: widget.itens[index].login ?? '',
                ),
                onTap: () {
                  showInfo(widget.itens[index]);
                },
                onLongPress: () {
                  showDelete(widget.itens[index]);
                },
              ),
            );
          });
    });
  }

  Widget groupedList() {
    return Observer(builder: (_) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.listTypes.length,
          itemBuilder: (context, index) {
            store.filterList(widget.listTypes, widget.itens);
            return Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 2, left: 10, right: 10),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  color: CoreColors.titleItem,
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(store.alphabetList[index].type.toString()),
                          ),
                          Observer(builder: (context) {
                            return Visibility(
                                visible: widget.listTypes[index].visible!,
                                child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: store.listDynamic.length,
                                    itemBuilder: (context, index) {
                                      return Dismissible(
                                          key: Key(
                                              widget.itens[index].login ?? ''),
                                          background: Container(
                                            color: CoreColors.deleteItem,
                                          ),
                                          confirmDismiss: (DismissDirection direction) async {
                                            return await showDelete(store.listDynamic[index]);
                                          },
                                          onDismissed: (direction) {},
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 4),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(5),
                                                        bottomRight:
                                                            Radius.circular(5)),
                                                color: CoreColors.cardItem,
                                              ),
                                              child: ListTile(
                                                title: TextCustom(
                                                    text: store
                                                        .listDynamic[index]
                                                        .service),
                                                subtitle: TextCustom(
                                                    text: (store
                                                        .listDynamic[index]
                                                        .login!)),
                                                trailing: const Icon(
                                                    CoreIcons.visibility),
                                                onTap: () => showInfo(
                                                    store.listDynamic[index]),
                                                onLongPress: () => showDelete(
                                                    store.listDynamic[index]),
                                              ),
                                            ),
                                          ));
                                    }));
                          })
                        ]),
                  ),
                  trailing: Observer(
                    builder: (context) {
                      return IconButton(
                          onPressed: () {
                            store.changeBool(store.alphabetList[index], widget.listTypes);
                            store.listFilter(
                                widget.listTypes[index].type.toString(),
                                widget.itens);
                            setState(() {});
                          },
                          icon: widget.listTypes[index].visible == false? 
                          const Icon(CoreIcons.visibleListLogins) : 
                          const Icon(CoreIcons.visibleListLoginsOff),
                );
                    }
                  ),
              )));
          });
    });
  }
  
}
