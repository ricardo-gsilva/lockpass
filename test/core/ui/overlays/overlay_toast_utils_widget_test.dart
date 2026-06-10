import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OverlayToast', () {
    testWidgets('showSuccess inserts and removes overlay entry', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppRoutes.navigatorKey,
          home: const Scaffold(body: Text('HOME')),
        ),
      );

      OverlayToast.showSuccess(content: 'YAY', duration: const Duration(milliseconds: 10));
      await tester.pump();

      expect(find.text('YAY'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 20));
      await tester.pump();

      expect(find.text('YAY'), findsNothing);
    });
  });
}

