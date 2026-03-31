import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/lock_timeout_bottom_sheet.dart';

import '../../test_config_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LockTimeoutBottomSheet (widget)', () {
    testWidgets('tapping a duration calls controller.setLockTimeout and closes on success', (tester) async {
      final controller = TestConfigController(lockTimeoutValue: 0);
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          home: OpenBottomSheetHost(
            child: BlocProvider<ConfigController>.value(
              value: controller,
              child: const LockTimeoutBottomSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(CoreStrings.duration15s));
      await tester.pumpAndSettle();

      expect(controller.setLockTimeoutCalls, 1);
      expect(controller.lastSetLockTimeoutArg, 15);
      expect(find.byType(LockTimeoutBottomSheet), findsNothing);
    });
  });
}
