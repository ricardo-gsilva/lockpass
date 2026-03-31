import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('showCustomBottomSheet', () {
    testWidgets('shows provided child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showCustomBottomSheet<void>(
                      context: context,
                      child: const Text('SHEET', key: Key('sheet-text')),
                    );
                  },
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sheet-text')), findsOneWidget);
      expect(find.text('SHEET'), findsOneWidget);
    });
  });
}

