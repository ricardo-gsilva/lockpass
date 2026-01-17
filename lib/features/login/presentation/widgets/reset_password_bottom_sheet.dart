import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_strings.dart';
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
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // evita teclado por cima
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: CoreColors.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Observer(
          builder: (_) {
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
                    final ok = await controller.resetPassword(
                      email: resetPasswordController.text,
                    );

                    if (ok) {
                      Navigator.pop(context, true);
                    }
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
          },
        ),
      ),
    );
  }
}
