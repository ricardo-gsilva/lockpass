import 'package:flutter/material.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
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
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class SaveListLogins extends StatefulWidget {
  const SaveListLogins({super.key});

  @override
  State<SaveListLogins> createState() => _SaveListLoginsState();
}

class _SaveListLoginsState extends State<SaveListLogins> {
  CoreStrings strings = CoreStrings();
  ConfigPageStore store = ConfigPageStore();

  @override
  void didChangeDependencies() async {
    await store.verifyPlatform();
    super.didChangeDependencies();
  }

  void showInfo() {
    showDialog(
        context: context,
        builder: (_) {
          return InfoDialog(
            key: CoreKeys.alertDialogInfoSaveList,
            title: CoreStrings.info,
            content:
                CoreStrings.infoSaveList,
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  void showSaveList(String msg) {
    showDialog(
        context: context,
        builder: (_) {
          return TapRegion(
            onTapOutside: (event) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: InfoDialog(
              key: CoreKeys.alertDialogSaveList,
              title: CoreStrings.savedBackup,
              content: msg,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: CoreColors.primaryColor,
        title: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextCustom(
              key: CoreKeys.titleSaveListLogin,
              color: CoreColors.textSecundary,
              text: CoreStrings.saveList,
              fontSize: 18,
            ),
            IconButtonCustom(
                key: CoreKeys.buttonInfoSaveList,
                icon: CoreIcons.info,
                onPressed: () {
                  showInfo();
                })
          ],
        ),
        content: const TextCustom(
          key: CoreKeys.subTitleInfoSaveList,
          color: CoreColors.textSecundary,
          text: CoreStrings.wantSaveListLogin,
          fontSize: 15,
        ),
        actions: [
          TextButtonCustom(
              key: CoreKeys.cancelSaveList,
              colorText: CoreColors.textTertiary,
              text: CoreStrings.cancel,
              fontSize: 16,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: ButtonCustom(
              key: CoreKeys.buttonSaveList,
              colorText: CoreColors.textPrimary,
              backgroundButton: CoreColors.buttonColorSecond,
              text: CoreStrings.save,
              fontSize: 16,
              onPressed: () async {
                if (await store.checkPermission()) {
                  String pin = await store.pinDecrypt();
                  bool completed = await EncryptDecrypt().isolateCreateZip(store.path, pin, CoreStrings.manual);
                  if (completed && store.isAndroid) {
                    showSaveList(CoreStrings.infoSaveBackUpAndroid);
                  } else {
                    showSaveList(CoreStrings.infoSaveBackUpIos);
                  }
                } else {
                  store.requestPermission(Permission.storage);
                }
              },
            ),
          )
        ]);
  }
}
