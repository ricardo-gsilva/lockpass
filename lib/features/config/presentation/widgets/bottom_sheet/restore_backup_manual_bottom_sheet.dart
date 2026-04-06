import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';
import 'package:lockpass/core/ui/components/info_dialog.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';
import 'package:path/path.dart' as p;

class RestoreBackupManualBottomSheet extends StatefulWidget {
  const RestoreBackupManualBottomSheet({super.key});

  @override
  State<RestoreBackupManualBottomSheet> createState() => _RestoreBackupManualBottomSheetState();
}

class _RestoreBackupManualBottomSheetState extends State<RestoreBackupManualBottomSheet> {
  String? _selectedPath;
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
              text: CoreStrings.close,
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
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();
    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        switch (state.status) {
          case ConfigRestoreBackupManualSuccess(:final message):
            if (!context.mounted) return;
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            OverlayToast.showSuccess(content: message);
            if (getIt.isRegistered<ListItemController>()) {
              // Recarrega a lista imediatamente após o restore.
              await getIt<ListItemController>().loadItems();
            }
            break;
          case ConfigError(:final message):
            OverlayToast.showError(content: message);
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
                                      showInfo(CoreStrings.infoChooseFileUpload);
                                    },
                                  )
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
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 44,
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                              color: CoreColors.buttonColorPrimary,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: TextCustom(
                                              text: _selectedPath == null ? '' : p.basename(_selectedPath!),
                                              fontSize: 14,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: IconButtonCustom(
                                            key: CoreKeys.iconUploadList,
                                            icon: CoreIcons.upload,
                                            iconSize: 30,
                                            onPressed: () async {
                                              final path = await controller.selectZipFile();
                                              final finalPath = path ?? '';
                                              if (!mounted) return;

                                              if (finalPath.isNotNullOrBlank) {
                                                setState(
                                                  () {
                                                    _selectedPath = finalPath;
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              FieldsFactory.password(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                onToggleVisibility: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                label: CoreStrings.backupPasswordLabel,
                                color: CoreColors.textSecundary,
                              ),
                              const SizedBox(height: 6),
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
                                    backgroundButton: CoreColors.buttonColorSecond,
                                    onPressed: _selectedPath?.isNotEmpty == true
                                        ? () {
                                            final pw = _passwordController.text.trim();
                                            if (pw.isEmpty) {
                                              OverlayToast.showError(content: CoreStrings.exportPasswordRequired);
                                              return;
                                            }
                                            controller.restoreManualBackup(_selectedPath!, pw);
                                          }
                                        : null,
                                  )
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
      ),
    );
  }
}
