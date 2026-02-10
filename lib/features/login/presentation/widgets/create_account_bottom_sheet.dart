import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/core/utils/validators/validators.dart';
import 'package:lockpass/features/login/presentation/state/login_state.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';
import '../controller/login_controller.dart';

class CreateAccountBottomSheet extends StatefulWidget {
  final LoginController controller;

  const CreateAccountBottomSheet({
    super.key,
    required this.controller,
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
    return BlocListener<LoginController, LoginState>(
      listenWhen: (prev, curr) => prev.exception != curr.exception || prev.message != curr.message,
      listener: (context, state) {
        if (state.userCreate) {
          Navigator.pop(context,(
              email: emailController.text,
              password: passwordController.text,
            ),
          );
          SnackUtils.showSuccess(
            context,
            content: state.message
          );           
        }
        if (state.exception.isNotEmpty) {
          SnackUtils.showError(
            context, 
            content: state.exception
          );          
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    child: BlocBuilder<LoginController, LoginState>(
                        builder: (context, state) {
                      return Column(
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
                          /// EMAIL
                          TextFormFieldCustom(
                            label: CoreStrings.email,
                            controller: emailController,
                            cursorColor: CoreColors.textSecundary,
                            colorTextInput: CoreColors.textSecundary,
                            colorTextLabel: CoreColors.textSecundary,
                            colorBorder: CoreColors.textSecundary,
                            colorErrorText: CoreColors.textSecundary,
                            colorErrorBorder: CoreColors.alertError,
                            validator: (value) {
                              return value.isValidEmail ? null : value.emailError;
                            },
                          ),
                          const SizedBox(height: 16),
                          /// PASSWORD
                          TextFormFieldCustom(
                            label: CoreStrings.password,
                            controller: passwordController,
                            cursorColor: CoreColors.textSecundary,
                            colorTextInput: CoreColors.textSecundary,
                            colorTextLabel: CoreColors.textSecundary,
                            colorBorder: CoreColors.textSecundary,
                            obscureText: state.obscureText,
                            validator: (value) => value.passwordError,
                            icon: IconButton(
                              icon: Icon(
                                state.obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: CoreColors.textSecundary,
                              ),
                              onPressed:
                                  widget.controller.togglePasswordVisibility,
                            ),
                          ),
                          const SizedBox(height: 24),
                          /// BOTÃO CRIAR
                          ButtonCustom(
                            isLoading: state.isLoading,
                            backgroundButton: CoreColors.buttonColorSecond,
                            colorText: CoreColors.textPrimary,
                            text: state.isLoading
                                ? 'Criando conta... '
                                : CoreStrings.register2,
                            onPressed: () async {
                              await widget.controller.register(
                                  email: emailController.text,
                                  password: passwordController.text);
                            },
                          ),
                          const SizedBox(height: 12),
                          /// Cancelar
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: CoreColors.textSecundary),
                            ),
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
