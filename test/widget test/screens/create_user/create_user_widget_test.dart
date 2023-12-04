import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/create_user.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

void main() {
  testWidgets('Confirming screen information title properties to create user', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: CreateUser(),
    ));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.titleCreateUser));
    expect(textCustom.text, CoreStrings.register1);
    expect(textCustom.color, CoreColors.textSecundary);
  });

  testWidgets('Testing the button to open the information screen to create user', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: CreateUser(),
    ));

    final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.infoButtonCreateUser));
    expect(iconButtonCustom.icon, CoreIcons.info);
  });

  testWidgets('Checking the properties of the information alertDialog for user creation', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: CreateUser(),
    ));

    await test.tap(find.byIcon(CoreIcons.info));
    await test.pump();

    final InfoDialog infoDialog = test.widget(find.byKey(CoreKeys.alertDialogInfoCreateUser));
    expect(infoDialog.title, CoreStrings.info);
    expect(infoDialog.content, CoreStrings.infoEmailInvalid);

    final IconButtonCustom iconButtonCustom =
        test.widget(find.byKey(CoreKeys.buttonArrowBackPrivateInfoDialog));
    expect(iconButtonCustom.icon, CoreIcons.arrowBack);
  });

  group('Checking both texformfield for user creation', () { 
    testWidgets('Checking the email textformfield properties for user creation', (test) async{
      await test.pumpWidget(const MaterialApp(
        home: CreateUser(),
      ));

      final TextFormFieldCustom formField = test.widget(find.byKey(CoreKeys.formFieldEmailCreateUser));
      expect(formField.label, CoreStrings.email);
      expect(formField.cursorColor, CoreColors.textSecundary);
      expect(formField.colorTextInput, CoreColors.textSecundary);
      expect(formField.colorTextLabel, CoreColors.textSecundary);
      expect(formField.colorBorder, CoreColors.textSecundary);
      expect(formField.colorErrorText, CoreColors.textSecundary);
      expect(formField.colorIcon, CoreColors.textSecundary);
      expect(formField.icons, CoreIcons.person);

      await test.enterText(find.byKey(CoreKeys.formFieldEmailCreateUser), 'Teste');
      await test.pump();
      expect(find.text('Teste'), findsOneWidget);
    });

    testWidgets('Checking the properties of the password textformfield for user creation', (test) async{
      await test.pumpWidget(const MaterialApp(
        home: CreateUser(),
      ));

      final TextFormFieldCustom formField = test.widget(find.byKey(CoreKeys.formFieldPasswordCreateUser));
      expect(formField.label, CoreStrings.password);
      expect(formField.cursorColor, CoreColors.textSecundary);
      expect(formField.colorTextInput, CoreColors.textSecundary);
      expect(formField.colorTextLabel, CoreColors.textSecundary);
      expect(formField.colorIcon, CoreColors.textSecundary);
      expect(formField.colorBorder, CoreColors.textSecundary);
      expect(formField.obscureText, true);

      await test.enterText(find.byKey(CoreKeys.formFieldPasswordCreateUser), 'Teste');
      expect(find.text('Teste'), findsOneWidget);

      final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.iconButtonVisibilityCreateUser));
      expect(iconButtonCustom.icon, CoreIcons.visibility);
      expect(iconButtonCustom.color, CoreColors.textSecundary);
    });
  });

    testWidgets('Checking iconbutton to close user creation', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: CreateUser(),
      ));

      final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.arrowBackButtonCreateUser));
      expect(iconButtonCustom.icon, CoreIcons.arrowBack);
    });

    testWidgets('Testing properties of the user creation button', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: CreateUser(),
      ));

      final ButtonCustom buttonCustom = test.widget(find.byKey(CoreKeys.buttonCreateUser));
      expect(buttonCustom.backgroundButton, CoreColors.buttonColorSecond);
      expect(buttonCustom.text, CoreStrings.register2);
      expect(buttonCustom.colorText, CoreColors.textPrimary);
      expect(buttonCustom.fontSize, 16);
    });


}
