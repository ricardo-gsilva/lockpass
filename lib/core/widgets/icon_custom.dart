// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class IconCustom extends StatelessWidget {
  IconData? icon;
  Color? color;

  IconCustom({
    this.color,
    this.icon,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color);
  }
}