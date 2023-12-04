// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class EditItem extends StatelessWidget {
  String? title;
  Color? color;
  double? width;
  TextEditingController? controller;
  Color? cursorColor;
  Color? colorTextInput;
  String? Function(String?)? validator;

  EditItem(
      {this.color,
      this.colorTextInput,
      this.controller,
      this.cursorColor,
      this.title,
      this.width,
      this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextCustom(
          text: title,
          fontSize: 16,
          color: CoreColors.textPrimary,
        ),
        SizedBox(
          width: width,
          child: TextFormFieldCustom(
            controller: controller,
            cursorColor: CoreColors.textPrimary,
            colorTextInput: CoreColors.textPrimary,
            validator: validator,
          ),
        )
      ],
    );
  }
}
