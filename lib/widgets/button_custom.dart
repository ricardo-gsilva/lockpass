import 'package:flutter/material.dart';
import 'package:lockpass/widgets/text_custom.dart';

class ButtonCustom extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? backgroundButton;
  final VoidCallback? onPressed;
  final String? text;
  final Color? colorText;
  final double? fontSize;

  const ButtonCustom(
      {this.height,
      this.width,
      this.backgroundButton,
      this.onPressed,
      this.text,
      this.colorText,
      this.fontSize,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: backgroundButton),
          onPressed: onPressed,
          child: TextCustom(
            text: text,
            fontSize: fontSize,
            color: colorText
          ),
        ));
  }
}
