import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/config_page_store.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

// ignore: must_be_immutable
class CreatePin extends StatelessWidget {
  VoidCallback? pinVerify;
  String? title;
  bool? newPin;
  CreatePin({this.title, this.newPin = false, this.pinVerify, super.key});

  ConfigPageStore store = ConfigPageStore();

  @override
  Widget build(BuildContext context) {
    void showInfo(String msg, String titleInfo, bool pinCreate) {
      showDialog(
          context: context,
          builder: (_) {
            return InfoDialog(
              key: CoreKeys.alertDialogInfoCreatePin,
              title: titleInfo,
              content: msg,
              onPressed: () {
                if (pinCreate && newPin!) {
                  Navigator.of(context).pop();
                  Navigator.of(context).popAndPushNamed(CoreStrings.nLogin);
                } else if (pinCreate) {
                  pinVerify!();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                }
              },
            );
          });
    }

    return AlertDialog(
        backgroundColor: CoreColors.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextCustom(
              key: CoreKeys.titleCreatePin,
              text: title,
              fontSize: 18,
              color: CoreColors.textSecundary,
            ),
            IconButtonCustom(
              key: CoreKeys.buttonInfoCreatePin,
              icon: CoreIcons.info,
              iconSize: 22,
              color: CoreColors.textSecundary,
              onPressed: () =>
                  showInfo(CoreStrings.pinInfo, CoreStrings.info, false),
            ),
          ],
        ),
        content: Flex(
            mainAxisSize: MainAxisSize.min,
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 5, top: 5),
                child: TextCustom(
                  key: CoreKeys.subTitleCreatePin,
                  text: CoreStrings.typeItPin,
                  color: CoreColors.textSecundary,
                ),
              ),
              TextFormFieldCustom(
                key: CoreKeys.formFieldCreatePin,
                keyboardType: TextInputType.number,
                maxLength: 5,
                label: CoreStrings.labelPin,
                colorTextInput: CoreColors.textSecundary,
                colorTextLabel: CoreColors.textSecundary,
                cursorColor: CoreColors.textSecundary,
                colorErrorText: CoreColors.textSecundary,
                colorBorder: CoreColors.textSecundary,
                controller: store.pinController,
                validator: (value) {
                  if (store.checkPinLength(value!) == false) {
                    return CoreStrings.pinMustContain;
                  } else {
                    return null;
                  }
                },
              ),
            ]),
        actions: [
          TextButtonCustom(
              key: CoreKeys.cancelCreatePin,
              text: CoreStrings.cancel,
              colorText: CoreColors.textTertiary,
              fontSize: 16,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 15),
            child: ButtonCustom(
              key: CoreKeys.buttonCreatePin,
              colorText: CoreColors.textPrimary,
              text: CoreStrings.save,
              fontSize: 16,
              backgroundButton: CoreColors.buttonColorSecond,
              onPressed: () {
                if (store.checkPinLength(store.pinController.text)) {
                  if (store.pinValidate) {
                    store.savePin(store.pinController.text);
                    showInfo(
                        CoreStrings.pinUseInfo, CoreStrings.pinCreated, true);
                  } else {
                    showInfo(
                        CoreStrings.pinInfo, CoreStrings.invalidePin, false);
                  }
                } else {
                  showInfo(
                      CoreStrings.pinVazio, CoreStrings.invalidePin, false);
                }
              },
            ),
          ),
        ]);
  }
}
