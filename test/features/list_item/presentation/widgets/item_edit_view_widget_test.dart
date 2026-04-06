import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/list_item/presentation/widgets/item_edit_view_widget.dart';

import '../../../../test_utils/widget_test_pump.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _app(Widget child) => MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));

  group('ItemEditViewWidget (widget)', () {
    testWidgets('renders fields and does not crash when selectedType is not in options', (tester) async {
      final groupController = TextEditingController();
      final serviceController = TextEditingController();
      final siteController = TextEditingController();
      final emailController = TextEditingController();
      final loginController = TextEditingController();
      final passwordController = TextEditingController();
      addTearDown(groupController.dispose);
      addTearDown(serviceController.dispose);
      addTearDown(siteController.dispose);
      addTearDown(emailController.dispose);
      addTearDown(loginController.dispose);
      addTearDown(passwordController.dispose);

      await tester.pumpWidget(
        _app(
          ItemEditViewWidget(
            groupController: groupController,
            serviceController: serviceController,
            siteController: siteController,
            emailController: emailController,
            loginController: loginController,
            passwordController: passwordController,
            groupOptions: const ['Email', 'Social'],
            selectedType: 'NotExists',
          ),
        ),
      );

      expect(find.text(CoreStrings.selectGroup), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.text(CoreStrings.service), findsOneWidget);
      expect(find.text(CoreStrings.login), findsOneWidget);
    });

    testWidgets('selecting group option updates groupController.text', (tester) async {
      final groupController = TextEditingController();
      final serviceController = TextEditingController();
      final siteController = TextEditingController();
      final emailController = TextEditingController();
      final loginController = TextEditingController();
      final passwordController = TextEditingController();
      addTearDown(groupController.dispose);
      addTearDown(serviceController.dispose);
      addTearDown(siteController.dispose);
      addTearDown(emailController.dispose);
      addTearDown(loginController.dispose);
      addTearDown(passwordController.dispose);

      await tester.pumpWidget(
        _app(
          ItemEditViewWidget(
            groupController: groupController,
            serviceController: serviceController,
            siteController: siteController,
            emailController: emailController,
            loginController: loginController,
            passwordController: passwordController,
            groupOptions: const ['Email', 'Social'],
            selectedType: 'Email',
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await pumpModal(tester);

      await tester.tap(find.text('Social').last);
      await pumpModal(tester);

      expect(groupController.text, 'Social');
    });
  });
}
