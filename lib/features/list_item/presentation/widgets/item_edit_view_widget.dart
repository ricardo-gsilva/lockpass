import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/features/list_item/presentation/widgets/edit_item.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';

class ItemEditViewWidget extends StatelessWidget {
  final TextEditingController groupController;
  final TextEditingController serviceController;
  final TextEditingController siteController;
  final TextEditingController emailController;
  final TextEditingController loginController;
  final TextEditingController passwordController;
  final List<String> groupOptions;
  final String selectedType;

  const ItemEditViewWidget({
    super.key,
    required this.groupController,
    required this.serviceController,
    required this.siteController,
    required this.emailController,
    required this.loginController,
    required this.passwordController,
    required this.groupOptions,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue =
    groupOptions.contains(selectedType) ? selectedType : null;
    return Column(
      children: [
        const TextCustom(
          text: CoreStrings.selectGroup,
          color: CoreColors.textSecundary,
          fontSize: 16,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: safeValue,
          items: groupOptions
              .map(
                  (v) => DropdownMenuItem(value: v, child: TextCustom(text: v)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              groupController.text = value;
            }
          },
          decoration: const InputDecoration(
            filled: true,
            fillColor: CoreColors.secondColor,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        EditItem(
          title: CoreStrings.group,
          width: double.infinity,
          cursorColor: CoreColors.textSecundary,
          colorTextInput: CoreColors.textSecundary,
          labelColor: CoreColors.textSecundary,
          controller: groupController,
          colorBorder: CoreColors.textSecundary,
          colorFocusedBorder: CoreColors.focusedBorder,
        ),
        EditItem(
          title: CoreStrings.service,
          width: double.infinity,
          cursorColor: CoreColors.textSecundary,
          colorTextInput: CoreColors.textSecundary,
          labelColor: CoreColors.textSecundary,
          colorBorder: CoreColors.textSecundary,
          colorFocusedBorder: CoreColors.focusedBorder,
          controller: serviceController,
          validator: (value) => value.requiredError,
        ),
        EditItem(
          title: CoreStrings.webSite,
          cursorColor: CoreColors.textSecundary,
          colorTextInput: CoreColors.textSecundary,
          labelColor: CoreColors.textSecundary,
          colorBorder: CoreColors.textSecundary,
          colorFocusedBorder: CoreColors.focusedBorder,
          width: double.infinity,
          controller: siteController,
        ),
        EditItem(
          title: CoreStrings.email,
          cursorColor: CoreColors.textSecundary,
          colorTextInput: CoreColors.textSecundary,
          labelColor: CoreColors.textSecundary,
          colorBorder: CoreColors.textSecundary,
          colorFocusedBorder: CoreColors.focusedBorder,
          width: double.infinity,
          controller: emailController,
          validator: (value) => value.emailError,
        ),
        EditItem(
          title: CoreStrings.login,
          cursorColor: CoreColors.textSecundary,
          colorTextInput: CoreColors.textSecundary,
          labelColor: CoreColors.textSecundary,
          colorBorder: CoreColors.textSecundary,
          colorFocusedBorder: CoreColors.focusedBorder,
          width: double.infinity,
          controller: loginController,
          validator: (value) => value.requiredError,
        ),
        EditItem(
          title: CoreStrings.password,
          cursorColor: CoreColors.textSecundary,
          colorTextInput: CoreColors.textSecundary,
          labelColor: CoreColors.textSecundary,
          colorBorder: CoreColors.textSecundary,          
          colorFocusedBorder: CoreColors.focusedBorder,
          width: double.infinity,
          controller: passwordController,
        ),
      ],
    );
  }
}
