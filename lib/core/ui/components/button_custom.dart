import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';

class ButtonCustom extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? backgroundButton;
  final VoidCallback? onPressed;
  final String? text;
  final Color? colorText;
  final double? fontSize;
  final bool isLoading;

  const ButtonCustom(
      {this.height,
      this.width,
      this.backgroundButton,
      this.onPressed,
      this.text,
      this.colorText,
      this.fontSize,
      this.isLoading = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: backgroundButton),
        onPressed: isLoading? null : onPressed,
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextCustom(text: text, fontSize: fontSize, color: colorText),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: CoreColors.textPrimary,
                      strokeWidth: 2,
                    ),
                  )
                ],
              )
            : TextCustom(
                text: text,
                fontSize: fontSize,
                color: colorText,
              ),
      ),
    );
  }
}
