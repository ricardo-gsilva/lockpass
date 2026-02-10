import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/core/utils/ui/bottom_sheet_utils.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/features/home/presentation/widgets/delete_item_bottom_sheet.dart';
import 'package:lockpass/widgets/icon_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeController, HomeState>(builder: (context, state) {
      final controller = context.read<HomeController>();
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
                final confirm = await showCustomBottomSheet(
                  context: context,
                  child: BlocProvider.value(
                    value: controller,
                    child: DeleteItemBottomSheet(
                      item: item,
                    ),
                  ),
                );
                return confirm ?? false;
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
                  showCustomBottomSheet(
                    context: context,
                    child: BlocProvider.value(
                      value: controller,
                      child: DeleteItemBottomSheet(
                        item: item,
                      ),
                    ),
                  );
                  //TODO: Vai virar bottom sheet
                },
              ),
            );
          });
    });
  }
}
