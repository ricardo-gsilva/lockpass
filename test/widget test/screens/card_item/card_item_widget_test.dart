import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/card_item_store.dart';
import 'package:lockpass/screens/card_item.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_item_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

void main() {
  ItensModel i = ItensModel(
      id: 1,
      type: 'Email',
      service: 'Gmail',
      site: 'www.gmail.com',
      email: 'teste@gmail.com',
      login: 'teste',
      password: 'teste'
    );

  testWidgets('Testing item card title', (test) async {    
    await test.pumpWidget(MaterialApp(home: CardItem(itens: i)));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.titleLoginCardItem));
    expect(textCustom.text, i.login);
  });

  testWidgets('Testing the iconbutton to edit the item', (test) async {
    final cardStore = CardItemStore();
    await test.pumpWidget(MaterialApp(home: CardItem(itens: i)));

    final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.iconButtonEditCardItem));
    expect(iconButtonCustom.icon, cardStore.icon);

    cardStore.changeIcon(false);
    expect(cardStore.icon, CoreIcons.save);

    cardStore.changeIcon(true);
    expect(cardStore.icon, CoreIcons.edit);
  });

  testWidgets('Testing the iconbutton to close the item card', (test) async {
    await test.pumpWidget(MaterialApp(home: CardItem(itens: i)));

    final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.arrowBackCardItem));
    expect(iconButtonCustom.icon, CoreIcons.arrowBack);
    expect(iconButtonCustom.color, CoreColors.textSecundary);
  });

  testWidgets('Testing visibility of the edit item button', (test) async {
    final cardStore = CardItemStore();
    await test.pumpWidget(MaterialApp(home: CardItem(itens: i)));

    final Visibility visibility = test.widget(find.byKey(CoreKeys.visibleButtonSaveEdit));
    expect(visibility.visible, cardStore.edit);

    cardStore.changeIcon(false);
    expect(cardStore.edit, true);

    cardStore.changeIcon(true);
    expect(cardStore.edit, false);
  });

  group('Testing the item card and its properties', () { 
    testWidgets('Testing item group and its properties', (test) async {
      await test.pumpWidget(MaterialApp(home: CardItem(itens: i)));

      final InfoItemCustom infoItemCustom = test.widget(find.byKey(CoreKeys.groupCardItem));
      expect(infoItemCustom.title, CoreStrings.group);
      expect(infoItemCustom.subtitle, i.type);
      expect(infoItemCustom.fontSizeSubTitle, 18);
    });

    testWidgets('Testing item service and its properties', (test) async {
      await test.pumpWidget(MaterialApp(home: CardItem(itens: i)));

      final InfoItemCustom infoItemCustom = test.widget(find.byKey(CoreKeys.serviceCardItem));
      expect(infoItemCustom.title, CoreStrings.service);
      expect(infoItemCustom.subtitle, i.service);
      expect(infoItemCustom.fontSizeSubTitle, 18);
    });

    testWidgets('Testing item website and its properties', (test) async {
      await test.pumpWidget(MaterialApp(home: CardItem(itens: i)));

      final InfoItemCustom infoItemCustom = test.widget(find.byKey(CoreKeys.webSiteCardItem));
      expect(infoItemCustom.title, CoreStrings.webSite);
      expect(infoItemCustom.subtitle, i.site);
      expect(infoItemCustom.fontSizeSubTitle, 18);
    });

    testWidgets('Testing item email and its properties', (test) async {
      await test.pumpWidget(MaterialApp(home: CardItem(itens: i)));

      final InfoItemCustom infoItemCustom = test.widget(find.byKey(CoreKeys.emailCardItem));
      expect(infoItemCustom.title, CoreStrings.email);
      expect(infoItemCustom.subtitle, i.email);
      expect(infoItemCustom.fontSizeSubTitle, 18);
    });

    testWidgets('Testing item login and its properties', (test) async {
      await test.pumpWidget(MaterialApp(home: CardItem(itens: i)));

      final InfoItemCustom infoItemCustom = test.widget(find.byKey(CoreKeys.loginCardItem));
      expect(infoItemCustom.title, CoreStrings.login);
      expect(infoItemCustom.subtitle, i.login);
      expect(infoItemCustom.fontSizeSubTitle, 18);
    });    
  });
}