import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void showInfo(bool isAndroid) {
    showDialog(
      context: context,
      builder: (_) => InfoDialog(
        key: CoreKeys.alertDialogInfoSaveList,
        title: "Requisitos de Senha",
        content:
            "Para garantir a segurança dos seus dados, sua nova senha deve conter no mínimo 6 caracteres.\n\nRecomendamos o uso de combinações de letras, números e caracteres para tornar seu cofre ainda mais protegido.",
        widgets: [
          TextButtonCustom(
            key: CoreKeys.cancelCreatePin,
            text: "Fechar",
            colorText: CoreColors.textPrimary,
            fontSize: 16,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showUpdatePassword(Future<void> Function() onConfirm) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return InfoDialog(
          key: CoreKeys.alertDialogSaveList,
          title: "Alterar Senha",
          content:
              "Tem certeza que deseja alterar sua senha de login? Essa ação irá deslogar sua conta e você precisará fazer login novamente com a nova senha.",
          widgets: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: CoreColors.textPrimary,
                ),
              ),
            ),
            ButtonCustom(
              backgroundButton: CoreColors.buttonColorSecond,
              colorText: CoreColors.textPrimary,
              text: "Alterar",
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();

    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage ||
          previous.updatedPassword != current.updatedPassword,
      listener: (context, state) {
        if (state.successMessage.isNotNullOrBlank && state.updatedPassword) {
          controller.clearMessages();
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          }
        }

        if (state.errorMessage.isNotNullOrBlank) {
          SnackUtils.showError(context, content: state.errorMessage);
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
                  onTap: () {}, // Impede que o toque no modal feche ele
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: BlocBuilder<ConfigController, ConfigState>(
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          onChanged: () {
                            controller.isFormValid(
                              currentPasswordController.text,
                              newPasswordController.text,
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextCustom(
                                    text: "Alterar Senha",
                                    color: CoreColors.textSecundary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  IconButtonCustom(
                                    key: CoreKeys.buttonInfoSaveList,
                                    icon: CoreIcons.info,
                                    onPressed: () => showInfo(state.isAndroid),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              const TextCustom(
                                text:
                                    "Tem certeza que deseja alterar sua senha de login? Essa ação irá deslogar sua conta e você precisará fazer login novamente com a nova senha.",
                                color: CoreColors.textSecundary,
                                fontSize: 15,
                              ),
                              const SizedBox(height: 24),
                              TextFormFieldCustom(
                                keyboardType: TextInputType.text,
                                obscureText: !state.sufixIcon,
                                label: "Digite sua senha atual",
                                colorTextInput: CoreColors.textSecundary,
                                colorTextLabel: CoreColors.textSecundary,
                                cursorColor: CoreColors.textSecundary,
                                colorErrorText: CoreColors.textSecundary,
                                colorBorder: CoreColors.textSecundary,
                                controller: currentPasswordController,
                                validator: (value) => value.passwordError,
                                icon: IconButtonCustom(
                                  key: CoreKeys.iconVisibilityPasswordLogin,
                                  color: CoreColors.textSecundary,
                                  icon: state.sufixIcon
                                      ? CoreIcons.visibility
                                      : CoreIcons.visibilityOff,
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormFieldCustom(
                                keyboardType: TextInputType.text,
                                obscureText: !state.sufixIcon,
                                label: "Digite sua nova senha",
                                colorTextInput: CoreColors.textSecundary,
                                colorTextLabel: CoreColors.textSecundary,
                                cursorColor: CoreColors.textSecundary,
                                colorErrorText: CoreColors.textSecundary,
                                colorBorder: CoreColors.textSecundary,
                                controller: newPasswordController,
                                validator: (value) => value.passwordError,
                                icon: IconButtonCustom(
                                  key: CoreKeys.iconVisibilityPasswordLogin,
                                  color: CoreColors.textSecundary,
                                  icon: state.sufixIcon
                                      ? CoreIcons.visibility
                                      : CoreIcons.visibilityOff,
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "Cancelar",
                                      style: TextStyle(
                                          color: CoreColors.textTertiary),
                                    ),
                                  ),
                                  ButtonCustom(
                                    isLoading: state.isLoading,
                                    backgroundButton:
                                        CoreColors.buttonColorSecond,
                                    colorText: CoreColors.textPrimary,
                                    text: state.isLoading
                                        ? "Alterando... "
                                        : "Alterar",
                                    onPressed: !state.isFormValid
                                        ? null
                                        : () {
                                            showUpdatePassword(() =>
                                                controller.updatePassword(
                                                  currentPasswordController
                                                      .text,
                                                  newPasswordController.text,
                                                ));
                                          },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
