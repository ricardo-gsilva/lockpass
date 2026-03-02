import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/ui/components/textformfield_custom.dart';

class FieldsFactory {
  static const Color _defaultColor = CoreColors.textSecundary;

  static Widget password({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? label,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Color color = _defaultColor,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
  }) {
    return TextFormFieldCustom(
      label: label ?? CoreStrings.password,
      controller: controller,
      obscureText: obscureText,
      focusNode: focusNode,
      keyboardType: TextInputType.visiblePassword,
      cursorColor: color,
      colorTextInput: color,
      colorTextLabel: color,
      colorErrorText: color,
      colorBorder: color,
      colorErrorBorder: CoreColors.alertError,
      validator: validator,
      onChanged: onChanged,
      icon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: color,
        ),
        onPressed: onToggleVisibility,
      ),
    );
  }

  static Widget email({
    required TextEditingController controller,
    String? label,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    Color color = _defaultColor,
    FocusNode? focusNode,
  }) {
    return TextFormFieldCustom(
      label: label ?? CoreStrings.email,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      cursorColor: color,
      colorTextInput: color,
      colorTextLabel: color,
      colorBorder: color,
      colorErrorText: color,
      colorErrorBorder: CoreColors.alertError,
      onChanged: onChanged,
      validator:
          validator ?? (value) => value.isValidEmail ? null : value?.emailError,
    );
  }

  static Widget pin({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Color color = _defaultColor,
    int maxLength = 5,
    FocusNode? focusNode,
  }) {
    return TextFormFieldCustom(
      label: "PIN",
      maxLength: maxLength,
      controller: controller,
      obscureText: obscureText,
      focusNode: focusNode,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      cursorColor: color,
      colorTextInput: color,
      colorTextLabel: color,
      colorBorder: color,
      colorErrorText: color,
      colorErrorBorder: CoreColors.alertError,
      validator: validator ?? (value) => value?.pinError,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      icon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
          color: color,
        ),
        onPressed: onToggleVisibility,
      ),
    );
  }

  static Widget text({
    String? label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    Color color = _defaultColor,
    Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    FocusNode? focusNode,
    int? maxLength,
    bool readOnly = false,
  }) {
    return TextFormFieldCustom(
      label: label,
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      maxLength: maxLength,
      onChanged: onChanged,
      keyboardType: keyboardType,
      cursorColor: color,
      colorTextInput: color,
      colorTextLabel: color,
      colorBorder: color,
      validator: validator,
      icon: suffixIcon,
    );
  }
}
