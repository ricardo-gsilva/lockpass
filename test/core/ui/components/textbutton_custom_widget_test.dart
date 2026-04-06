import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TextButtonCustom (widget)', () {
    testWidgets('calls onPressed', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButtonCustom(
              text: 'tap',
              onPressed: () => calls += 1,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(calls, 1);
    });
  });
}

