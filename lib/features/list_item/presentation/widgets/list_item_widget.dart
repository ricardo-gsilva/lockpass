import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/delete_item_bottom_sheet.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/item_details_bottom_sheet.dart';
import 'package:lockpass/core/ui/components/icon_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListItemController, ListItemState>(
        builder: (context, state) {
      final controller = context.read<ListItemController>();

      if(state.filteredItems.isEmpty){
              return const Center(
                child: TextCustom(
                  text: CoreStrings.noItemsFound,
                ),
              );
            }

      return ListView.builder(
          itemCount: state.filteredItems.length,
          itemBuilder: (context, index) {
            final item = state.filteredItems[index];            
              
            if (state.listMode == ListViewModeEnum.trash) {
              return ListTile(
                key: ValueKey(item.id),
                leading: IconCustom(
                  icon: CoreIcons.delete,
                  color: CoreColors.textPrimary.withValues(alpha: 0.8),
                ),
                title: TextCustom(
                  text: item.service,
                  color: CoreColors.textPrimary,
                ),
                subtitle: TextCustom(
                  text: item.login,
                  fontSize: 16,
                  color: CoreColors.textPrimary,
                ),
                onTap: () async {
                  final decryptedItem = controller.decryptedPass(item);
                  showCustomBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    child: BlocProvider.value(
                      value: controller,
                      child: ItemDetailsBottomSheet(
                        item: decryptedItem,
                      ),
                    ),
                  ).whenComplete(() {
                    controller.onBottomSheetClosed();
                  });
                },
              );
            }

            return Dismissible(
              key: ValueKey(item.id),
              background: Container(
                color: CoreColors.deleteItem,
              ),
              confirmDismiss: (DismissDirection direction) async {
                final bool? shouldDelete = await showCustomBottomSheet<bool>(
                  context: context,
                  child: BlocProvider.value(
                    value: controller,
                    child: ConfirmationBottomSheet(
                      title: CoreStrings.delete,
                      description: CoreStrings.deleteThisLogin,
                      confirmButtonText: CoreStrings.moveToTrash,
                      onConfirm: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                );
                if (shouldDelete == true) {
                  controller.moveToTrash(item);
                  return true;
                }

                return false;
              },
              onDismissed: (direction) {},
              child: ListTile(
                key: CoreKeys.listTileListItem,
                leading: IconCustom(
                  key: CoreKeys.iconLeadingListTile,
                  icon: state.listMode == ListViewModeEnum.trash
                      ? CoreIcons.delete
                      : CoreIcons.visibility,
                  color: CoreColors.textPrimary.withValues(alpha: 0.8),
                ),
                title: TextCustom(
                  key: CoreKeys.titleLeadingListTile,
                  text: item.service.toString(),
                  color: CoreColors.textPrimary,
                ),
                subtitle: TextCustom(
                  key: CoreKeys.subTitleLeadingListTile,
                  text: item.login,
                  fontSize: 16,
                  color: CoreColors.textPrimary,
                ),
                onTap: () async {
                  final decryptedItem = controller.decryptedPass(item);
                  showCustomBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    child: BlocProvider.value(
                      value: controller,
                      child: ItemDetailsBottomSheet(
                        item: decryptedItem,
                      ),
                    ),
                  ).whenComplete(() {
                    controller.onBottomSheetClosed();
                  });
                },
                onLongPress: () {
                  showCustomBottomSheet(
                    context: context,
                    child: BlocProvider.value(
                      value: controller,
                      child: ConfirmationBottomSheet(
                        title: CoreStrings.delete,
                        description: CoreStrings.deleteThisLogin,
                        confirmButtonText: CoreStrings.moveToTrash,
                        confirmButtonColor: CoreColors.buttonColorSecond,
                        onConfirm: () {
                          controller.moveToTrash(item);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          });
    });
  }
}
