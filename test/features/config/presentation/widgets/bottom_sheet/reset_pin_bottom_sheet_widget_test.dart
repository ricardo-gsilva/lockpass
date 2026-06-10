import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/reset_pin_bottom_sheet.dart';

import '../../test_config_fakes.dart';
import '../../../../../test_utils/widget_test_pump.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ResetPinBottomSheet (widget)', () {
    testWidgets('toggles password visibility and calls controller.reauthenticate', (tester) async {
      final controller = TestConfigController(seed: const ConfigState(hasPin: true));
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppRoutes.navigatorKey,
          home: OpenBottomSheetHost(
            child: BlocProvider<ConfigController>.value(
              value: controller,
              child: const ResetPinBottomSheet(),
            ),
          ),
        ),
      );

      await pumpModal(tester);

      expect(find.text(CoreStrings.resetPinAction), findsWidgets);

      final emailFieldFinder = find.byType(TextFormField).at(0);
      final passwordFieldFinder = find.byType(TextFormField).at(1);

      EditableText passwordEditable = tester.widget(
        find.descendant(of: passwordFieldFinder, matching: find.byType(EditableText)),
      );
      expect(passwordEditable.obscureText, isFalse);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      passwordEditable = tester.widget(
        find.descendant(of: passwordFieldFinder, matching: find.byType(EditableText)),
      );
      expect(passwordEditable.obscureText, isTrue);

      await tester.enterText(emailFieldFinder, 'user@example.com');
      await tester.enterText(passwordFieldFinder, 'pw123456');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, CoreStrings.resetPinAction));
      await tester.pump();

      expect(controller.reauthenticateCalls, 1);
      expect(controller.lastReauthenticateArgs?.email, 'user@example.com');
      expect(controller.lastReauthenticateArgs?.password, 'pw123456');

      await flushToasts(tester);
    });
  });
}
