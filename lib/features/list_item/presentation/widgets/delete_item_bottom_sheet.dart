import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/listItem/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/listItem/presentation/state/list_item_state.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';

class DeleteItemBottomSheet extends StatefulWidget {
  final ItensEntity item;
  const DeleteItemBottomSheet({required this.item, super.key});

  @override
  State<DeleteItemBottomSheet> createState() => _DeleteItemBottomSheetState();
}

class _DeleteItemBottomSheetState extends State<DeleteItemBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ListItemController, ListItemState>(
      listenWhen: (prev, curr) => prev.itemRemoved != curr.itemRemoved,
      listener: (context, state) {
        if (state.itemRemoved) {
          Navigator.of(context).pop(true);
          SnackUtils.showSuccess(
            context,
            content: state.successMessage
          );
        }
        if (!state.itemRemoved) {
          SnackUtils.showError(
            context,
            content: state.errorMessage
          );
        }
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: BlocBuilder<ListItemController, ListItemState>(
                      builder: (context, state) {
                        final controller = context.read<ListItemController>();
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const TextCustom(
                              text: CoreStrings.delete,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CoreColors.textSecundary,
                            ),
                            SizedBox(height: 16),
                            const TextCustom(
                              text: CoreStrings.deleteThisLogin,
                              fontSize: 16,
                              color: CoreColors.textSecundary,
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButtonCustom(
                                  colorText: CoreColors.textTertiary,
                                  text: CoreStrings.cancel,
                                  fontSize: 16,
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                ButtonCustom(
                                  colorText: CoreColors.textPrimary,
                                  backgroundButton:
                                      CoreColors.buttonColorSecond,
                                  text: CoreStrings.delete,
                                  fontSize: 16,
                                  onPressed: () {
                                    controller.deleteItem(widget.item);                                    
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
