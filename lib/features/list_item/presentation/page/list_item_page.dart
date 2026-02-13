import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/features/listItem/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/home/presentation/enums/list_view_enum.dart';
import 'package:lockpass/features/listItem/presentation/state/list_item_state.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/features/listItem/presentation/widgets/list_item_grouped_widget.dart';
import 'package:lockpass/features/listItem/presentation/widgets/list_item_widget.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';

class ListItemPage extends StatefulWidget {
  final ListViewEnum viewMode;
  const ListItemPage({
    super.key,
    required this.viewMode,
  });

  @override
  State<ListItemPage> createState() => _ListItemPageState();
}

class _ListItemPageState extends State<ListItemPage> {
  DataBaseHelper db = DataBaseHelper();
  late final ListItemController listItemController;

  @override
  void initState() {
    super.initState();
    listItemController = getIt<ListItemController>();
    listItemController.loadItems();
  }

  Future showDelete(ItensEntity itens) async {
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
          );
        }),
      ),
    );
  }
}
