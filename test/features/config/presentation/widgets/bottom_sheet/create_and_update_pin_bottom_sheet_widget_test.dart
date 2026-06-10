import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/create_and_update_pin_bottom_sheet.dart';

import '../../test_config_fakes.dart';
import '../../../../../test_utils/widget_test_pump.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CreateAndUpdatePinBottomSheet (widget)', () {
    testWidgets('enables save when new pin is valid and calls controller.savePin (create pin)', (tester) async {
      final controller = TestConfigController();
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          home: OpenBottomSheetHost(
            child: BlocProvider<ConfigController>.value(
              value: controller,
              child: const CreateAndUpdatePinBottomSheet(
                title: CoreStrings.registerPin,
                hasPin: false,
              ),
            ),
          ),
        ),
      );
      await pumpModal(tester);

      ElevatedButton saveButton = tester.widget(
        find.descendant(
          of: find.byKey(CoreKeys.buttonCreatePin),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(saveButton.onPressed, isNull);

      await tester.enterText(find.byType(TextFormField).first, '13579');
      await tester.pump();

      saveButton = tester.widget(
        find.descendant(
          of: find.byKey(CoreKeys.buttonCreatePin),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(saveButton.onPressed, isNotNull);

      await tester.tap(find.byKey(CoreKeys.buttonCreatePin));
      await pumpModal(tester);
      await flushToasts(tester);

      expect(controller.lastSavePinArgs?.newPin, '13579');
      expect(controller.lastSavePinArgs?.hasPin, isFalse);
      expect(find.byType(CreateAndUpdatePinBottomSheet), findsNothing);
    });

    testWidgets('requires current pin when hasPin is true (update pin)', (tester) async {
      final controller = TestConfigController(seed: const ConfigState(hasPin: true));
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          home: OpenBottomSheetHost(
            child: BlocProvider<ConfigController>.value(
              value: controller,
              child: const CreateAndUpdatePinBottomSheet(
                title: CoreStrings.updatePin,
                hasPin: true,
              ),
            ),
          ),
        ),
      );
      await pumpModal(tester);

      // Two fields: current pin (keyed) and new pin.
      await tester.enterText(find.byType(TextFormField).at(0), '24680');
      await tester.enterText(find.byType(TextFormField).at(1), '13579');
      await tester.pump();

      await tester.tap(find.byKey(CoreKeys.buttonCreatePin));
      await pumpModal(tester);
      await flushToasts(tester);

      expect(controller.lastSavePinArgs?.currentPin, '24680');
      expect(controller.lastSavePinArgs?.newPin, '13579');
      expect(controller.lastSavePinArgs?.hasPin, isTrue);
      expect(find.byType(CreateAndUpdatePinBottomSheet), findsNothing);
    });
  });
}
