import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/snack_bar_utils.dart';
import 'package:lockpass/features/login/presentation/state/login_state.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

import '../controller/login_controller.dart';

class ResetPasswordBottomSheet extends StatelessWidget {
  final LoginController controller;
  final TextEditingController resetPasswordController;

  const ResetPasswordBottomSheet({
    super.key,
    required this.controller,
    required this.resetPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginController, LoginState>(
      listenWhen: (prev, curr) => prev.exception != curr.exception || prev.message != curr.message,
      listener: (context, state) {
        if (state.resetPass != true) return;
        if (state.exception.isNotEmpty) {
          SnackUtils.showError(
            context, 
            content: state.exception
          );
        } else if (state.message.isNotEmpty) {
          SnackUtils.showSuccess(
            context, 
            content: state.message
          );          
        }
        controller.clearFeedback();
        Navigator.pop(context, true);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), // evita teclado por cima
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: BlocBuilder<LoginController, LoginState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const TextCustom(
                              text: CoreStrings.resetPassword,
                              color: CoreColors.textSecundary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 24),
                                          
                            /// EMAIL FIELD
                            TextFormFieldCustom(
                              label: CoreStrings.emailRegistered,
                              controller: resetPasswordController,
                              cursorColor: CoreColors.textSecundary,
                              colorTextInput: CoreColors.textSecundary,
                              colorTextLabel: CoreColors.textSecundary,
                              colorBorder: CoreColors.textSecundary,
                              validator: (value) {
                                return controller.validateEmail(value ?? '');
                              },
                            ),
                                          
                            const SizedBox(height: 24),
                                          
                            /// BOTÃO ENVIAR
                            ButtonCustom(
                              backgroundButton: CoreColors.buttonColorSecond,
                              colorText: CoreColors.textPrimary,
                              text: CoreStrings.send,
                              onPressed: () async {                                
                                await controller.resetPassword(
                                  email: resetPasswordController.text,
                                );                                
                              },
                            ),
                                          
                            const SizedBox(height: 12),
                                          
                            /// CANCELAR
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(color: CoreColors.textSecundary),
                              ),
                            ),
                          ],
                        );
                      }
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
