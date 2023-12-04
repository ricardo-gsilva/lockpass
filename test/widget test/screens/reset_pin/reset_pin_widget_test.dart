import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/reset_pin.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

void main() {
  testWidgets('Check the title text on the screen to reset the pin', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPin(),
    ));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.titleResetPin));
    expect(textCustom.text, CoreStrings.resetPin);
    expect(textCustom.color, CoreColors.textSecundary);
  });

  testWidgets('Confirming information iconbutton icon', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPin(),
    ));

    final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.infoButtonResetPin));
    expect(iconButtonCustom.icon, CoreIcons.info);
  });

  testWidgets('Testing information screen widgets to create a new PIN', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPin(),
    ));

    await test.tap(find.byKey(CoreKeys.infoButtonResetPin));
    await test.pump();

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.titleInfoResetPin));
    expect(textCustom.text, CoreStrings.info);

    final TextCustom textCustom1 = test.widget(find.byKey(CoreKeys.infoResetPin));
    expect(textCustom1.text, CoreStrings.needCreateNewPin);

    final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.arrowBackButtonInfoResetPin));
    expect(iconButtonCustom.icon, CoreIcons.arrowBack);
    expect(iconButtonCustom.color, CoreColors.textPrimary);
  });

  group('Testing the textformfield to reset the PIN', () { 
    testWidgets('Testing whether the email textformfield contains all properties', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: ResetPin(),
      ));

      final TextFormFieldCustom textFormFieldCustomEmail = test.widget(find.byKey(CoreKeys.textFormFieldEmailResetPin));

      expect(textFormFieldCustomEmail.label, CoreStrings.login);
      expect(textFormFieldCustomEmail.colorTextLabel, CoreColors.textSecundary);
      expect(textFormFieldCustomEmail.cursorColor, CoreColors.textSecundary);
      expect(textFormFieldCustomEmail.colorTextInput, CoreColors.textSecundary);
      expect(textFormFieldCustomEmail.colorBorder, CoreColors.textSecundary);
      expect(textFormFieldCustomEmail.colorErrorText, CoreColors.textSecundary);

      await test.enterText(find.byKey(CoreKeys.textFormFieldEmailResetPin), 'Teste');
      await test.pump();
      expect(find.text('Teste'), findsOneWidget);
    });

    testWidgets('Testing whether the password textformfield contains all properties', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: ResetPin(),
      ));

      final TextFormFieldCustom textFormFieldCustomEmail = test.widget(find.byKey(CoreKeys.textFormFieldPasswordResetPin));

      expect(textFormFieldCustomEmail.label, CoreStrings.password);
      expect(textFormFieldCustomEmail.colorTextLabel, CoreColors.textSecundary);
      expect(textFormFieldCustomEmail.cursorColor, CoreColors.textSecundary);
      expect(textFormFieldCustomEmail.colorTextInput, CoreColors.textSecundary);
      expect(textFormFieldCustomEmail.colorBorder, CoreColors.textSecundary);
      expect(textFormFieldCustomEmail.colorErrorText, CoreColors.textSecundary);
      expect(textFormFieldCustomEmail.obscureText, true);

      final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.iconButtonVisibilityResetPin));
      expect(iconButtonCustom.icon, CoreIcons.visibility);
      expect(iconButtonCustom.color, CoreColors.textSecundary);

      await test.enterText(find.byKey(CoreKeys.textFormFieldPasswordResetPin), 'Teste');
      await test.pump();
      expect(find.text('Teste'), findsOneWidget);
    });
  });

  testWidgets('Checking textButton properties to recover password', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPin(),
    ));

    final TextButtonCustom textButtonCustom = test.widget(find.byKey(CoreKeys.forgotPasswordResetPin));
    expect(textButtonCustom.text, CoreStrings.forgotPassword);
    expect(textButtonCustom.colorText, CoreColors.textSecundary);
  });

  testWidgets('Checking iconbutton property to return to screen', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: ResetPin(),
    ));

    final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.arrowBackButtonResetPin));
    expect(iconButtonCustom.icon, CoreIcons.arrowBack);
  });

  testWidgets('Checking properties of the confirmation button to reset the PIN', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: ResetPin()
      ));

      final ButtonCustom buttonCustom = test.widget(find.byKey(CoreKeys.buttonSendResetPin));
      expect(buttonCustom.text, CoreStrings.send);
      expect(buttonCustom.colorText, CoreColors.textPrimary);
      expect(buttonCustom.fontSize, 16);
    });
}
