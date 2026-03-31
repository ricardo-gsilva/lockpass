import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/delete_item_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConfirmationBottomSheet (widget)', () {
    testWidgets('shows title/description and calls onConfirm', (tester) async {
      var confirmCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (_) => ConfirmationBottomSheet(
                          title: CoreStrings.delete,
                          description: CoreStrings.deleteThisLogin,
                          confirmButtonText: CoreStrings.moveToTrash,
                          onConfirm: () {
                            confirmCalls += 1;
                          },
                        ),
                      );
                    },
                    child: const Text('open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text(CoreStrings.delete), findsOneWidget);
      expect(find.text(CoreStrings.deleteThisLogin), findsOneWidget);
      expect(find.text(CoreStrings.cancel), findsOneWidget);
      expect(find.text(CoreStrings.moveToTrash), findsOneWidget);

      await tester.tap(find.text(CoreStrings.moveToTrash));
      await tester.pump();

      expect(confirmCalls, 1);

      await tester.tap(find.text(CoreStrings.cancel));
      await tester.pumpAndSettle();

      expect(find.text(CoreStrings.deleteThisLogin), findsNothing);
    });
  });
}

