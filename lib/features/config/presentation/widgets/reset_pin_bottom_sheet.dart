import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/core/utils/validators/validators.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class ResetPinBottomSheet extends StatefulWidget {
  const ResetPinBottomSheet({
    super.key,
  });

  @override
  State<ResetPinBottomSheet> createState() => _ResetPinBottomSheetState();
}

class _ResetPinBottomSheetState extends State<ResetPinBottomSheet> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();
    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.successMessage.isNotNullOrBlank) {
          if(Navigator.of(context).canPop()){
            Navigator.of(context).pop();
          }
          SnackUtils.showSuccess(context, content: state.successMessage);
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
                  onTap: () {},
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
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const TextCustom(
                            text: "Resetar PIN",
                            color: CoreColors.textSecundary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const TextCustom(
                            text:
                                "Confirme sua identidade digitando seu e-mail e senha cadastrados. Após a validação, você poderá criar um novo PIN de acesso.",
                            color: CoreColors.textSecundary,
                            fontSize: 15,
                          ),
                          const SizedBox(height: 24),

                          /// EMAIL
                          TextFormFieldCustom(
                            label: CoreStrings.email,
                            controller: emailController,
                            cursorColor: CoreColors.textSecundary,
                            colorTextInput: CoreColors.textSecundary,
                            colorTextLabel: CoreColors.textSecundary,
                            colorBorder: CoreColors.textSecundary,
                            colorErrorText: CoreColors.textSecundary,
                            colorErrorBorder: CoreColors.alertError,
                            validator: (value) {
                              if (value.isBlank) return CoreStrings.fillField;
                              if (!value.isValidEmail)
                                return CoreStrings.emailInvalid;
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          /// PASSWORD
                          TextFormFieldCustom(
                            label: CoreStrings.password,
                            controller: passwordController,
                            cursorColor: CoreColors.textSecundary,
                            colorTextInput: CoreColors.textSecundary,
                            colorTextLabel: CoreColors.textSecundary,
                            colorBorder: CoreColors.textSecundary,
                            obscureText: state.obscureText,
                            icon: IconButton(
                              icon: Icon(
                                state.obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: CoreColors.textSecundary,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// BOTÃO CRIAR
                          ButtonCustom(
                            isLoading: state.isLoading,
                            backgroundButton: CoreColors.buttonColorSecond,
                            colorText: CoreColors.textPrimary,
                            text: state.isLoading
                                ? 'Resetando... '
                                : "Resetar PIN",
                            onPressed: () async {
                              await controller.reauthenticate(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          /// Cancelar
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: CoreColors.textSecundary),
                            ),
                          )
                        ],
                      );
                    }),
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
