import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/ui/feedback/snack_bar_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SnackUtils', () {
    testWidgets('showSuccess shows snackbar with content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => SnackUtils.showSuccess(context, content: 'OK'),
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pump(); // show snackbar

      expect(find.text('OK'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

