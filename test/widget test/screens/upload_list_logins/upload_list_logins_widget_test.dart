import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/upload_list_logins.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

void main() {

  group('s', () { 
    testWidgets('Testing button to load list of logins for upload', (test) async {
      await test.pumpWidget(const MaterialApp(home: UploadListLogins()));

      final ButtonCustom buttonCustom = test.widget(find.byKey(CoreKeys.buttonLoadUploadList));
      expect(buttonCustom.backgroundButton, CoreColors.buttonColorSecond);
      expect(buttonCustom.text, CoreStrings.load);
      expect(buttonCustom.fontSize, 16);
      expect(buttonCustom.colorText, CoreColors.textPrimary);
    });

    testWidgets('Testing the button to cancel list loading', (test) async {
      await test.pumpWidget(const MaterialApp(home: UploadListLogins()));

      final TextButtonCustom textButtonCustom = test.widget(find.byKey(CoreKeys.cancelUploadList));
      expect(textButtonCustom.colorText, CoreColors.textTertiary);
      expect(textButtonCustom.text, CoreStrings.cancel);
      expect(textButtonCustom.fontSize, 16);
    });

    testWidgets('Testing button to choose the list to be loaded', (test) async {
      await test.pumpWidget(const MaterialApp(home: UploadListLogins()));

      final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.iconUploadList));
      expect(iconButtonCustom.icon, CoreIcons.upload);
      expect(iconButtonCustom.iconSize, 30);
    });

    testWidgets('FormField to load the path of the chosen list to be loaded.', (test) async {
      await test.pumpWidget(const MaterialApp(home: UploadListLogins()));

      final TextFormFieldCustom formField = test.widget(find.byKey(CoreKeys.formFieldFileUpload));
      expect(formField.readOnly, true);
      expect(formField.label, '');
      expect(formField.fillColor, CoreColors.buttonColorPrimary);
    });

    testWidgets('Testing subtitle properties to load list', (test) async {
      await test.pumpWidget(const MaterialApp(home: UploadListLogins()));

      final TextCustom textCustom = test.widget(find.byKey(CoreKeys.subtitleLoadList));
      expect(textCustom.text, CoreStrings.chooseFileUpload);
      expect(textCustom.fontSize, 16);
      expect(textCustom.color, CoreColors.textSecundary);
    });

    testWidgets('Testing the iconbutton to open information about loading a saved list', (test) async {
      await test.pumpWidget(const MaterialApp(home: UploadListLogins()));

      final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.iconInfoLoadList));
      expect(iconButtonCustom.icon, CoreIcons.info);
    });

    testWidgets('Testing title properties for loading saved list.', (test) async {
      await test.pumpWidget(const MaterialApp(home: UploadListLogins()));

      final TextCustom textCustom = test.widget(find.byKey(CoreKeys.titleLoadList));
      expect(textCustom.color, CoreColors.textSecundary);
      expect(textCustom.text, CoreStrings.loadList);
    });

    testWidgets('Testing properties of the alert screen regarding saved list loading information', (test) async {
      await test.pumpWidget(const MaterialApp(home: UploadListLogins()));

      await test.tap(find.byKey(CoreKeys.iconInfoLoadList));
      await test.pump();

      final InfoDialog infoDialog = test.widget(find.byKey(CoreKeys.alertInfoLoadList));
      expect(infoDialog.title, CoreStrings.info);
      expect(infoDialog.content, CoreStrings.infoChooseFileUpload);

      final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.buttonArrowBackPrivateInfoDialog));
      expect(iconButtonCustom.icon, CoreIcons.arrowBack);
      expect(iconButtonCustom.color, CoreColors.textPrimary);
    });
  });
  
}