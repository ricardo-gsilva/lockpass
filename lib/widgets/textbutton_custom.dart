import 'package:flutter/material.dart';
import 'package:lockpass/widgets/text_custom.dart';

class TextButtonCustom extends StatelessWidget {

  final String? text;
  final Color? colorText;
  final VoidCallback onPressed;
  final double? fontSize;

  const TextButtonCustom({    
    required this.text,
    required this.onPressed,
    this.colorText,
    this.fontSize,
    super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child: TextCustom(
        text: text,
        fontSize: fontSize,
        color: colorText,
      )
    );
  }
}