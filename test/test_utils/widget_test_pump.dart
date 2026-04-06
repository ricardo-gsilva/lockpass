import 'package:flutter_test/flutter_test.dart';

/// Pumps a couple of frames to let modal routes (dialogs/bottom sheets)
/// finish their default entrance/exit animations without relying on
/// [WidgetTester.pumpAndSettle], which can hang if something keeps
/// scheduling frames.
Future<void> pumpModal(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
  await tester.pump();
}

/// Flushes the maximum toast duration used by `OverlayToast` (clamped to 6s)
/// plus a small buffer, so tests don't leave pending timers behind.
Future<void> flushToasts(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 7));
  await tester.pump();
}

