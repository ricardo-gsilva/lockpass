import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/page/config_page.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/widgets/config_options_custom.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/change_password_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/create_and_update_pin_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/delete_account_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/lock_timeout_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/logout_app_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/remove_pin_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/restore_backup_choice_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/save_list_logins_bottom_sheet.dart';

import '../test_config_fakes.dart';
import '../../../../test_utils/widget_test_pump.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _app(Widget child) => MaterialApp(home: child);

  Finder _tapTarget(Key key) {
    return find.descendant(of: find.byKey(key), matching: find.byType(TextButton));
  }

  Finder _deletePinVisibility() {
    return find.byWidgetPredicate(
      (w) => w is Visibility && w.key == CoreKeys.visibilityDeletePinConfig,
    );
  }

  Finder _deletePinConfigOption() {
    return find.byWidgetPredicate(
      (w) => w is ConfigOptions && w.key == CoreKeys.deletePinConfig,
    );
  }

  group('ConfigPage (widget)', () {
    testWidgets('hides delete pin option when hasPin is false', (tester) async {
      final controller = TestConfigController(seed: const ConfigState(hasPin: false));
      addTearDown(controller.close);

      await tester.pumpWidget(_app(ConfigPage(controller: controller)));
      await tester.pump();

      final visibility = tester.widget<Visibility>(_deletePinVisibility());
      expect(visibility.visible, isFalse);
    });

    testWidgets('shows delete pin option when hasPin is true', (tester) async {
      final controller = TestConfigController(seed: const ConfigState(hasPin: true));
      addTearDown(controller.close);

      await tester.pumpWidget(_app(ConfigPage(controller: controller)));
      await tester.pump();

      final visibility = tester.widget<Visibility>(_deletePinVisibility());
      expect(visibility.visible, isTrue);
    });

    testWidgets('opens expected bottom sheets from options', (tester) async {
      final controller = TestConfigController(seed: const ConfigState(hasPin: true));
      addTearDown(controller.close);

      await tester.pumpWidget(_app(ConfigPage(controller: controller)));
      await tester.pump();

      await tester.tap(_tapTarget(CoreKeys.createPinConfig));
      await pumpModal(tester);
      expect(find.byType(CreateAndUpdatePinBottomSheet), findsOneWidget);
      Navigator.of(tester.element(find.byType(CreateAndUpdatePinBottomSheet))).pop();
      await pumpModal(tester);

      await tester.tap(find.descendant(of: _deletePinConfigOption(), matching: find.byType(TextButton)));
      await pumpModal(tester);
      expect(find.byType(RemovePinBottomSheet), findsOneWidget);
      Navigator.of(tester.element(find.byType(RemovePinBottomSheet))).pop();
      await pumpModal(tester);

      await tester.tap(_tapTarget(CoreKeys.saveListLoginConfig));
      await pumpModal(tester);
      expect(find.byType(SaveListLoginsBottomSheet), findsOneWidget);
      Navigator.of(tester.element(find.byType(SaveListLoginsBottomSheet))).pop();
      await pumpModal(tester);

      await tester.tap(_tapTarget(CoreKeys.updateListConfig));
      await pumpModal(tester);
      expect(find.byType(RestoreBackupChoiceBottomSheet), findsOneWidget);
      Navigator.of(tester.element(find.byType(RestoreBackupChoiceBottomSheet))).pop();
      await pumpModal(tester);

      await tester.tap(find.text(CoreStrings.changePasswordAction));
      await pumpModal(tester);
      expect(find.byType(ChangePasswordBottomSheet), findsOneWidget);
      Navigator.of(tester.element(find.byType(ChangePasswordBottomSheet))).pop();
      await pumpModal(tester);

      await tester.tap(find.text(CoreStrings.screenLockTimer));
      await pumpModal(tester);
      expect(find.byType(LockTimeoutBottomSheet), findsOneWidget);
      Navigator.of(tester.element(find.byType(LockTimeoutBottomSheet))).pop();
      await pumpModal(tester);

      await tester.tap(_tapTarget(CoreKeys.logoutConfig));
      await pumpModal(tester);
      expect(find.byType(LogoutAppBottomSheet), findsOneWidget);
      Navigator.of(tester.element(find.byType(LogoutAppBottomSheet))).pop();
      await pumpModal(tester);

      await tester.tap(_tapTarget(CoreKeys.deleteAccount));
      await pumpModal(tester);
      expect(find.byType(DeleteAccountBottomSheet), findsOneWidget);
    });
  });
}
