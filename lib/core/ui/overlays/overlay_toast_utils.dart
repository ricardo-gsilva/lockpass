import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/navigation/app_routes.dart';

class OverlayToast {
  OverlayToast._();

  static OverlayEntry? _currentEntry;

  static Duration _calculateDuration(String content) {
    final length = content.length;

    // 1 segundo base + 1 segundo a cada ~40 caracteres
    final seconds = 2 + (length / 40).ceil();

    return Duration(seconds: seconds.clamp(2, 6));
  }

  static void showError({
    required String content,
    Duration? duration,
  }) {
    _show(
      content: content,
      backgroundColor: Colors.red,
      duration: duration
    );
  }

  static void showSuccess({
    required String content,
    Duration? duration,
  }) {
    _show(
      content: content,
      backgroundColor: Colors.green,
      duration: duration,
    );
  }

  static void _show({
    required String content,
    required Color backgroundColor,
    Duration? duration,
  }) {
    final finalDuration = duration ?? _calculateDuration(content);
    final overlay = AppRoutes.navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _currentEntry?.remove();

    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final entry = OverlayEntry(
      builder: (_) => Positioned(
        left: 0,
        right: 0,
        bottom: bottomPadding,
        child: Material(
          color: backgroundColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 14 + bottomPadding),
            child: Text(
              content,
              style: const TextStyle(color: CoreColors.textPrimary),
            ),
          ),
        ),
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    Future.delayed(finalDuration, () {      
      if (_currentEntry == entry) {
        entry.remove();
        _currentEntry = null;
      }
    });
  }
}

// ignore: unused_element
class _ToastWidget extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  const _ToastWidget({
    required this.message,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: CoreColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
