import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/state/auth_state.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';

class ResetPasswordBottomSheet extends StatefulWidget {
  const ResetPasswordBottomSheet({super.key});

  @override
  State<ResetPasswordBottomSheet> createState() => _ResetPasswordBottomSheetState();
}

class _ResetPasswordBottomSheetState extends State<ResetPasswordBottomSheet> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LoginController>();
    return BlocListener<LoginController, AuthState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        switch (state.status) {
          case PasswordResetSent():
            OverlayToast.showSuccess(
                content: CoreStrings.passwordResetEmailSent);
            Navigator.of(context).maybePop();
            break;
          case AuthError(:final message):
            OverlayToast.showError(content: message);
            break;
          default:
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: context.bottomSystemSpace),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {},
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: BlocBuilder<LoginController, AuthState>(builder: (context, state) {
                      final isLoading = state.status is AuthLoading;
                      return SingleChildScrollView(
                        child: Column(
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
                            FieldsFactory.email(
                              controller: emailController,
                            ),
                            const SizedBox(height: 24),
                            ButtonCustom(
                              backgroundButton: CoreColors.buttonColorSecond,
                              colorText: CoreColors.textPrimary,
                              text: isLoading ? CoreStrings.sending : CoreStrings.send,
                              isLoading: isLoading,
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      await controller.resetPassword(
                                        email: emailController.text,
                                      );
                                    },
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const TextCustom(
                                text: CoreStrings.cancel,
                                color: CoreColors.textSecundary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
