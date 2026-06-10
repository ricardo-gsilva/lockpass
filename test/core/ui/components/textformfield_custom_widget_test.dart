import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/ui/components/textformfield_custom.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TextFormFieldCustom (widget)', () {
    testWidgets('calls onChanged', (tester) async {
      String? last;
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormFieldCustom(
              label: 'L',
              controller: controller,
              onChanged: (v) => last = v,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.pump();

      expect(last, 'abc');
    });

    testWidgets('shows validator error on user interaction', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormFieldCustom(
              label: 'L',
              controller: controller,
              validator: (v) => (v == null || v.isEmpty) ? 'err' : null,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();
      expect(find.text('err'), findsNothing);

      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      expect(find.text('err'), findsOneWidget);
    });
  });
}

