import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/add_item.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/field_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Checking dropdown visibility', (test) async {    
    await test.pumpWidget(const MaterialApp(home: AddItem(),));

    final Visibility visibility = test.widget(find.byKey(CoreKeys.visibilityDropDownAddItem));
    expect(visibility.visible, false);
  });

  testWidgets('Testing form field to add the group referring to the item', (test) async {
    await test.pumpWidget(const MaterialApp(home: AddItem(),));

    final FieldCustom fieldCustomNewGroup = test.widget(find.byKey(CoreKeys.fieldCustomAddNewGroup));
    expect(fieldCustomNewGroup.title, CoreStrings.addNewGroup);
    expect(fieldCustomNewGroup.label, CoreStrings.labelGroup);
    expect(fieldCustomNewGroup.keyboardType, TextInputType.name);

    await test.enterText(find.byKey(CoreKeys.fieldCustomAddNewGroup), 'Teste');
    await test.pump();
    expect(find.text('Teste'), findsOneWidget);
  });

  testWidgets('Testing form field for item creation service', (test) async {
    await test.pumpWidget(const MaterialApp(home: AddItem(),));

    final FieldCustom fieldCustomService = test.widget(find.byKey(CoreKeys.fieldCustomService));
    expect(fieldCustomService.title, CoreStrings.nameService);
    expect(fieldCustomService.label, CoreStrings.labelService);
    expect(fieldCustomService.keyboardType, TextInputType.name);

    await test.enterText(find.byKey(CoreKeys.fieldCustomService), 'Teste');
    await test.pump();
    expect(find.text('Teste'), findsOneWidget);
  });

  testWidgets('Testing form field for item creation website', (test) async {
    await test.pumpWidget(const MaterialApp(home: AddItem(),));

    final FieldCustom fieldCustomWebSite = test.widget(find.byKey(CoreKeys.fieldCustomWebSite));
    expect(fieldCustomWebSite.title, CoreStrings.webSite);
    expect(fieldCustomWebSite.label, CoreStrings.labelWebSite);
    expect(fieldCustomWebSite.keyboardType, TextInputType.url);

    await test.enterText(find.byKey(CoreKeys.fieldCustomWebSite), 'Teste');
    await test.pump();
    expect(find.text('Teste'), findsOneWidget);
  });

  testWidgets('Testing form field for the email registered for item creation', (test) async {
    await test.pumpWidget(const MaterialApp(home: AddItem(),));

    final FieldCustom fieldCustomEmailRegister = test.widget(find.byKey(CoreKeys.fieldCustomEmailRegister));
    expect(fieldCustomEmailRegister.title, CoreStrings.emailRegister);
    expect(fieldCustomEmailRegister.label, CoreStrings.labelEmailRegister);
    expect(fieldCustomEmailRegister.keyboardType, TextInputType.emailAddress);

    await test.enterText(find.byKey(CoreKeys.fieldCustomEmailRegister), 'Teste');
    await test.pump();
    expect(find.text('Teste'), findsOneWidget);
  });

  testWidgets('Testing formfield for item creation login', (test) async {
    await test.pumpWidget(const MaterialApp(home: AddItem(),));

    final FieldCustom fieldCustomLogin = test.widget(find.byKey(CoreKeys.fieldCustomLogin));
    expect(fieldCustomLogin.title, CoreStrings.login);
    expect(fieldCustomLogin.keyboardType, TextInputType.text);

    await test.enterText(find.byKey(CoreKeys.fieldCustomLogin), 'Teste');
    await test.pump();
    expect(find.text('Teste'), findsOneWidget);
  });

  testWidgets('Testing formfield for item creation password', (test) async {
    await test.pumpWidget(const MaterialApp(home: AddItem(),));

    final FieldCustom fieldCustomPassword = test.widget(find.byKey(CoreKeys.fieldCustomPassword));
    expect(fieldCustomPassword.title, CoreStrings.password);
    expect(fieldCustomPassword.keyboardType, TextInputType.text);
    expect(fieldCustomPassword.obscureText, true);

    final iconVisibilityPasswordLogin = find.byKey(CoreKeys.visibilityPasswordAddItem);
    expect(iconVisibilityPasswordLogin, findsOneWidget);

    final IconButtonCustom icon = test.widget(iconVisibilityPasswordLogin);
    expect(icon.color, CoreColors.textPrimary);
    expect(icon.icon, CoreIcons.visibility);

    await test.enterText(find.byKey(CoreKeys.fieldCustomPassword), 'Teste');
    await test.pump();
    expect(find.text('Teste'), findsOneWidget);
  });

  testWidgets('Testing the properties of the button to create item', (test) async {
    await test.pumpWidget(const MaterialApp(home: AddItem(),));

    final ButtonCustom buttonAddItem = test.widget(find.byKey(CoreKeys.buttonCustomCreateItem));
    expect(buttonAddItem.height, 50);
    expect(buttonAddItem.backgroundButton, CoreColors.buttonColorSecond);
    expect(buttonAddItem.text, CoreStrings.save);
    expect(buttonAddItem.colorText, CoreColors.textPrimary);
    expect(buttonAddItem.fontSize, 16);
  });
}