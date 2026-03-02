import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';

class LogoutAppBottomSheet extends StatelessWidget {
  const LogoutAppBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();
    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ConfigLogoutSuccess():
            if (!context.mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            break;
          case ConfigError(:final message):
            if (!context.mounted) return;
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
                              text: CoreStrings.logoutAction,
                              color: CoreColors.textSecundary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 15),
                            const TextCustom(
                              text: CoreStrings.logoutConfirmationQuestion,
                              color: CoreColors.textSecundary,
                              fontSize: 15,
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
                                  text: isLoading ? CoreStrings.signingOut : CoreStrings.logoutAction,
                                  onPressed: () async {
                                    controller.signOut();
                                  },
                                ),
                              ],
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
