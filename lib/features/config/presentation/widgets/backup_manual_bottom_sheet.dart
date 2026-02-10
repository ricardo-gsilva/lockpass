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
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class BackupManualBottomSheet extends StatefulWidget {
  const BackupManualBottomSheet({super.key});

  @override
  State<BackupManualBottomSheet> createState() =>
      _BackupManualBottomSheetState();
}

class _BackupManualBottomSheetState extends State<BackupManualBottomSheet> {
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
          widgets: [
            TextButtonCustom(
              key: CoreKeys.cancelCreatePin,
              text: "Fechar",
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
                                  text: CoreStrings.loadList,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
                            Flex(
                              direction: Axis.vertical,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        controller: restoreDataBase,
                                        readOnly: true,
                                        label: '',
                                        fillColor:
                                            CoreColors.buttonColorPrimary,
                                      )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: IconButtonCustom(
                                          key: CoreKeys.iconUploadList,
                                          icon: CoreIcons.upload,
                                          iconSize: 30,
                                          onPressed: () {
                                            controller.selectZipFile();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
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
                                    controller.importManualBackup();
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
