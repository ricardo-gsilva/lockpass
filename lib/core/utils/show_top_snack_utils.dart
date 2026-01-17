import 'package:flutter/material.dart';

void showBottomSheetSnack({
  required BuildContext context,
  required String message,
  Color color = Colors.red,
}) {
  final overlay = Overlay.of(context);
  if (overlay == null) return;

  final renderBox = context.findRenderObject() as RenderBox?;
  final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

  final entry = OverlayEntry(
    builder: (_) => Positioned(
      left: 20,
      right: 20,
      bottom: MediaQuery.of(context).size.height - offset.dy + 12,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 2), () {
    entry.remove();
  });
}
