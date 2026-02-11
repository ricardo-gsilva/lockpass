import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';

class SaveListLoginsBottomSheet extends StatefulWidget {
  const SaveListLoginsBottomSheet({super.key});

  @override
  State<SaveListLoginsBottomSheet> createState() =>
      _SaveListLoginsBottomSheetState();
}

class _SaveListLoginsBottomSheetState extends State<SaveListLoginsBottomSheet> {
  CoreStrings strings = CoreStrings();
  TextEditingController selectFolderController = TextEditingController();

  void showInfo(bool isAndroid) {
    showDialog(
        context: context,
        builder: (_) {
          return InfoDialog(
            key: CoreKeys.alertDialogInfoSaveList,
            title: CoreStrings.info,
            content: isAndroid
                ? CoreStrings.infoSaveListAndroid
                : CoreStrings.infoSaveListIos,
            widgets: [
              ButtonCustom(
                backgroundButton: CoreColors.buttonColorSecond,
                colorText: CoreColors.textPrimary,
                text: "Fechar",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
              text: "Fechar",
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
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.saveZip != current.saveZip ||
          previous.selectedFolder != current.selectedFolder,
      listener: (context, state) {
        if (state.selectedFolder) {
          selectFolderController.text = state.folderName;
        }

        if (state.saveZip) {
          showSaveList(state.isAndroid
              ? CoreStrings.infoSaveBackUpAndroid
              : CoreStrings.infoSaveBackUpIos);
          controller.clearMessages();
        }

        if (state.errorMessage.isNotNullOrBlank) {
          SnackUtils.showError(context, content: state.errorMessage);
        }
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: BlocBuilder<ConfigController, ConfigState>(
                      builder: (context, state) {
                        return Column(
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
                                    showInfo(state.isAndroid);
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            const TextCustom(
                              text: CoreStrings.wantSaveListLogin,
                              color: CoreColors.textSecundary,
                              fontSize: 15,
                            ),
                            const SizedBox(height: 24),

                            /// BOTÃO CRIAR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(
                                      color: CoreColors.textTertiary,
                                    ),
                                  ),
                                ),
                                ButtonCustom(
                                  isLoading: state.isLoading,
                                  backgroundButton:
                                      CoreColors.buttonColorSecond,
                                  colorText: CoreColors.textPrimary,
                                  text: state.isLoading
                                      ? 'Salvando... '
                                      : "Salvar",
                                  onPressed: () async {
                                    controller.exportBackup();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
