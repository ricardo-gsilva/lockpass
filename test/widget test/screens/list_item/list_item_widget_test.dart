import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/screens/list_item.dart';
import 'package:lockpass/widgets/icon_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

void main(){

  List<ItensModel> listItem = [ItensModel(
      id: 1,
      type: 'Email',
      service: 'Gmail',
      site: 'www.gmail.com',
      email: 'teste@gmail.com',
      login: 'teste',
      password: 'teste'
    )];
  List<TypeModel> listType = [TypeModel(typeId: null, type: 'Email', visible: false)];

  testWidgets('Testing the item list screen listtile icon', (test) async {
    await test.pumpWidget(MaterialApp(home: ListItem(mode: 0, itens: listItem, listTypes: listType),));

    final IconCustom icon = test.widget(find.byKey(CoreKeys.iconLeadingListTile));
    expect(icon.icon, CoreIcons.visibility);
    expect(icon.color, CoreColors.textPrimary);
  });

  testWidgets('Testing the item title in the item list', (test) async {
    await test.pumpWidget(MaterialApp(home: ListItem(mode: 0, itens: listItem, listTypes: listType),));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.titleLeadingListTile));
    expect(textCustom.text, listItem[0].service);
    expect(textCustom.color, CoreColors.textPrimary);
  });

  testWidgets('Testing the item subtitle in the item list', (test) async {
    await test.pumpWidget(MaterialApp(home: ListItem(mode: 0, itens: listItem, listTypes: listType),));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.subTitleLeadingListTile));    
    expect(textCustom.text, listItem[0].login);
  });
}