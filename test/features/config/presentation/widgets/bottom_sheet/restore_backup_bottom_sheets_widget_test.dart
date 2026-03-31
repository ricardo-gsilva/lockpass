import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/restore_backup_automatic_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/restore_backup_choice_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/restore_backup_manual_bottom_sheet.dart';

import '../../test_config_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Restore backup bottom sheets (widget)', () {
    testWidgets('choice sheet opens manual sheet and restore flow works', (tester) async {
      final controller = TestConfigController();
      controller.selectZipFileReturnPath = '/tmp/backup.zip';
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          home: OpenBottomSheetHost(
            child: BlocProvider<ConfigController>.value(
              value: controller,
              child: const RestoreBackupChoiceBottomSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(CoreStrings.manualBackup));
      await tester.pumpAndSettle();

      expect(find.byType(RestoreBackupManualBottomSheet), findsOneWidget);

      await tester.tap(find.byKey(CoreKeys.iconUploadList));
      await tester.pumpAndSettle();
      expect(controller.selectZipFileCalls, 1);

      await tester.tap(find.byKey(CoreKeys.buttonLoadUploadList));
      await tester.pumpAndSettle();

      expect(controller.lastRestoreManualBackupPath, '/tmp/backup.zip');
      expect(find.byType(RestoreBackupManualBottomSheet), findsNothing);
    });

    testWidgets('choice sheet opens automatic sheet and load calls controller.restoreAutomaticBackup', (tester) async {
      final controller = TestConfigController();
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          home: OpenBottomSheetHost(
            child: BlocProvider<ConfigController>.value(
              value: controller,
              child: const RestoreBackupChoiceBottomSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(CoreStrings.automaticBackup));
      await tester.pumpAndSettle();

      expect(find.byType(RestoreBackupAutomaticBottomSheet), findsOneWidget);

      await tester.tap(find.byKey(CoreKeys.buttonLoadUploadList));
      await tester.pumpAndSettle();

      expect(controller.restoreAutomaticBackupCalls, 1);
      expect(find.byType(RestoreBackupAutomaticBottomSheet), findsNothing);
    });
  });
}
