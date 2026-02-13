// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class EditItem extends StatelessWidget {
  final String? title;
  final Color? color;
  final double? width;
  final TextEditingController? controller;
  final Color? cursorColor;
  final Color? colorTextInput;
  final Color? labelColor;
  final Color? colorFocusedBorder;
  final Color? colorBorder;
  final String? Function(String?)? validator;

  const EditItem(
      {this.color,
      this.colorTextInput,
      this.controller,
      this.cursorColor,
      this.title,
      this.width,
      this.validator,
      this.labelColor,
      this.colorFocusedBorder,
      this.colorBorder,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextCustom(
          text: title,
          fontSize: 16,
          color: labelColor,
        ),
        SizedBox(
          width: width,
          child: TextFormFieldCustom(
            controller: controller,
            cursorColor: cursorColor,
            colorTextInput: colorTextInput,
            colorFocusedBorder: colorFocusedBorder,
            colorBorder: colorBorder,
            validator: validator,
          ),
        )
      ],
    );
  }
}
