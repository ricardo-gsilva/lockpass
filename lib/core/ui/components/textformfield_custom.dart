import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';

class TextFormFieldCustom extends StatelessWidget {
  final String? label;
  final Color? colorTextInput;
  final Color? cursorColor;
  final Color? colorTextLabel;
  final Color? colorIcon;
  final Color? fillColor;
  final Color? colorBorder;
  final Color? colorErrorBorder;
  final Color? colorErrorText;
  final Color? colorFocusedBorder;
  final double? fonteSize;
  final IconData? icons;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? icon;
  final String? Function(String?)? validator;
  final String? errorText;
  final Function(String)? onChanged;
  final String? initialValue;
  final int? maxLength;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool? enabled;

  const TextFormFieldCustom(
      {this.label,
      this.colorTextInput = CoreColors.textPrimary,
      this.cursorColor = CoreColors.textPrimary,
      this.colorTextLabel = CoreColors.textPrimary,
      this.colorErrorText = CoreColors.textPrimary,
      this.colorErrorBorder = CoreColors.textPrimary,
      this.colorBorder = CoreColors.textPrimary,
      this.fillColor = CoreColors.transparent,
      this.colorFocusedBorder = CoreColors.focusedBorder,
      this.fonteSize,
      this.colorIcon = CoreColors.transparent,
      this.icons,
      this.controller,
      this.keyboardType,
      this.obscureText = false,
      this.icon,
      this.validator,
      this.errorText,
      this.onChanged,
      this.initialValue,
      this.maxLength,
      this.readOnly = false,
      this.inputFormatters,
      this.focusNode,
      this.enabled,
      super.key});

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.3),
      borderRadius: BorderRadius.circular(6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Material(
        color: CoreColors.transparent,
        child: TextFormField(
          readOnly: readOnly!,
          maxLength: maxLength,
          onChanged: onChanged,
          enabled: enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          keyboardType: keyboardType,
          controller: controller,
          cursorColor: cursorColor,
          obscuringCharacter: '*',
          obscureText: obscureText!,
          focusNode: focusNode,
          style: TextStyle(color: colorTextInput),
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            border: _border(colorBorder!),
            focusedBorder: _border(colorFocusedBorder!),
            errorBorder: _border(colorErrorBorder!),
            enabledBorder: _border(colorBorder!),
            focusedErrorBorder: _border(colorErrorBorder!),
            errorStyle: TextStyle(color: colorErrorText!),
            counterStyle: const TextStyle(color: CoreColors.textSecundary),
            errorText: errorText,
            suffixIcon: icon,
            filled: true,
            fillColor: fillColor,
            label: TextCustom(
              text: label,
              color: colorTextLabel,
              fontSize: fonteSize,
            ),
          ),
        ),
      ),
    );
  }
}
