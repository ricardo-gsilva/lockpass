import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';

class TextCustom extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const TextCustom({
    super.key,
    this.text,
    this.fontSize,
    this.fontWeight,
    this.color = CoreColors.textPrimary,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });
  

  @override
  Widget build(BuildContext context) {
    return Text(
      text?? '',
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: overflow,
        
      ),
      textAlign: textAlign,
    );
    
    
  }
}