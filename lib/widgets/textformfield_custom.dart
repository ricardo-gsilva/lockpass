// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/widgets/text_custom.dart';

class TextFormFieldCustom extends StatelessWidget {
  final String? label;
  final Color? colorTextInput;
  final Color? cursorColor;
  final Color? colorTextLabel;
  final Color? colorIcon;
  final Color? fillColor;
  final Color? colorBorder;
  final Color? colorErrorText;
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

  TextFormFieldCustom({
    this.label,
    this.colorTextInput = CoreColors.textPrimary,
    this.cursorColor = CoreColors.textPrimary,
    this.colorTextLabel = CoreColors.textPrimary,
    this.colorErrorText = CoreColors.textPrimary,
    this.colorBorder = CoreColors.textPrimary,
    this.fillColor = CoreColors.transparent,
    this.fonteSize,
    this.colorIcon,
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
    super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: TextFormField(
          readOnly: readOnly!,     
          maxLength: maxLength,
          onChanged: onChanged,
          autovalidateMode: AutovalidateMode.always,
          validator: validator,     
          keyboardType: keyboardType,
          controller: controller,
          cursorColor: cursorColor,
          obscuringCharacter: '*',
          obscureText: obscureText!,
          style: TextStyle(color: colorTextInput),
          decoration: InputDecoration(    
              border: OutlineInputBorder(
                borderSide: BorderSide(color: colorBorder!)
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber)
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorBorder!)
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: colorBorder!)),
              errorStyle: TextStyle(color: colorErrorText!),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorBorder!)
              ),
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
      )));
  }
}
