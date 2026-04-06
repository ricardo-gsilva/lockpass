import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';
import 'package:lockpass/core/ui/components/info_dialog.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';

class SaveListLoginsBottomSheet extends StatefulWidget {
  const SaveListLoginsBottomSheet({super.key});

  @override
  State<SaveListLoginsBottomSheet> createState() => _SaveListLoginsBottomSheetState();
}

class _SaveListLoginsBottomSheetState extends State<SaveListLoginsBottomSheet> {
  CoreStrings strings = CoreStrings();
  TextEditingController selectFolderController = TextEditingController();
  final isAndroid = Platform.isAndroid;

  Future<String?> _askExportPassword() async {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    var obscure1 = true;
    var obscure2 = true;

    final result = await showDialog<String?>(
      context: context,
      barrierDismissible: true,
      barrierColor: CoreColors.black54,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: CoreColors.primaryColor,
              surfaceTintColor: CoreColors.primaryColor,
              title: const TextCustom(
                text: CoreStrings.backupPasswordTitle,
                color: CoreColors.textSecundary,
                fontWeight: FontWeight.bold,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FieldsFactory.password(
                    controller: passwordController,
                    obscureText: obscure1,
                    onToggleVisibility: () => setState(() => obscure1 = !obscure1),
                    label: CoreStrings.backupPasswordLabel,
                    color: CoreColors.textSecundary,
                  ),
                  const SizedBox(height: 12),
                  FieldsFactory.password(
                    controller: confirmController,
                    obscureText: obscure2,
                    onToggleVisibility: () => setState(() => obscure2 = !obscure2),
                    label: CoreStrings.backupPasswordConfirmLabel,
                    color: CoreColors.textSecundary,
                  ),
                ],
              ),
              actions: [
                TextButtonCustom(
                  onPressed: () => Navigator.of(dialogContext).pop(null),
                  text: CoreStrings.cancel,
                  colorText: CoreColors.textSecundary,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoreColors.buttonColorSecond,
                    foregroundColor: CoreColors.textPrimary,
                  ),
                  onPressed: () {
                    final pw = passwordController.text.trim();
                    final confirm = confirmController.text.trim();
                    if (pw.isEmpty) {
                      OverlayToast.showError(content: CoreStrings.exportPasswordRequired);
                      return;
                    }
                    if (pw.length < 6) {
                      OverlayToast.showError(content: CoreStrings.backupPasswordTooShort);
                      return;
                    }
                    if (pw != confirm) {
                      OverlayToast.showError(content: CoreStrings.backupPasswordMismatch);
                      return;
                    }
                    Navigator.of(dialogContext).pop(pw);
                  },
                  child: const TextCustom(
                    text: CoreStrings.confirm,
                    color: CoreColors.textPrimary,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    return result;
  }

  void showInfo(bool isAndroid) {
    showDialog(
      context: context,
      builder: (_) {
        return InfoDialog(
          key: CoreKeys.alertDialogInfoSaveList,
          title: CoreStrings.info,
          content: isAndroid ? CoreStrings.infoSaveListAndroid : CoreStrings.infoSaveListIos,
          widgets: [
            ButtonCustom(
              backgroundButton: CoreColors.buttonColorSecond,
              colorText: CoreColors.textPrimary,
              text: CoreStrings.close,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSaveList(String msg) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return InfoDialog(
          key: CoreKeys.alertDialogSaveList,
          title: CoreStrings.savedBackup,
          content: msg,
          widgets: [
            ButtonCustom(
              backgroundButton: CoreColors.buttonColorSecond,
              colorText: CoreColors.textPrimary,
              text: CoreStrings.close,
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();
    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ConfigError(:final message):
            if (!mounted) return;
            OverlayToast.showError(content: message);
            break;
          case ConfigBackupSaved():
            if (!mounted) return;
            showSaveList(
              isAndroid ? CoreStrings.infoSaveBackUpAndroid : CoreStrings.infoSaveBackUpIos,
            );
            break;
          case ConfigBackupShared():
            if (!mounted) return;
            OverlayToast.showSuccess(content: CoreStrings.backupSharedSuccess);
            break;
          default:
            return;
        }
        controller.clearStatus();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: context.bottomSystemSpace),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {},
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: BlocBuilder<ConfigController, ConfigState>(
                      builder: (context, state) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const TextCustom(
                                    text: CoreStrings.saveList,
                                    color: CoreColors.textSecundary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  IconButtonCustom(
                                    key: CoreKeys.buttonInfoSaveList,
                                    icon: CoreIcons.info,
                                    onPressed: () {
                                      showInfo(isAndroid);
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              const TextCustom(
                                text: CoreStrings.wantSaveListLogin,
                                color: CoreColors.textSecundary,
                                fontSize: 15,
                              ),
                              SizedBox(height: 30),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ListTile(
                                    leading:
                                        Icon(isAndroid ? Icons.phone_android : Icons.phone_iphone, color: CoreColors.iconSecondary),
                                    title: TextCustom(
                                      text: CoreStrings.saveToDeviceAction,
                                      color: CoreColors.textSecundary,
                                    ),
                                    subtitle: TextCustom(
                                      text: CoreStrings.saveToDeviceExplanation,
                                      color: CoreColors.textSecundary,
                                    ),
                                    onTap: () async {
                                      final pw = await _askExportPassword();
                                      if (pw == null) return;
                                      await controller.createManualBackup(pw);
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  ListTile(
                                    leading: Icon(Icons.share, color: CoreColors.iconPrimary),
                                    title: TextCustom(
                                      text: CoreStrings.shareListAction,
                                      color: CoreColors.textSecundary,
                                    ),
                                    subtitle: TextCustom(
                                      text: CoreStrings.shareListExplanation,
                                      color: CoreColors.textSecundary,
                                    ),
                                    onTap: () async {
                                      final pw = await _askExportPassword();
                                      if (pw == null) return;
                                      await controller.shareExportBackup(pw);
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButtonCustom(
                                        key: CoreKeys.cancelUploadList,
                                        colorText: CoreColors.textTertiary,
                                        text: CoreStrings.cancel,
                                        fontSize: 16,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
