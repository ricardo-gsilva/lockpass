// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/login_store.dart';
import 'package:lockpass/screens/create_pin.dart';
import 'package:lockpass/screens/reset_password.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class ResetPin extends StatelessWidget {
  const ResetPin({super.key});

  @override
  Widget build(BuildContext context) {
    LoginStore store = LoginStore();

    showResetPassword() {
      showDialog(
          context: context,
          builder: (_) {
            return Observer(builder: (context) {
              return const ResetPassword();
            });
          });
    }

    void showCreateNewPin() {
      showDialog(
          context: context,
          builder: (_) {
            return CreatePin(
              title: CoreStrings.newPin,
              newPin: true,
            );
          });
    }

    showInfo() {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              backgroundColor: CoreColors.secondColor,
              title: const TextCustom(
                key: CoreKeys.titleInfoResetPin,
                text: CoreStrings.info,
              ),
              content: const TextCustom(
                key: CoreKeys.infoResetPin,
                text: CoreStrings.needCreateNewPin,
              ),
              actions: [
                IconButtonCustom(
                  key: CoreKeys.arrowBackButtonInfoResetPin,
                  color: CoreColors.textPrimary,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: CoreIcons.arrowBack,
                ),
              ],
            );
          });
    }

    return Observer(builder: (context) {
      return AlertDialog(
        backgroundColor: CoreColors.primaryColor,
        title: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextCustom(
              key: CoreKeys.titleResetPin,
              text: CoreStrings.resetPin,
              color: CoreColors.textSecundary,
            ),
            IconButtonCustom(
                key: CoreKeys.infoButtonResetPin,
                icon: CoreIcons.info,
                onPressed: () {
                  showInfo();
                })
          ],
        ),
        content: Flex(
          mainAxisSize: MainAxisSize.min,
          direction: Axis.vertical,
          children: [
            TextFormFieldCustom(
              key: CoreKeys.textFormFieldEmailResetPin,
              controller: store.emailController,
              label: CoreStrings.login,
              colorTextLabel: CoreColors.textSecundary,
              cursorColor: CoreColors.textSecundary,
              colorTextInput: CoreColors.textSecundary,
              colorBorder: CoreColors.textSecundary,
              colorErrorText: CoreColors.textSecundary,
              validator: (value) {
                return store.validarEmail(value ?? '');
              },
            ),
            TextFormFieldCustom(
              key: CoreKeys.textFormFieldPasswordResetPin,
              controller: store.passwordController,
              label: CoreStrings.password,
              colorTextLabel: CoreColors.textSecundary,
              cursorColor: CoreColors.textSecundary,
              colorTextInput: CoreColors.textSecundary,
              colorBorder: CoreColors.textSecundary,
              colorErrorText: CoreColors.textSecundary,
              obscureText: store.obscureText,
              icon: IconButtonCustom(
                  key: CoreKeys.iconButtonVisibilityResetPin,
                  color: CoreColors.textSecundary,
                  icon: store.sufixIcon
                      ? CoreIcons.visibility
                      : CoreIcons.visibilityOff,
                  onPressed: () {
                    store.visibilityPass();
                  }),
            ),
            SizedBox(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButtonCustom(
                      key: CoreKeys.forgotPasswordResetPin,
                      onPressed: () {
                        showResetPassword();
                      },
                      text: CoreStrings.forgotPassword,
                      colorText: CoreColors.textSecundary)),
            ),
          ],
        ),
        actions: [
          IconButtonCustom(
            key: CoreKeys.arrowBackButtonResetPin,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: CoreIcons.arrowBack,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 15),
            child: ButtonCustom(
              key: CoreKeys.buttonSendResetPin,
              text: CoreStrings.send,
              colorText: CoreColors.textPrimary,
              fontSize: 16,
              backgroundButton: CoreColors.buttonColorSecond,
              onPressed: () async {
                store.confirmLogin = await store.login(
                    store.emailController.text, store.passwordController.text);
                if (store.confirmLogin) {
                  showCreateNewPin();
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
    });
  }
}
