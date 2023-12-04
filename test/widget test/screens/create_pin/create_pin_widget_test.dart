import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/config_page_store.dart';
import 'package:lockpass/screens/create_pin.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

void main() {
  testWidgets('Checking properties of the information alertDialog for creating the PIN', (test) async {
    await test.pumpWidget(MaterialApp(home: CreatePin()));

    await test.tap(find.byKey(CoreKeys.buttonInfoCreatePin));
    await test.pump();

    final InfoDialog infoDialog = test.widget(find.byKey(CoreKeys.alertDialogInfoCreatePin));
    expect(infoDialog.title, CoreStrings.info);
    expect(infoDialog.content, CoreStrings.pinInfo);

    final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.buttonArrowBackPrivateInfoDialog));
    expect(iconButtonCustom.icon, CoreIcons.arrowBack);
    expect(iconButtonCustom.color, CoreColors.textPrimary);
  });

  testWidgets('Checking title properties to create the PIN', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: CreatePin(title: configStore.textPin,)));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.titleCreatePin));
    expect(textCustom.text, configStore.textPin);
    expect(textCustom.fontSize, 18);
    expect(textCustom.color, CoreColors.textSecundary);
  });

  testWidgets('Check properties of the information iconButton for creating the PIN', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: CreatePin(title: configStore.textPin,)));

    final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.buttonInfoCreatePin));
    expect(iconButtonCustom.icon, CoreIcons.info);
    expect(iconButtonCustom.iconSize, 22);
    expect(iconButtonCustom.color, CoreColors.textSecundary);
  });

  testWidgets('Check properties of the information subtitle for creating the PIN.', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: CreatePin(title: configStore.textPin,)));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.subTitleCreatePin));
    expect(textCustom.text, CoreStrings.typeItPin);
    expect(textCustom.color, CoreColors.textSecundary);
  });

  testWidgets('Testing the textformfield to enter the PIN', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: CreatePin(title: configStore.textPin,)));

    final TextFormFieldCustom formField = test.widget(find.byKey(CoreKeys.formFieldCreatePin));
    expect(formField.keyboardType, TextInputType.number);
    expect(formField.maxLength, 5);
    expect(formField.label, CoreStrings.labelPin);
    expect(formField.colorTextInput, CoreColors.textSecundary);
    expect(formField.colorTextLabel, CoreColors.textSecundary);
    expect(formField.cursorColor, CoreColors.textSecundary);
    expect(formField.colorErrorText, CoreColors.textSecundary);
    expect(formField.colorBorder, CoreColors.textSecundary);

    await test.enterText(find.byKey(CoreKeys.formFieldCreatePin), '12345');
        await test.pump();
        expect(find.text('12345'), findsOneWidget);
  });

  testWidgets('Testing the cancel PIN creation button', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: CreatePin(title: configStore.textPin,)));

    final TextButtonCustom textButtonCustom = test.widget(find.byKey(CoreKeys.cancelCreatePin));
    expect(textButtonCustom.text, CoreStrings.cancel);
    expect(textButtonCustom.colorText, CoreColors.textTertiary);
    expect(textButtonCustom.fontSize, 16);
  });

  testWidgets('Testing button properties for creating the PIN', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: CreatePin(title: configStore.textPin,)));

    final ButtonCustom buttonCustom = test.widget(find.byKey(CoreKeys.buttonCreatePin));
    expect(buttonCustom.text, CoreStrings.save);
    expect(buttonCustom.colorText, CoreColors.textPrimary);
    expect(buttonCustom.fontSize, 16);
    expect(buttonCustom.backgroundButton, CoreColors.buttonColorSecond);
  });
}