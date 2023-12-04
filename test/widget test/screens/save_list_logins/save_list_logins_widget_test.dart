import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/save_list_logins.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';

void main() {
  testWidgets('Testing screen title display to save login list', (test) async {
    await test.pumpWidget(const MaterialApp(home: SaveListLogins()));

    final TextCustom textCustom =
        test.widget(find.byKey(CoreKeys.titleSaveListLogin));
    expect(textCustom.color, CoreColors.textSecundary);
    expect(textCustom.text, CoreStrings.saveList);
    expect(textCustom.fontSize, 18);
  });

  testWidgets(
      'Testing display of the screen information button to save login list',
      (test) async {
    await test.pumpWidget(const MaterialApp(home: SaveListLogins()));

    final IconButtonCustom iconButtonCustom =
        test.widget(find.byKey(CoreKeys.buttonInfoSaveList));
    expect(iconButtonCustom.icon, CoreIcons.info);
  });

  testWidgets('Testing display of screen information text to save login list',
      (test) async {
    await test.pumpWidget(const MaterialApp(home: SaveListLogins()));

    final TextCustom textCustom =
        test.widget(find.byKey(CoreKeys.subTitleInfoSaveList));
    expect(textCustom.color, CoreColors.textSecundary);
    expect(textCustom.text, CoreStrings.wantSaveListLogin);
    expect(textCustom.fontSize, 15);
  });

  testWidgets(
      'Testing the display of the button to cancel saving the login list',
      (test) async {
    await test.pumpWidget(const MaterialApp(home: SaveListLogins()));

    final TextButtonCustom textButtonCustom =
        test.widget(find.byKey(CoreKeys.cancelSaveList));
    expect(textButtonCustom.text, CoreStrings.cancel);
    expect(textButtonCustom.colorText, CoreColors.textTertiary);
    expect(textButtonCustom.fontSize, 16);
  });

  testWidgets('Testing display of the button to save login list', (test) async {
    await test.pumpWidget(const MaterialApp(home: SaveListLogins()));

    final ButtonCustom buttonCustom =
        test.widget(find.byKey(CoreKeys.buttonSaveList));
    expect(buttonCustom.text, CoreStrings.save);
    expect(buttonCustom.colorText, CoreColors.textPrimary);
    expect(buttonCustom.fontSize, 16);
    expect(buttonCustom.backgroundButton, CoreColors.buttonColorSecond);
  });
  testWidgets('Testing information screen to save login list', (test) async {
    await test.pumpWidget(const MaterialApp(home: SaveListLogins()));

    await test.tap(find.byKey(CoreKeys.buttonInfoSaveList));
    await test.pump();

    final InfoDialog infoDialog =
        test.widget(find.byKey(CoreKeys.alertDialogInfoSaveList));
    expect(infoDialog.title, CoreStrings.info);
    expect(infoDialog.content, CoreStrings.infoSaveList);
  });
}
