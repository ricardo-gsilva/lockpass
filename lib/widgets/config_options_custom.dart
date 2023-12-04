import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/widgets/text_custom.dart';

class ConfigOptions extends StatelessWidget {
  final IconData? icons;
  final double? iconSize;
  final String? text;
  final double? fontSize;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const ConfigOptions({
    this.fontSize,
    this.iconSize = 20,
    this.icons,
    this.text,
    required this.onTap,
    this.textColor = CoreColors.textPrimary,
    this.iconColor = CoreColors.textPrimary,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 15),
            child: Icon(icons, size: iconSize, color: iconColor),
          ),          
          TextButton(
            onPressed: onTap,
            child: TextCustom(text: text, fontSize: fontSize, color: textColor),
          )
        ],
      ),
    );
  }
}
