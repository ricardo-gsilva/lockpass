import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/restore_backup_automatic_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/restore_backup_manual_bottom_sheet.dart';

class RestoreBackupChoiceBottomSheet extends StatefulWidget {
  const RestoreBackupChoiceBottomSheet({super.key});

  @override
  State<RestoreBackupChoiceBottomSheet> createState() => _RestoreBackupChoiceBottomSheetState();
}

class _RestoreBackupChoiceBottomSheetState extends State<RestoreBackupChoiceBottomSheet> {
  TextEditingController restoreDataBase = TextEditingController();

  @override
  void dispose() {
    restoreDataBase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();
    return Padding(
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                            ListTile(
                              leading: Icon(Icons.upload_file, color: CoreColors.iconSecondary),
                              title: TextCustom(
                                text: CoreStrings.manualBackup,
                                color: CoreColors.textSecundary,
                              ),
                              subtitle: TextCustom(
                                text: CoreStrings.manualBackupExplanation,
                                color: CoreColors.textSecundary,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                showCustomBottomSheet(
                                  context: context,
                                  child: BlocProvider.value(
                                    value: controller,
                                    child: RestoreBackupManualBottomSheet(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.autorenew, color: CoreColors.iconPrimary),
                              title: TextCustom(
                                text: CoreStrings.automaticBackup,
                                color: CoreColors.textSecundary,
                              ),
                              subtitle: TextCustom(
                                text: CoreStrings.automaticBackupExplanation,
                                color: CoreColors.textSecundary,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                showCustomBottomSheet(
                                  context: context,
                                  child: BlocProvider.value(
                                    value: controller,
                                    child: RestoreBackupAutomaticBottomSheet(),
                                  ),
                                );
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
    );
  }
}
