import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/utils/ui/bottom_sheet_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/widgets/backup_automatic_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/backup_manual_bottom_sheet.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';

class BackupChoiceBottomSheet extends StatefulWidget {
  const BackupChoiceBottomSheet({super.key});

  @override
  State<BackupChoiceBottomSheet> createState() =>
      _BackupChoiceBottomSheetState();
}

class _BackupChoiceBottomSheetState extends State<BackupChoiceBottomSheet> {
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();
    return Padding(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                          ListTile(
                            leading:
                                Icon(Icons.upload_file, color: Colors.blue),
                            title: TextCustom(
                              text: "Backup Manual",
                              color: CoreColors.textSecundary,
                            ),
                            subtitle: TextCustom(
                              text:
                                  "Selecione o arquivo de logins que você mesmo salvou (LPB).",
                              color: CoreColors.textSecundary,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              showCustomBottomSheet(
                                context: context,
                                child: BlocProvider.value(
                                  value: controller,
                                  child: BackupManualBottomSheet(),
                                ),
                              ).whenComplete(() {
                                controller.clearMessages();
                              });
                            },
                          ),

                          // Opção Automática
                          ListTile(
                            leading:
                                Icon(Icons.autorenew, color: Colors.orange),
                            title: TextCustom(
                              text: "Backup Automático",
                              color: CoreColors.textSecundary,
                            ),
                            subtitle: TextCustom(
                              text:
                                  "O app seleciona o backup feito no seu último login.",
                              color: CoreColors.textSecundary,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              showCustomBottomSheet(
                                context: context,
                                child: BlocProvider.value(
                                  value: controller,
                                  child: BackupAutomaticBottomSheet(),
                                ),
                              ).whenComplete(() {
                                controller.clearMessages();
                              });
                              // Aqui você pode chamar o Dialog de confirmação que criamos antes
                              // _confirmarBackupAutomatico(context, cubit);
                            },
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
    );
  }
}
