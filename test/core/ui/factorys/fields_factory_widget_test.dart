import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FieldsFactory (widget)', () {
    testWidgets('password field toggles obscureText via icon', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      var obscure = true;

      Widget build() {
        return MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: FieldsFactory.password(
                  controller: controller,
                  obscureText: obscure,
                  onToggleVisibility: () => setState(() => obscure = !obscure),
                ),
              );
            },
          ),
        );
      }

      await tester.pumpWidget(build());
      EditableText editable = tester.widget(find.byType(EditableText));
      expect(editable.obscureText, isTrue);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      editable = tester.widget(find.byType(EditableText));
      expect(editable.obscureText, isFalse);
    });

    testWidgets('pin field limits to digits and maxLength', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldsFactory.pin(
              controller: controller,
              obscureText: true,
              onToggleVisibility: () {},
              maxLength: 5,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '12ab34');
      await tester.pump();

      // DigitsOnly formatter should remove non-digits.
      expect(controller.text, '1234');
    });
  });
}
