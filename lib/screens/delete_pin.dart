import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/config_page_store.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

// ignore: must_be_immutable
class DeletePin extends StatelessWidget {
  VoidCallback removePin;
  DeletePin({required this.removePin, super.key});
  ConfigPageStore store = ConfigPageStore();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: CoreColors.primaryColor,
        title: const TextCustom(
          key: CoreKeys.titleDeletePin,
          text: CoreStrings.deletePin,
          fontSize: 18,
          color: CoreColors.textSecundary,
        ),
        content: const TextCustom(
          key: CoreKeys.subTitleDeletePin,
          text: CoreStrings.wantDeleteRegisteredPin,
          fontSize: 15,
          color: CoreColors.textSecundary,
        ),
        actions: [
          TextButtonCustom(
            key: CoreKeys.cancelDeletePin,
              text: CoreStrings.cancel,
              colorText: CoreColors.textTertiary,
              fontSize: 16,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: ButtonCustom(
              key: CoreKeys.buttonDeletePin,
              text: CoreStrings.delete,
              fontSize: 16,
              colorText: CoreColors.textPrimary,
              backgroundButton: CoreColors.buttonColorSecond,
              onPressed: () {
                removePin();
                Navigator.pop(context);
                showToast(CoreStrings.pinRemoved,
                    context: context, position: StyledToastPosition.top);
              },
            ),
          ),
        ]);
  }
}
