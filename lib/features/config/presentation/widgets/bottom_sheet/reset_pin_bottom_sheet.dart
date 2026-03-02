import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/components/textformfield_custom.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';

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
  bool _obscurePassword = false;

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
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ConfigPinResetSuccess(:final message):
            if (!mounted) return;
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            OverlayToast.showSuccess(content: message);
            break;
          case ConfigError(:final message):
            if (!mounted) return;
            OverlayToast.showError(content: message);
            break;
          default:
            return;
        }
        controller.clearStatus();
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
                    child: BlocBuilder<ConfigController, ConfigState>(builder: (context, state) {
                      final isLoading = state.status is ConfigLoading;
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const TextCustom(
                              text: CoreStrings.resetPinAction,
                              color: CoreColors.textSecundary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const TextCustom(
                              text: CoreStrings.resetPinExplanation,
                              color: CoreColors.textSecundary,
                              fontSize: 15,
                            ),
                            const SizedBox(height: 24),
                            TextFormFieldCustom(
                              label: CoreStrings.email,
                              controller: emailController,
                              cursorColor: CoreColors.textSecundary,
                              colorTextInput: CoreColors.textSecundary,
                              colorTextLabel: CoreColors.textSecundary,
                              colorBorder: CoreColors.textSecundary,
                              colorErrorText: CoreColors.textSecundary,
                              colorErrorBorder: CoreColors.alertError,
                              validator: (value) => value.emailError,
                            ),
                            const SizedBox(height: 16),
                            TextFormFieldCustom(
                              label: CoreStrings.password,
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              cursorColor: CoreColors.textSecundary,
                              colorTextInput: CoreColors.textSecundary,
                              colorTextLabel: CoreColors.textSecundary,
                              colorBorder: CoreColors.textSecundary,
                              obscureText: _obscurePassword,
                              validator: (value) => value.passwordError,
                              icon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: CoreColors.textSecundary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            ButtonCustom(
                              isLoading: isLoading,
                              backgroundButton: CoreColors.buttonColorSecond,
                              colorText: CoreColors.textPrimary,
                              text: isLoading ? CoreStrings.resetting : CoreStrings.resetPinAction,
                              onPressed: () async {
                                await controller.reauthenticate(
                                  email: emailController.text,
                                  password: passwordController.text,
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
  }
}
