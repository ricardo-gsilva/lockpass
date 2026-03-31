import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ButtonCustom (widget)', () {
    testWidgets('calls onPressed when not loading', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonCustom(
              text: 'save',
              onPressed: () => calls += 1,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(calls, 1);
    });

    testWidgets('disables onPressed and shows spinner when loading', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonCustom(
              text: 'saving',
              isLoading: true,
              onPressed: () => calls += 1,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(calls, 0);
    });
  });
}

