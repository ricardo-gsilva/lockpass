import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/delete_account_bottom_sheet.dart';

import '../../test_config_fakes.dart';
import '../../../../../test_utils/widget_test_pump.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeleteAccountBottomSheet (widget)', () {
    testWidgets('tapping delete calls controller.deleteAccount and navigates to login', (tester) async {
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
              child: const DeleteAccountBottomSheet(),
            ),
          ),
        ),
      );
      await pumpModal(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, CoreStrings.delete));
      await pumpModal(tester);

      expect(controller.deleteAccountCalls, 1);
      expect(find.byKey(const Key('login-page')), findsOneWidget);
    });
  });
}
