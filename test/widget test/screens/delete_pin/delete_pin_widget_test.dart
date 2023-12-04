import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/config_page_store.dart';
import 'package:lockpass/screens/delete_pin.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';

void main() {
  testWidgets('Testing screen title properties to delete the pin', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: DeletePin(removePin: configStore.removePin)));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.titleDeletePin));
    expect(textCustom.text, CoreStrings.deletePin);
    expect(textCustom.fontSize, 18);
    expect(textCustom.color, CoreColors.textSecundary);
  });

  testWidgets('Testing properties of the screen information text to delete the pin', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: DeletePin(removePin: configStore.removePin)));

    final TextCustom textCustom = test.widget(find.byKey(CoreKeys.subTitleDeletePin));
    expect(textCustom.text, CoreStrings.wantDeleteRegisteredPin);
    expect(textCustom.fontSize, 15);
    expect(textCustom.color, CoreColors.textSecundary);
  });

  testWidgets('Checking button properties to close the pin delete screen', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: DeletePin(removePin: configStore.removePin)));

    final TextButtonCustom textButtonCustom = test.widget(find.byKey(CoreKeys.cancelDeletePin));
    expect(textButtonCustom.text, CoreStrings.cancel);
    expect(textButtonCustom.fontSize, 16);
    expect(textButtonCustom.colorText, CoreColors.textTertiary);
  });

  testWidgets('Testing properties of the delete pin button', (test) async {
    final configStore = ConfigPageStore();
    await test.pumpWidget(MaterialApp(home: DeletePin(removePin: configStore.removePin)));

    final ButtonCustom buttonCustom = test.widget(find.byKey(CoreKeys.buttonDeletePin));
    expect(buttonCustom.text, CoreStrings.delete);
    expect(buttonCustom.fontSize, 16);
    expect(buttonCustom.colorText, CoreColors.textPrimary);
    expect(buttonCustom.backgroundButton, CoreColors.buttonColorSecond);
  });
}