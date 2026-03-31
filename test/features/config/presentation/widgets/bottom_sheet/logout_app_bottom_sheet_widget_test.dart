import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/logout_app_bottom_sheet.dart';

import '../../test_config_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LogoutAppBottomSheet (widget)', () {
    testWidgets('tapping logout calls controller.signOut and navigates to login', (tester) async {
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
              child: const LogoutAppBottomSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(); // open sheet

      await tester.tap(find.widgetWithText(ElevatedButton, CoreStrings.logoutAction));
      await tester.pumpAndSettle();

      expect(controller.signOutCalls, 1);
      expect(find.byKey(const Key('login-page')), findsOneWidget);
    });
  });
}
