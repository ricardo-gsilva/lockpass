import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/home_page.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('AlertDialog arriving for PIN creation information', (test) async {
    await test.runAsync(() async {
      await test.pumpWidget(const MaterialApp(home: HomePage()));
    });

    await test.pumpAndSettle();

    final finderDialog = find.byKey(CoreKeys.alertDialogCreatePin);
    expect(finderDialog, findsOneWidget);
  });

  testWidgets('Testing iconApp in the AppBar', (test) async {
    await test.pumpWidget(const MaterialApp(home: HomePage()));

    final SizedBox sizedBox = test.widget(find.byKey(CoreKeys.sizedBoxIconApp));
    expect(sizedBox.height, 70);
    expect(find.image(const AssetImage(CoreStrings.iconApp)), findsOneWidget);
  });

  testWidgets('s', (test) async {
    await test.pumpWidget(const MaterialApp(home: HomePage()));

    await test.tap(find.byKey(CoreKeys.iconButtonSearch));
    await test.pump();


    final TextFormFieldCustom formField = test.widget(find.byKey(CoreKeys.formFieldSearchItem));
    expect(formField.label, CoreStrings.searchLogin);
    expect(formField.colorTextLabel, CoreColors.selectBorder);
    expect(formField.keyboardType, TextInputType.text);
    expect(formField.cursorColor, CoreColors.textPrimary);
    expect(formField.colorTextInput, CoreColors.textPrimary);
  });

  // testWidgets('s', (test) async {
  //   await test.pumpWidget(const MaterialApp(home: HomePage()));    

  //   final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.iconButtonSearch));
  //   expect(iconButtonCustom.icon, CoreIcons.search);
  //   expect(iconButtonCustom.color, CoreColors.textSecundary);
  // });

  testWidgets('s', (test) async {
    await test.pumpWidget(const MaterialApp(home: HomePage()));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.notFoundItem));
    expect(textCustom.text, CoreStrings.notFoundItem);
  });

  testWidgets('Testing bottomNavigationBar items', (test) async {
    await test.pumpWidget(const MaterialApp(home: HomePage()));

    final BottomNavigationBar bottomNavigationBar = test.widget(find.byKey(CoreKeys.bottomNavigationBar));
    expect(bottomNavigationBar.backgroundColor, CoreColors.primaryColor);
    expect(bottomNavigationBar.elevation, 2);
    expect(bottomNavigationBar.selectedItemColor, CoreColors.selectBottomBar);
    expect(bottomNavigationBar.unselectedItemColor, CoreColors.unselectBottomBar);

    final finderIconAdd = find.byIcon(CoreIcons.add);
    expect(finderIconAdd, findsOneWidget);

    final finderIconConfig = find.byIcon(CoreIcons.config);
    expect(finderIconConfig, findsOneWidget);

    final finderIconList = find.byIcon(CoreIcons.list);
    expect(finderIconList, findsOneWidget);
  });
}
