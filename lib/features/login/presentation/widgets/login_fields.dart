import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/validators/validators.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/state/login_state.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class LoginFields extends StatelessWidget {
  final LoginController controller;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFields({
    super.key,
    required this.controller,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// EMAIL
        Row(
          children: [
            const Icon(CoreIcons.person, color: CoreColors.textSecundary),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextFormFieldCustom(
                  key: CoreKeys.formFieldEmailLoginPage,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  label: CoreStrings.login,
                  colorTextLabel: CoreColors.textSecundary,
                  cursorColor: CoreColors.textSecundary,
                  colorTextInput: CoreColors.textSecundary,
                  colorBorder: CoreColors.textSecundary,
                  validator: (value) {
                    return value.isValidEmail ? null : value.emailError;
                  }
                ),
              ),
            ),
          ],
        ),

        /// PASSWORD
        Row(
          children: [
            const Icon(CoreIcons.lock, color: CoreColors.textSecundary),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: BlocBuilder<LoginController, LoginState>(
                  builder: (context, state) {
                    return TextFormFieldCustom(
                      key: CoreKeys.formFieldPasswordLoginPage,
                      controller: passwordController,
                      label: CoreStrings.password,
                      colorTextLabel: CoreColors.textSecundary,
                      cursorColor: CoreColors.textSecundary,
                      colorTextInput: CoreColors.textSecundary,
                      colorBorder: CoreColors.textSecundary,
                      obscureText: state.obscureText,
                      validator: (value) => value.passwordError,
                      icon: IconButtonCustom(
                        key: CoreKeys.iconVisibilityPasswordLogin,
                        color: CoreColors.textSecundary,
                        icon: state.sufixIcon
                            ? CoreIcons.visibility
                            : CoreIcons.visibilityOff,
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    );
                  }
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        
      ],
    );
  }
}
