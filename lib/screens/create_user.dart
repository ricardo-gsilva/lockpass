// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/login_store.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/components/loading_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  LoginStore store = LoginStore();

  showInfo() {
    showDialog(
        context: context,
        builder: (_) {
          return InfoDialog(
            key: CoreKeys.alertDialogInfoCreateUser,
            title: CoreStrings.info,
            content: CoreStrings.infoEmailInvalid,
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return AlertDialog(
        backgroundColor: CoreColors.primaryColor,
        title: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextCustom(
              key: CoreKeys.titleCreateUser,
              text: CoreStrings.register1,
              color: CoreColors.textSecundary,
            ),
            IconButtonCustom(
                key: CoreKeys.infoButtonCreateUser,
                icon: CoreIcons.info,
                onPressed: () {
                  showInfo();
                })
          ],
        ),
        content: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormFieldCustom(
                  key: CoreKeys.formFieldEmailCreateUser,
                  label: CoreStrings.email,
                  controller: store.emailController,
                  cursorColor: CoreColors.textSecundary,
                  colorTextInput: CoreColors.textSecundary,
                  colorTextLabel: CoreColors.textSecundary,
                  colorBorder: CoreColors.textSecundary,
                  colorErrorText: CoreColors.textSecundary,
                  colorIcon: CoreColors.textSecundary,
                  icons: CoreIcons.person,
                  validator: (value) {
                    return store.validarEmail(value ?? '');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextFormFieldCustom(
                  key: CoreKeys.formFieldPasswordCreateUser,
                  label: CoreStrings.password,
                  controller: store.passwordController,
                  cursorColor: CoreColors.textSecundary,
                  colorTextInput: CoreColors.textSecundary,
                  colorTextLabel: CoreColors.textSecundary,
                  colorIcon: CoreColors.textSecundary,
                  colorBorder: CoreColors.textSecundary,
                  obscureText: store.obscureText,
                  icon: IconButtonCustom(
                      key: CoreKeys.iconButtonVisibilityCreateUser,
                      color: CoreColors.textSecundary,
                      icon: store.sufixIcon
                          ? CoreIcons.visibility
                          : CoreIcons.visibilityOff,
                      onPressed: () {
                        store.visibilityPass();
                      }),
                ),
              ),
            ]),
        actions: [
          IconButtonCustom(
            key: CoreKeys.arrowBackButtonCreateUser,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: CoreIcons.arrowBack,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 15),
            child: ButtonCustom(
              key: CoreKeys.buttonCreateUser,
              backgroundButton: CoreColors.buttonColorSecond,
              text: CoreStrings.register2,
              colorText: CoreColors.textPrimary,
              fontSize: 16,
              onPressed: () async {
                LoadingCustom().startLoading(context);
                Future.delayed(const Duration(seconds: 2), () async {
                  if (store.checkField()) {
                    store.userCreate = await store.register(
                        store.emailController.text,
                        store.passwordController.text);
                    if (store.userCreate) {
                      showToast(
                          duration: const Duration(seconds: 3),
                          context: context,
                          store.exception);
                      Navigator.of(context).pop();
                      Navigator.of(context).popAndPushNamed(CoreStrings.nHome);
                    } else {
                      showToast(
                          duration: const Duration(seconds: 3),
                          context: context,
                          store.exception);
                    }
                  } else {
                    showToast(
                        duration: const Duration(seconds: 3),
                        context: context,
                        store.exception);
                  }
                  LoadingCustom().stopLoading();
                });
              },
            ),
          )
        ],
      );
    });
  }
}
