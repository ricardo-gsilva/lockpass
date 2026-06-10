import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TextCustom (widget)', () {
    testWidgets('renders provided text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextCustom(text: 'Hello'),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('renders empty string when text is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextCustom(text: null),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.data, '');
    });
  });
}

