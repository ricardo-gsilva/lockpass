import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class PinLoginBottomSheet extends StatelessWidget {
  final LoginController controller;
  final TextEditingController pinController;

  const PinLoginBottomSheet({
    super.key,
    required this.controller,
    required this.pinController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: CoreColors.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextCustom(
                  text: "Enter your PIN",
                  color: CoreColors.textSecundary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
            const SizedBox(height: 15),
            TextFormFieldCustom(
              label: "PIN",
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              colorTextInput: CoreColors.textSecundary,
              colorTextLabel: CoreColors.textSecundary,
              colorBorder: CoreColors.textSecundary,
            ),
            const SizedBox(height: 20),
            ButtonCustom(
              text: "Logar com PIN",
              height: 50,
              width: double.infinity,
              backgroundButton: CoreColors.buttonColorSecond,
              colorText: CoreColors.textPrimary,
              onPressed: () async {
                final ok = await controller.loginWithPin(pin: pinController.text);

                if (ok) {
                  Navigator.of(context).pop(); // fecha o bottom sheet
                  Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(controller.state.exception)),
                  );                  
                }
              },
            ),
            const SizedBox(height: 12),
            TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: CoreColors.textSecundary),
                  ),
                ),       
          ],
        ),
      ),
    );
  }
}
