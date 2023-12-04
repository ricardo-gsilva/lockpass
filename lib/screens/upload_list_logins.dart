// ignore_for_file: void_checks

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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
import 'package:lockpass/components/loading_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

// ignore: must_be_immutable
class UploadListLogins extends StatefulWidget {
  const UploadListLogins({super.key});

  @override
  State<UploadListLogins> createState() => _UploadListLoginsState();
}

class _UploadListLoginsState extends State<UploadListLogins> {
  ConfigPageStore store = ConfigPageStore();
  TextEditingController descryptPass = TextEditingController();

  @override
  void didChangeDependencies() async {
    await store.verifyPlatform();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    descryptPass.dispose();
    super.dispose();
  }

  void showInfo(String content) {
    showDialog(
        context: context,
        builder: (_) {
          return InfoDialog(
            key: CoreKeys.alertInfoLoadList,
            title: CoreStrings.info,
            content: content,
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  void showInsertPin(String msg, File zipFile) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: CoreColors.primaryColor,
            title: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextCustom(
                  key: CoreKeys.titleEnterPin,
                  color: CoreColors.textSecundary,
                  text: CoreStrings.typeItPin,
                ),
                IconButtonCustom(
                    key: CoreKeys.iconInfoEnterPin,
                    icon: CoreIcons.info,
                    onPressed: () {
                      showInfo(
                          CoreStrings.enterYourPinForDecryption);
                    })
              ],
            ),
            content: TextFormFieldCustom(
              key: CoreKeys.formFieldEnterPin,
              keyboardType: TextInputType.number,
              maxLength: 5,
              label: CoreStrings.labelPin,
              colorTextInput: CoreColors.textSecundary,
              colorTextLabel: CoreColors.textSecundary,
              cursorColor: CoreColors.textSecundary,
              colorErrorText: CoreColors.textSecundary,
              colorBorder: CoreColors.textSecundary,
              controller: descryptPass,
              validator: (value) {
                if (store.checkPinLength(value!) == false) {
                  return CoreStrings.pinMustContain;
                } else {
                  return null;
                }
              },
            ),
            actions: [
              IconButtonCustom(
                key: CoreKeys.arrowBackEnterPin,
                onPressed: () {
                  Navigator.of(context).pop();
                  descryptPass.clear();
                },
                icon: CoreIcons.arrowBack,
                color: CoreColors.textSecundary,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 15),
                child: ButtonCustom(
                  key: CoreKeys.buttonDecrypt,
                  text: CoreStrings.decrypt,
                  fontSize: 16,
                  colorText: CoreColors.textPrimary,
                  backgroundButton: CoreColors.buttonColorSecond,
                  onPressed: () async {
                    LoadingCustom().startLoading(context);
                    bool verify = await EncryptDecrypt()
                        .isolateUnzip(descryptPass.text, zipFile);
                    Future.delayed(const Duration(seconds: 1), () {
                      if (verify) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.popAndPushNamed(context, CoreStrings.nHome);
                        showToast(
                            CoreStrings.yourUploadedLoginList,
                            context: context,
                            duration: const Duration(seconds: 4));
                        descryptPass.clear();
                      } else {
                        showToast(
                            CoreStrings.pinDoesNotMatch,
                            context: context,
                            position: StyledToastPosition.top,
                            duration: const Duration(seconds: 4));
                      }
                      LoadingCustom().stopLoading();
                    });
                  },
                ),
              )],
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
              key: CoreKeys.titleLoadList,
              color: CoreColors.textSecundary,
              text: CoreStrings.loadList,
            ),
            IconButtonCustom(
              key: CoreKeys.iconInfoLoadList,
                icon: CoreIcons.info,
                onPressed: () {
                  showInfo(
                      CoreStrings.infoChooseFileUpload);
                })
          ],
        ),
        content: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TextCustom(
              key: CoreKeys.subtitleLoadList,
              text: CoreStrings.chooseFileUpload,
              fontSize: 16,
              color: CoreColors.textSecundary,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: TextFormFieldCustom(
                    key: CoreKeys.formFieldFileUpload,
                    controller: store.uploadPath,
                    readOnly: true,
                    label: '',
                    fillColor: CoreColors.buttonColorPrimary,
                  )),
                  Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: IconButtonCustom(
                          key: CoreKeys.iconUploadList,
                          icon: CoreIcons.upload,
                          iconSize: 30,
                          onPressed: () {
                            store.selectFile();
                          }))
                ],
              ),
            )
          ],
        ),
        actions: [
          TextButtonCustom(
              key: CoreKeys.cancelUploadList,
              colorText: CoreColors.textTertiary,
              text: CoreStrings.cancel,
              fontSize: 16,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ButtonCustom(
                key: CoreKeys.buttonLoadUploadList,
                colorText: CoreColors.textPrimary,
                text: CoreStrings.load,
                fontSize: 16,
                backgroundButton: CoreColors.buttonColorSecond,
                onPressed: () {
                  showInsertPin('', store.zipFile);
                  if (store.uploadPath.text.isEmpty) {
                    showToast(
                        CoreStrings.choiceFile,
                        context: context,
                        duration: const Duration(seconds: 3));
                  } else {
                    if (store.isZipFileEncrypted() == true) {
                      showInsertPin('', store.zipFile);
                    } else {
                      EncryptDecrypt().isolateUnzip(descryptPass.text, store.zipFile);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.popAndPushNamed(context, CoreStrings.nHome);
                      showToast(
                          CoreStrings.loadedList,
                          context: context,
                          duration: const Duration(seconds: 3));
                    }
                  }
                },
              ))
        ]);
  }
}
