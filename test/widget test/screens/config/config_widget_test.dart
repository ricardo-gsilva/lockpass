import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/config_page_store.dart';
import 'package:lockpass/screens/config.dart';
import 'package:lockpass/widgets/config_options_custom.dart';

void main(){
  testWidgets('Testing properties of the Create Pin button on the Config screen', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(const MaterialApp(home: Config()));

    final ConfigOptions configOptions = test.widget(find.byKey(CoreKeys.createPinConfig));
    expect(configOptions.text, configStore.textPin);
    expect(configOptions.fontSize, 20);
    expect(configOptions.icons, CoreIcons.password);
    expect(configOptions.iconSize, 30);
    expect(configOptions.iconColor, configStore.colorPin);
    expect(configOptions.textColor, configStore.colorPin);
  });

  testWidgets('Testing visibility of the delete PIN button', (test) async {
    await test.pumpWidget(const MaterialApp(home: Config()));

    final Visibility visibility = test.widget(find.byKey(CoreKeys.visibilityDeletePinConfig));
    expect(visibility.visible, false);
  });

  testWidgets('Testing properties of the Save Login List button on the Config screen', (test) async {
    await test.pumpWidget(const MaterialApp(home: Config()));

    final ConfigOptions configOptions = test.widget(find.byKey(CoreKeys.saveListLoginConfig));
    expect(configOptions.text, CoreStrings.saveListLogins);
    expect(configOptions.fontSize, 20);
    expect(configOptions.icons, CoreIcons.saveAs);
    expect(configOptions.iconSize, 30);
  });

  testWidgets('Testing properties of the Load Login List button on the Config screen', (test) async {
    await test.pumpWidget(const MaterialApp(home: Config()));

    final ConfigOptions configOptions = test.widget(find.byKey(CoreKeys.updateListConfig));
    expect(configOptions.text, CoreStrings.loadListLogins);
    expect(configOptions.fontSize, 20);
    expect(configOptions.icons, CoreIcons.upload);
    expect(configOptions.iconSize, 30);
  });

  testWidgets('Testing properties of the logout button from the config screen', (test) async {
    await test.pumpWidget(const MaterialApp(home: Config()));

    final ConfigOptions configOptions = test.widget(find.byKey(CoreKeys.logoutConfig));
    expect(configOptions.text, CoreStrings.logout);
    expect(configOptions.fontSize, 20);
    expect(configOptions.icons, CoreIcons.logout);
    expect(configOptions.iconSize, 30);
  });
}