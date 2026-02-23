import 'package:flutter/material.dart';

Future<T?> showCustomBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
  bool? useRootNavigator,
}) {
  return   showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    // useSafeArea: true,
    useRootNavigator: useRootNavigator?? false,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => child,
  );
}
