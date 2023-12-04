import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/reset_password.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

void main() {
  testWidgets(
      'Confirming properties of the information text to reset the password',
      (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPassword(),
    ));

    final TextCustom textCustom =
        test.widget(find.byKey(CoreKeys.titleResetPassword));
    expect(textCustom.text, CoreStrings.resetPassword);
    expect(textCustom.color, CoreColors.textSecundary);
  });

  testWidgets('Checking information iconbutton icon', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPassword(),
    ));

    final IconButtonCustom iconButtonCustom =
        test.widget(find.byKey(CoreKeys.infoButtonResetPassword));
    expect(iconButtonCustom.icon, CoreIcons.info);
  });

  testWidgets(
      'Checking properties of the information screen to reset the password',
      (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPassword(),
    ));

    await test.tap(find.byIcon(CoreIcons.info));
    await test.pump();

    final InfoDialog infoDialog =
        test.widget(find.byKey(CoreKeys.infoDialogResetPassword));
    expect(infoDialog.title, CoreStrings.info);
    expect(infoDialog.content, CoreStrings.receivePasswordResetLink);

    final IconButtonCustom iconButtonCustom =
        test.widget(find.byKey(CoreKeys.buttonArrowBackPrivateInfoDialog));
    expect(iconButtonCustom.icon, CoreIcons.arrowBack);
  });

  testWidgets('Testing the email input textformfield to reset the password', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPassword(),
    ));

    final TextFormFieldCustom formFieldCustom = test.widget(find.byKey(CoreKeys.textFormFieldEmailResetPassword));    
      expect(formFieldCustom.cursorColor, CoreColors.textSecundary);
      expect(formFieldCustom.colorTextInput, CoreColors.textSecundary);
      expect(formFieldCustom.label, CoreStrings.emailRegistered);
      expect(formFieldCustom.colorTextLabel, Colors.white);
      expect(formFieldCustom.colorIcon, Colors.white);
      expect(formFieldCustom.colorBorder, CoreColors.textSecundary);
      expect(formFieldCustom.colorErrorText, CoreColors.textSecundary);
      expect(formFieldCustom.icons, CoreIcons.person);
      await test.enterText(find.byKey(CoreKeys.textFormFieldEmailResetPassword), 'Teste');
      await test.pump();
      expect(find.text('Teste'), findsOneWidget);
  });

  testWidgets('Testing the back button and its properties, to cancel the password reset process', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPassword(),
    ));

    final IconButtonCustom iconButtonCustom =
        test.widget(find.byKey(CoreKeys.arrowBackInfoResetPassword));
    expect(iconButtonCustom.icon, CoreIcons.arrowBack);
  });

  testWidgets('Testing properties of the button to send password reset email',
      (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPassword(),
    ));

    final ButtonCustom buttonCustom =
        test.widget(find.byKey(CoreKeys.buttonSendResetPassword));
    expect(buttonCustom.backgroundButton, CoreColors.buttonColorSecond);
    expect(buttonCustom.text, CoreStrings.send);
    expect(buttonCustom.colorText, CoreColors.textPrimary);
    expect(buttonCustom.fontSize, 16);
  });
}
