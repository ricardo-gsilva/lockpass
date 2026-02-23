import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/login/presentation/state/auth_state.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';
import '../controller/login_controller.dart';

class CreateAccountBottomSheet extends StatefulWidget {
  const CreateAccountBottomSheet({
    super.key,
  });

  @override
  State<CreateAccountBottomSheet> createState() =>
      _CreateAccountBottomSheetState();
}

class _CreateAccountBottomSheetState extends State<CreateAccountBottomSheet> {
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
    final controller = context.read<LoginController>();
    return Builder(builder: (context) {
      return BlocListener<LoginController, AuthState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          switch (state.status) {
            case AccountCreated():
              OverlayToast.showSuccess(content: CoreStrings.userCreateSuccess);
              Navigator.of(context).maybePop(
                (email: emailController.text,),
              );
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: BlocBuilder<LoginController, AuthState>(
                          builder: (context, state) {
                        final isLoading = state.status is AuthLoading;
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const TextCustom(
                                text: CoreStrings.register1,
                                color: CoreColors.textSecundary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 24),
                              FieldsFactory.email(controller: emailController),
                              const SizedBox(height: 16),
                              FieldsFactory.password(
                                controller: passwordController,
                                obscureText: state.obscureText,
                                onToggleVisibility:
                                    controller.togglePasswordVisibility,
                              ),
                              const SizedBox(height: 24),
                              ButtonCustom(
                                isLoading: isLoading,
                                backgroundButton: CoreColors.buttonColorSecond,
                                colorText: CoreColors.textPrimary,
                                text: isLoading
                                    ? 'Criando conta... '
                                    : CoreStrings.register2,
                                onPressed: () async {
                                  await controller.register(
                                      email: emailController.text,
                                      password: passwordController.text);
                                },
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      color: CoreColors.textSecundary),
                                ),
                              )
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
    });
  }
}
