import 'package:flutter/material.dart';

extension BottomSpaceExtension on BuildContext {
  double get bottomInset =>
      MediaQuery.of(this).viewInsets.bottom;

  double get bottomPadding =>
      MediaQuery.of(this).viewPadding.bottom;

  double get bottomSystemSpace =>
      bottomInset > 0 ? bottomInset : bottomPadding;
}