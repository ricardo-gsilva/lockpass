import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/ui/components/info_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InfoDialog (widget)', () {
    testWidgets('renders title, content and action widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoDialog(
              title: 'Title',
              content: 'Content',
              widgets: [
                TextButton(
                  onPressed: () {},
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });
  });
}

