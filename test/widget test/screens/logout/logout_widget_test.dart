import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/logout.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

void main(){
  testWidgets('Testing the logout screen properties within Config', (test) async {
    await test.pumpWidget(const MaterialApp(home: LogoutApp()));

    final TextCustom title = test.widget(find.byKey(CoreKeys.titleLogout));
    expect(title.text, CoreStrings.logout);
    expect(title.color, CoreColors.textSecundary);

    final TextCustom info = test.widget(find.byKey(CoreKeys.infoLogout));
    expect(info.text, CoreStrings.wantLogout);
    expect(info.color, CoreColors.textSecundary);

    final IconButtonCustom iconButtonCustom = test.widget(find.byKey(CoreKeys.arrowBackButtonLogout));    
    expect(iconButtonCustom.icon, CoreIcons.arrowBack);

    final ButtonCustom buttonCustom = test.widget(find.byKey(CoreKeys.buttonLogout));
    expect(buttonCustom.backgroundButton, CoreColors.buttonColorSecond);
    expect(buttonCustom.text, CoreStrings.logout);
  });
}