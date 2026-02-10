import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/state/login_state.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class PinLoginBottomSheet extends StatefulWidget {
  const PinLoginBottomSheet({
    super.key,
  });

  @override
  State<PinLoginBottomSheet> createState() => _PinLoginBottomSheetState();
}

class _PinLoginBottomSheetState extends State<PinLoginBottomSheet> {
  final TextEditingController pinController = TextEditingController();
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = getIt<LoginController>();
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: controller,
      child: BlocListener<LoginController, LoginState>(
        listenWhen: (previous, current) =>
            previous.isAuthenticated != current.isAuthenticated ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.isAuthenticated) {
            Navigator.of(context).pop(); // fecha o bottom sheet
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          }
          if (state.errorMessage.isNotNullOrBlank) {
            SnackUtils.showError(context, content: state.errorMessage);
          }
        },
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
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
                      height: MediaQuery.of(context).size.height * 0.35,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: CoreColors.primaryColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: BlocBuilder<LoginController, LoginState>(
                          buildWhen: (previous, current) =>
                              previous.isLoading != current.isLoading ||
                              previous.canSubmitPin != current.canSubmitPin ||
                              previous.obscureText != current.obscureText,
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const TextCustom(
                                  text: "Entrar com PIN",
                                  color: CoreColors.textSecundary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 15),
                                TextFormFieldCustom(
                                  label: "PIN",
                                  controller: pinController,
                                  obscureText: state.obscureText,
                                  keyboardType: TextInputType.number,
                                  colorTextInput: CoreColors.textSecundary,
                                  colorTextLabel: CoreColors.textSecundary,
                                  colorBorder: CoreColors.textSecundary,
                                  cursorColor: CoreColors.textSecundary,
                                  onChanged: controller.onPinChanged,                                  
                                  icon: IconButtonCustom(
                                    key: CoreKeys.iconVisibilityPasswordLogin,
                                    color: CoreColors.textSecundary,
                                    icon: state.obscureText
                                        ? CoreIcons.visibility
                                        : CoreIcons.visibilityOff,
                                    onPressed:
                                        controller.togglePasswordVisibility,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ButtonCustom(
                                  text: state.isLoading
                                      ? "Validando..."
                                      : "Logar com PIN",
                                  height: 50,
                                  width: double.infinity,
                                  backgroundButton:
                                      CoreColors.buttonColorSecond,
                                  colorText: CoreColors.textPrimary,
                                  onPressed: state.isLoading ||
                                          !state.canSubmitPin
                                      ? null
                                      : () async {
                                          await controller
                                              .loginWithPin(pinController.text);
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
                                ),
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
      ),
    );
  }
}
