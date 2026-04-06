import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/change_password_bottom_sheet.dart';

import '../../test_config_fakes.dart';
import '../../../../../test_utils/widget_test_pump.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChangePasswordBottomSheet (widget)', () {
    testWidgets('submits and navigates to login on success', (tester) async {
      final controller = TestConfigController();
      addTearDown(controller.close);

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.login: (_) => const Scaffold(body: Text('LOGIN', key: Key('login-page'))),
          },
          home: OpenBottomSheetHost(
            child: BlocProvider<ConfigController>.value(
              value: controller,
              child: const ChangePasswordBottomSheet(),
            ),
          ),
        ),
      );
      await pumpModal(tester);

      await tester.enterText(find.byType(TextFormField).at(0), 'abcdef');
      await tester.enterText(find.byType(TextFormField).at(1), 'abcdef');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, CoreStrings.change));
      await pumpModal(tester);

      expect(find.byKey(CoreKeys.alertDialogSaveList), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byKey(CoreKeys.alertDialogSaveList),
          matching: find.text(CoreStrings.change),
        ),
      );
      await pumpModal(tester);
      await flushToasts(tester);

      expect(controller.lastUpdatePasswordArgs?.currentPassword, 'abcdef');
      expect(controller.lastUpdatePasswordArgs?.newPassword, 'abcdef');
      expect(find.byKey(const Key('login-page')), findsOneWidget);
    });
  });
}
