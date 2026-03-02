import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/ui/components/icon_custom.dart';

class IconButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double? iconSize;
  final Color color;

  const IconButtonCustom(
      {required this.icon,
      required this.onPressed,
      this.iconSize,
      this.color = CoreColors.buttonColorPrimary,
      super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: IconCustom(
        icon: icon,
      ),
      iconSize: iconSize,
      onPressed: onPressed,
      color: color,
    );
  }
}
