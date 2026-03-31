import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/save_list_logins_bottom_sheet.dart';

import '../../test_config_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SaveListLoginsBottomSheet (widget)', () {
    testWidgets('tapping save to device calls controller.createManualBackup and shows confirmation dialog', (tester) async {
      final controller = TestConfigController();
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          home: OpenBottomSheetHost(
            child: BlocProvider<ConfigController>.value(
              value: controller,
              child: const SaveListLoginsBottomSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(CoreStrings.saveToDeviceAction));
      await tester.pumpAndSettle();

      expect(controller.createManualBackupCalls, 1);
      expect(find.byKey(CoreKeys.alertDialogSaveList), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byKey(CoreKeys.alertDialogSaveList),
          matching: find.text(CoreStrings.close),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SaveListLoginsBottomSheet), findsNothing);
    });
  });
}
