import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/remove_pin_bottom_sheet.dart';

import '../../test_config_fakes.dart';
import '../../../../../test_utils/widget_test_pump.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RemovePinBottomSheet (widget)', () {
    testWidgets('submits pin and closes on success', (tester) async {
      final controller = TestConfigController();
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          home: OpenBottomSheetHost(
            child: BlocProvider<ConfigController>.value(
              value: controller,
              child: const RemovePinBottomSheet(),
            ),
          ),
        ),
      );
      await pumpModal(tester);

      await tester.enterText(find.byType(TextFormField), '13579');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, CoreStrings.removePinAction));
      await pumpModal(tester);
      await flushToasts(tester);

      expect(controller.lastConfirmAndRemovePinArg, '13579');
      expect(find.byType(RemovePinBottomSheet), findsNothing);
    });
  });
}
