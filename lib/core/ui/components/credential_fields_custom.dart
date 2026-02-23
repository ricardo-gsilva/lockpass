import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';
import 'package:lockpass/core/ui/components/textformfield_custom.dart';

class CredentialsFieldsCustom extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscureText;
  final VoidCallback onTogglePassword;

  const CredentialsFieldsCustom({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscureText,
    required this.onTogglePassword,
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
                  colorErrorText: CoreColors.textSecundary,
                  validator: (value) {
                    return value.isValidEmail ? null : value.emailError;
                  },
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
                child: TextFormFieldCustom(
                  key: CoreKeys.formFieldPasswordLoginPage,
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  label: CoreStrings.password,
                  colorTextLabel: CoreColors.textSecundary,
                  cursorColor: CoreColors.textSecundary,
                  colorTextInput: CoreColors.textSecundary,
                  colorBorder: CoreColors.textSecundary,
                  obscureText: obscureText,
                  colorErrorText: CoreColors.textSecundary,
                  validator: (value) => value.passwordError,
                  icon: IconButtonCustom(
                    key: CoreKeys.iconVisibilityPasswordLogin,
                    color: CoreColors.textSecundary,
                    icon: obscureText
                        ? CoreIcons.visibility
                        : CoreIcons.visibilityOff,
                    onPressed: onTogglePassword,
                  ),
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
