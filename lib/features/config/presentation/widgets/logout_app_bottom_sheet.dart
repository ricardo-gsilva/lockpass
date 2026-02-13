import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class LogoutAppBottomSheet extends StatelessWidget {
  const LogoutAppBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();
    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.successMessage.isNotNullOrBlank) {
          if (Navigator.of(context).canPop()) {
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
                            text: "Deslogar",
                            color: CoreColors.textSecundary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 15),
                          const TextCustom(
                            text:
                                "Você tem certeza que deseja deslogar do aplicativo?",
                            color: CoreColors.textSecundary,
                            fontSize: 15,
                          ),
                          const SizedBox(height: 24),

                          /// BOTÃO CRIAR
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    color: CoreColors.textTertiary,
                                  ),
                                ),
                              ),
                              ButtonCustom(
                                isLoading: state.isLoading,
                                backgroundButton: CoreColors.buttonColorSecond,
                                colorText: CoreColors.textPrimary,
                                text: state.isLoading
                                    ? 'Deslogando... '
                                    : "Deslogar",
                                onPressed: () async {
                                  controller.signOut();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      AppRoutes.login, (route) => false);
                                },
                              ),
                            ],
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
