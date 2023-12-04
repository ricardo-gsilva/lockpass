import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';

class TextCustom extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  const TextCustom({
    Key? key,
    this.text,
    this.fontSize,
    this.fontWeight,
    this.color = CoreColors.textPrimary,
    this.textAlign
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Text(
      text?? '',
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
    
    
  }
}