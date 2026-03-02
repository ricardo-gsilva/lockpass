import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';
import 'package:lockpass/core/ui/components/info_dialog.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() => _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;
  bool _obscurePassword = false;
  bool _obscureNewPassword = false;

  void showInfo(bool isAndroid) {
    showDialog(
      context: context,
      builder: (_) => InfoDialog(
        key: CoreKeys.alertDialogInfoSaveList,
        title: CoreStrings.passwordRequirementsTitle,
        content: CoreStrings.passwordRequirementsExplanation,
        widgets: [
          TextButtonCustom(
            key: CoreKeys.cancelCreatePin,
            text: CoreStrings.close,
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
          title: CoreStrings.changePasswordAction,
          content: CoreStrings.changePasswordConfirmation,
          widgets: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const TextCustom(
                text: CoreStrings.cancel,
                color: CoreColors.textPrimary,
              ),
            ),
            ButtonCustom(
              backgroundButton: CoreColors.buttonColorSecond,
              colorText: CoreColors.textPrimary,
              text: CoreStrings.change,
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
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ConfigResetPasswordSuccess(:final message):
            if (!mounted) return;
            OverlayToast.showSuccess(content: message);
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            }
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
                    child: BlocBuilder<ConfigController, ConfigState>(
                      builder: (context, state) {
                        final isLoading = state.status is ConfigLoading;
                        return SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            onChanged: () {
                              final valid = _formKey.currentState?.validate() ?? false;
                              setState(() {
                                _isValid = valid;
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const TextCustom(
                                      text: CoreStrings.changePasswordAction,
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
                                  text: CoreStrings.changePasswordConfirmation,
                                  color: CoreColors.textSecundary,
                                  fontSize: 15,
                                ),
                                const SizedBox(height: 24),
                                FieldsFactory.password(
                                  controller: currentPasswordController,
                                  validator: (value) => value.passwordError,
                                  obscureText: _obscurePassword,
                                  label: CoreStrings.enterCurrentPassword,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                FieldsFactory.password(
                                  controller: newPasswordController,
                                  validator: (value) => value.passwordError,
                                  obscureText: _obscureNewPassword,
                                  label: CoreStrings.enterNewPassword,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _obscureNewPassword = !_obscureNewPassword;
                                    });
                                  },
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const TextCustom(
                                        text: CoreStrings.cancel,
                                        color: CoreColors.textTertiary,
                                      ),
                                    ),
                                    ButtonCustom(
                                      isLoading: isLoading,
                                      backgroundButton: CoreColors.buttonColorSecond,
                                      colorText: CoreColors.textPrimary,
                                      text: isLoading ? CoreStrings.changing : CoreStrings.change,
                                      onPressed: !_isValid
                                          ? null
                                          : () {
                                              showUpdatePassword(() => controller.updatePassword(
                                                    currentPasswordController.text,
                                                    newPasswordController.text,
                                                  ));
                                            },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
