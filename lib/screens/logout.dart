import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class LogoutApp extends StatelessWidget {
  const LogoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CoreColors.primaryColor,
      title: const TextCustom(
        key: CoreKeys.titleLogout,
        text: CoreStrings.logout,
        color: CoreColors.textSecundary,
      ),
      content: const TextCustom(
        key: CoreKeys.infoLogout,
        text: CoreStrings.wantLogout,
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
          text: CoreStrings.logout,
          backgroundButton: CoreColors.buttonColorSecond,
          colorText: CoreColors.textPrimary,
          onPressed: () {
            Navigator.popAndPushNamed(context, CoreStrings.nLogin);
          },
        )
      ],
    );
  }
}
