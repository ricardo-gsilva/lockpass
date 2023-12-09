import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/config_page_store.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigPageStore store = ConfigPageStore();

    return AlertDialog(
      backgroundColor: CoreColors.primaryColor,
      title: const TextCustom(
        key: CoreKeys.titleDeleteAccount,
        text: CoreStrings.deleteAccountTitle,
        color: CoreColors.textSecundary,
      ),
      content: const TextCustom(
        key: CoreKeys.infoDeleteAccount,
        text: CoreStrings.wantDeleteAccount,
        color: CoreColors.textSecundary,
      ),
      actions: [
        IconButtonCustom(
            key: CoreKeys.arrowBackButtonLogout,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: CoreIcons.arrowBack),
        ButtonCustom(
          key: CoreKeys.buttonLogout,
          text: CoreStrings.delete,
          colorText: CoreColors.textPrimary,
          backgroundButton: CoreColors.buttonColorSecond,
          onPressed: () {
            store.deleteAccount();
            Navigator.popAndPushNamed(context, CoreStrings.nLogin);
          },
        )
      ],
    );
  }
}
