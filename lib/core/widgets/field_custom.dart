import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class FieldCustom extends StatelessWidget {
  final String? title;
  final String? label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? icon;
  final bool? obscureText;
  const FieldCustom(
      {this.label,
      this.title,
      this.controller,
      this.keyboardType,
      this.validator,
      this.icon,
      this.obscureText = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextCustom(
        text: title,
        color: CoreColors.textPrimary,
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.only(),
      subtitle: TextFormFieldCustom(
        key: CoreKeys.formFieldPrivateAddItem,
        label: label,
        keyboardType: keyboardType,
        controller: controller,
        icon: icon,
        validator: validator,
        obscureText: obscureText,
      ),
    );
  }
}
