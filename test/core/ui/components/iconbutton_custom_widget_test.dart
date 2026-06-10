import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IconButtonCustom (widget)', () {
    testWidgets('calls onPressed', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonCustom(
              icon: Icons.add,
              onPressed: () => calls += 1,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(calls, 1);
    });
  });
}

