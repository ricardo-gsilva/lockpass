import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';

class BackupAutomaticBottomSheet extends StatefulWidget {
  const BackupAutomaticBottomSheet({super.key});

  @override
  State<BackupAutomaticBottomSheet> createState() =>
      _BackupAutomaticBottomSheetState();
}

class _BackupAutomaticBottomSheetState
    extends State<BackupAutomaticBottomSheet> {
  TextEditingController restoreDataBase = TextEditingController();

  @override
  void dispose() {
    restoreDataBase.dispose();
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
          widgets: [
            TextButtonCustom(
              key: CoreKeys.cancelCreatePin,
              text: CoreStrings.cancel,
              colorText: CoreColors.textPrimary,
              fontSize: 16,
              onPressed: () {
                Navigator.of(context).pop();
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
          previous.successMessage != current.successMessage ||
          previous.hasSelectedZip != current.hasSelectedZip,
      listener: (context, state) {
        if (state.hasSelectedZip) {
          restoreDataBase.text = state.selectedZipName ?? '';
        }
        if (state.successMessage.isNotNullOrBlank) {
          Navigator.of(context).pop();
          SnackUtils.showSuccess(context, content: state.successMessage);
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
                            Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TextCustom(
                                  key: CoreKeys.titleLoadList,
                                  color: CoreColors.textSecundary,
                                  text: "Backup Automático",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                IconButtonCustom(
                                    key: CoreKeys.iconInfoLoadList,
                                    icon: CoreIcons.info,
                                    onPressed: () {
                                      showInfo(
                                          "O backup automático é salvo toda vez que você loga no app para garantir a segurança dos seus dados. Ao carregar um backup automático, você estará restaurando seus dados para o estado mais recente salvo automaticamente pelo sistema. Certifique-se de que deseja prosseguir com esta ação, pois ela substituirá dados salvos após o último login.");
                                    })
                              ],
                            ),
                            SizedBox(height: 15),
                            const TextCustom(
                              key: CoreKeys.subtitleLoadList,
                              text: "Deseja carregar o backup automático?",
                              fontSize: 16,
                              color: CoreColors.textSecundary,
                            ),
                            SizedBox(height: 24),
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
                                    }),
                                ButtonCustom(
                                  key: CoreKeys.buttonLoadUploadList,
                                  colorText: CoreColors.textPrimary,
                                  text: CoreStrings.load,
                                  fontSize: 16,
                                  backgroundButton:
                                      CoreColors.buttonColorSecond,
                                  onPressed: () {
                                    controller.importAutomaticBackup();
                                  },
                                )
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
