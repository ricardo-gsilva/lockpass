import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/delete_item_bottom_sheet.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/item_details_bottom_sheet.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';

class ListItemGroupedWidget extends StatelessWidget {
  const ListItemGroupedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListItemController, ListItemState>(
      builder: (context, state) {
        final controller = context.read<ListItemController>();
        if (state.allGroups.isEmpty) return const SizedBox.shrink();

        final groupKeys =
            controller.buildTypesFromFiltered(state.filteredItems);

        return ListView.builder(
          shrinkWrap: true,
          itemCount: groupKeys.length,
          itemBuilder: (context, groupIndex) {
            final group = state.allGroups[groupIndex];
            final isExpanded = group.visible;
            final groupItems = state.filteredItems
                .where((item) => item.group == group.groupName)
                .toList();

            return Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 8, left: 12, right: 12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: CoreColors.titleItem,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () =>
                          context.read<ListItemController>().toggleGroup(group),
                      title: Text(
                        group.groupName.toString().toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 1.1),
                      ),
                      trailing: Icon(
                        isExpanded
                            ? Icons.remove_circle_outline
                            : Icons.add_circle_outline,
                        color: Colors.black54,
                      ),
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
                            key: ValueKey(item.id),
                            background: Container(color: CoreColors.deleteItem),
                            confirmDismiss: (direction) async {
                              final confirm = await showCustomBottomSheet<bool>(
                                context: context,
                                child: BlocProvider.value(
                                  value: controller,
                                  child: ConfirmationBottomSheet(
                                    title: CoreStrings.delete,
                                    description: CoreStrings.deleteThisLogin,
                                    confirmButtonText: "Mover para Lixeira",
                                    confirmButtonColor:
                                        CoreColors.buttonColorSecond,
                                    onConfirm: () {
                                      controller.moveToTrash(item);
                                    },
                                  ),
                                ),
                              );
                              return confirm ?? false;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4, left: 5, right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: CoreColors.cardItem
                                      .withValues(alpha: 0.5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2))
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20),
                                      title: TextCustom(text: item.service),
                                      subtitle: Text(item.login,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13)),
                                      trailing: const Icon(CoreIcons.visibility,
                                          size: 20),
                                      onTap: () {
                                        final decryptedItem =
                                            controller.decryptedPass(item);
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
                                    ),
                                    if (index < groupItems.length - 1)
                                      Divider(
                                          height: 1,
                                          indent: 20,
                                          endIndent: 20,
                                          color: Colors.black
                                              .withValues(alpha: 0.05)),
                                    if (index == groupItems.length - 1)
                                      const SizedBox(height: 10),
                                  ],
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
            );
          },
        );
      },
    );
  }
}
