// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/login_store.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    LoginStore store = LoginStore();

    showInfo() {
      showDialog(
          context: context,
          builder: (_) {
            return InfoDialog(
              key: CoreKeys.infoDialogResetPassword,
              title: CoreStrings.info,
              content: CoreStrings.receivePasswordResetLink,
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
    }

    return AlertDialog(
      backgroundColor: CoreColors.primaryColor,
      title: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TextCustom(
            key: CoreKeys.titleResetPassword,
            text: CoreStrings.resetPassword,
            color: CoreColors.textSecundary,
          ),
          IconButtonCustom(
              key: CoreKeys.infoButtonResetPassword,
              icon: CoreIcons.info,
              onPressed: () {
                showInfo();
              })
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormFieldCustom(
          key: CoreKeys.textFormFieldEmailResetPassword,
          cursorColor: CoreColors.textSecundary,
          colorTextInput: CoreColors.textSecundary,
          label: CoreStrings.emailRegistered,
          controller: store.resetPasswordController,
          colorTextLabel: Colors.white,
          colorIcon: Colors.white,
          colorBorder: CoreColors.textSecundary,
          colorErrorText: CoreColors.textSecundary,
          icons: CoreIcons.person,
          validator: (value) {
            return store.validarEmail(value ?? '');
          },
        ),
      ),
      actions: [
        IconButtonCustom(
          key: CoreKeys.arrowBackInfoResetPassword,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: CoreIcons.arrowBack,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 15),
          child: ButtonCustom(
            key: CoreKeys.buttonSendResetPassword,
            backgroundButton: CoreColors.buttonColorSecond,
            text: CoreStrings.send,
            colorText: CoreColors.textPrimary,
            fontSize: 16,
            onPressed: () async {
              store.resetPass =
                  await store.resetPassword(store.resetPasswordController.text);
              if (store.resetPass) {
                showToast(
                    duration: const Duration(seconds: 5),
                    context: context,
                    store.exception);
                Navigator.of(context).pop();
              } else {
                showToast(
                    duration: const Duration(seconds: 3),
                    context: context,
                    store.exception);
              }
            },
          ),
        )
      ],
    );
  }
}
