import 'package:flutter/material.dart';
import 'package:lockpass/widgets/text_custom.dart';

class SnackUtils {
  SnackUtils._();

  static void showSuccess(
    BuildContext context, {
    required String content,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      context,
      content: content,
      backgroundColor: Colors.green,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String content,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      context,
      content: content,
      backgroundColor: Colors.red,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String content,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      context,
      content: content,
      backgroundColor: Colors.blueGrey,
      duration: duration,
    );
  }

  static void _show(
    BuildContext context, {
    required String content,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: TextCustom(
            text: content,
          ),
          backgroundColor: backgroundColor,
          duration: duration,
        ),
      );
  }
}
