import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/login_page.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

void main() {
  testWidgets('Looking for widget with app icon', (test) async {
    await test.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));

    final finderSizedBox = find.byKey(CoreKeys.appIconLoginPage);
    expect(finderSizedBox, findsOneWidget);

    final SizedBox sized = test.widget(finderSizedBox);
    expect(sized.height, 200);
    expect(find.image(const AssetImage(CoreStrings.iconApp)), findsOneWidget);
  });
  group('Testins.password screen widgets with Email and Password', () {
    testWidgets('Testing textformfield reference icons', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: LoginPage(),
      ));

      final finderIconPerson = find.byIcon(Icons.person);
      expect(finderIconPerson, findsOneWidget);

      final Icon iconPerson = test.widget(finderIconPerson);
      expect(iconPerson.color, CoreColors.textSecundary);

      final finderIconLock = find.byIcon(Icons.lock);
      expect(finderIconLock, findsOneWidget);

      final Icon iconLock = test.widget(finderIconPerson);
      expect(iconLock.color, CoreColors.textSecundary);
    });

    group('Finding loginpage textformfields', () {
      testWidgets('Testing email textformfield properties', (test) async {
        await test.pumpWidget(const MaterialApp(
          home: LoginPage(),
        ));

        final formFieldLogin = find.byKey(CoreKeys.formFieldEmailLoginPage);
        expect(formFieldLogin, findsOneWidget);

        final TextFormFieldCustom formLogin = test.widget(formFieldLogin);
        expect(formLogin.label, CoreStrings.login);
        expect(formLogin.keyboardType, TextInputType.emailAddress);
        expect(formLogin.colorTextLabel, CoreColors.textSecundary);
        expect(formLogin.cursorColor, CoreColors.textSecundary);
        expect(formLogin.colorTextInput, CoreColors.textSecundary);
        expect(formLogin.colorBorder, CoreColors.textSecundary);
        expect(formLogin.colorErrorText, CoreColors.textSecundary);

        await test.enterText(find.byKey(CoreKeys.formFieldEmailLoginPage), 'Teste');
        await test.pump();
        expect(find.text('Teste'), findsOneWidget);
      });

      testWidgets('Testing password textformfield properties', (test) async {
        await test.pumpWidget(const MaterialApp(
          home: LoginPage(),
        ));
        final formFieldPassword =
            find.byKey(CoreKeys.formFieldPasswordLoginPage);
        expect(formFieldPassword, findsOneWidget);

        final TextFormFieldCustom formPassword = test.widget(formFieldPassword);
        expect(formPassword.label, CoreStrings.password);
        expect(formPassword.colorTextLabel, CoreColors.textSecundary);
        expect(formPassword.cursorColor, CoreColors.textSecundary);
        expect(formPassword.colorTextInput, CoreColors.textSecundary);
        expect(formPassword.colorBorder, CoreColors.textSecundary);
        expect(formPassword.obscureText, true);

        final iconVisibilityPasswordLogin = find.byKey(CoreKeys.iconVisibilityPasswordLogin);
        expect(iconVisibilityPasswordLogin, findsOneWidget);

        final IconButtonCustom icon = test.widget(iconVisibilityPasswordLogin);
        expect(icon.color, CoreColors.textSecundary);
        expect(icon.icon, CoreIcons.visibility);

        await test.enterText(find.byKey(CoreKeys.formFieldPasswordLoginPage), 'Teste');
        await test.pump();
        expect(find.text('Teste'), findsOneWidget);
      });
    });

    testWidgets('Checking the textbutton properties for registration',
        (test) async {
      await test.pumpWidget(const MaterialApp(
        home: LoginPage(),
      ));

      final finderCreateLogin = find.byKey(CoreKeys.registerHereLoginPage);
      expect(finderCreateLogin, findsOneWidget);

      final TextButtonCustom textButtonCustom = test.widget(finderCreateLogin);
      expect(textButtonCustom.text, CoreStrings.registerHere);
      expect(textButtonCustom.colorText, CoreColors.textSecundary);
    });

    testWidgets('Checking textbutton properties to recover password',
        (test) async {
      await test.pumpWidget(const MaterialApp(
        home: LoginPage(),
      ));

      final finderForgotPass = find.byKey(CoreKeys.forgotPasswordLoginPage);
      expect(finderForgotPass, findsOneWidget);

      final TextButtonCustom textButtonCustom = test.widget(finderForgotPass);
      expect(textButtonCustom.text, CoreStrings.forgotPassword);
      expect(textButtonCustom.colorText, CoreColors.textSecundary);
    });    

    testWidgets('Testing TextButton properties to enter PIN', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: LoginPage(),
      ));

      final finderTextEnterPin = find.byKey(CoreKeys.enterWithPinOrEmailLoginPage);
      expect(finderTextEnterPin, findsOneWidget);

      final TextButtonCustom textButtonCustom = test.widget(finderTextEnterPin);
      expect(textButtonCustom.text, CoreStrings.enterPin);
      expect(textButtonCustom.colorText, CoreColors.textSecundary);
    });
  });

  group('Testing screen widgets when choosing to enter with PIN', () {

    testWidgets('Testing input textformfield properties with PIN', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: LoginPage(),
      ));

      await test.tap(find.text(CoreStrings.enterPin));
      await test.pump();

      final TextFormFieldCustom textFormFieldCustom = test.widget(find.byKey(CoreKeys.formFieldPinLoginPage));
      expect(textFormFieldCustom.keyboardType, TextInputType.number);
      expect(textFormFieldCustom.label, CoreStrings.pin);
      expect(textFormFieldCustom.maxLength, 5);
      expect(textFormFieldCustom.colorTextLabel, CoreColors.textSecundary);
      expect(textFormFieldCustom.cursorColor, CoreColors.textSecundary);
      expect(textFormFieldCustom.colorTextInput, CoreColors.textSecundary);
      expect(textFormFieldCustom.colorBorder, CoreColors.textSecundary);
      expect(textFormFieldCustom.colorErrorText, CoreColors.textSecundary);

      await test.enterText(find.byKey(CoreKeys.formFieldPinLoginPage), 'Teste');
      await test.pump();
      expect(find.text('Teste'), findsOneWidget);
    });

    testWidgets('Testing text property and text color of "Forgot your pin" textbutton', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: LoginPage(),
      ));

      await test.tap(find.text(CoreStrings.enterPin));
      await test.pump();

      final finderForgotPin = find.text(CoreStrings.forgotPin);
      expect(finderForgotPin, findsOneWidget);

      final TextButtonCustom textButtonCustom = test.widget(find.byKey(CoreKeys.forgotPinLoginPage));
      expect(textButtonCustom.text, CoreStrings.forgotPin);
      expect(textButtonCustom.colorText, CoreColors.textSecundary);
    });
  });

  testWidgets('Testing Login button properties', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: LoginPage(),
      ));

      final finderEnterButton = find.byKey(CoreKeys.buttonEnterLoginPage);
      expect(finderEnterButton, findsOneWidget);

      final ButtonCustom buttonCustom = test.widget(finderEnterButton);
      expect(buttonCustom.height, 50);
      expect(buttonCustom.backgroundButton, CoreColors.buttonColorSecond);
      expect(buttonCustom.text, CoreStrings.enter);
      expect(buttonCustom.colorText, CoreColors.textPrimary);
      expect(buttonCustom.fontSize, 18);
    });
  
  testWidgets('Testing TextButton properties to enter Login', (test) async {
      await test.pumpWidget(const MaterialApp(
        home: LoginPage(),
      ));

      await test.tap(find.text(CoreStrings.enterPin));
      await test.pump();

      final finderTextEnterPin = find.byKey(CoreKeys.enterWithPinOrEmailLoginPage);
      expect(finderTextEnterPin, findsOneWidget);

      final TextButtonCustom textButtonCustom = test.widget(finderTextEnterPin);
      expect(textButtonCustom.text, CoreStrings.enterLogin);
      expect(textButtonCustom.colorText, CoreColors.textSecundary);
    });
}
