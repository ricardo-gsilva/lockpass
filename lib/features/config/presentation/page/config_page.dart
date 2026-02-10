import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/utils/ui/bottom_sheet_utils.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/widgets/change_password_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/create_and_update_pin_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/delete_account_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/logout_app_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/remove_pin_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/save_list_logins_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/backup_choice_bottom_sheet.dart';
import 'package:lockpass/widgets/config_options_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';

class ConfigPage1 extends StatefulWidget {
  const ConfigPage1({super.key});

  @override
  State<ConfigPage1> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage1> {
  DataBaseHelper db = DataBaseHelper();
  late final ConfigController configController;

  void showBottomSheet(
    Widget bottomSheet, {
    VoidCallback? onComplete,
  }) {
    showCustomBottomSheet(
      context: context,
      child: BlocProvider.value(
        value: configController,
        child: bottomSheet,
      ),
    ).whenComplete(() {
      onComplete?.call();
    });
  }

  

  @override
  void initState() {
    super.initState();
    configController = getIt<ConfigController>();
    configController.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: configController,
      child: BlocListener<ConfigController, ConfigState>(
        listenWhen: (previous, current) =>
        previous.errorMessage != current.errorMessage ||
        previous.successMessage != current.successMessage ||
        previous.updatedPassword != current.updatedPassword,
        listener: (context, state){
          if (state.updatedPassword && state.successMessage.isNotNullOrBlank) {
            if (mounted) {
              
            }
          }
          if (state.successMessage.isNotNullOrBlank) {
            SnackUtils.showSuccess(context, content: state.successMessage);
            configController.clearMessages();
          }
        },
        child: BlocBuilder<ConfigController, ConfigState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: CoreColors.secondColor,
              body: state.isCheckingPin
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: SizedBox(
                        child: Column(
                          children: [
                            ConfigOptions(
                              key: CoreKeys.createPinConfig,
                              onTap: () {
                                showBottomSheet(
                                  CreateAndUpdatePinBottomSheet(
                                    hasPin: state.hasPin,
                                    title: state.hasPin
                                        ? CoreStrings.updatePin
                                        : CoreStrings.registerPin,
                                  ),
                                  onComplete: () {
                                    configController.resetPinForm();
                                  },
                                );
                              },
                              text: state.hasPin
                                  ? CoreStrings.updatePin
                                  : CoreStrings.registerPin,
                              fontSize: 20,
                              icons: CoreIcons.password,
                              iconSize: 30,
                              iconColor: state.hasPin
                                  ? CoreColors.textPrimary
                                  : CoreColors.pinIsEmpty,
                              textColor: state.hasPin
                                  ? CoreColors.textPrimary
                                  : CoreColors.pinIsEmpty,
                            ),
                            Visibility(
                              key: CoreKeys.visibilityDeletePinConfig,
                              visible: state.hasPin,
                              child: ConfigOptions(
                                key: CoreKeys.deletePinConfig,
                                onTap: () {
                                  showBottomSheet(RemovePinBottomSheet());
                                },
                                text: CoreStrings.deletePin,
                                fontSize: 20,
                                icons: CoreIcons.delete,
                                iconSize: 30,
                              ),
                            ),
                            ConfigOptions(
                              key: CoreKeys.saveListLoginConfig,
                              onTap: () async {
                                showBottomSheet(
                                  SaveListLoginsBottomSheet(),
                                  onComplete: () {
                                    configController.resetSelectedFolder();
                                  },
                                );
                              },
                              text: CoreStrings.saveListLogins,
                              fontSize: 20,
                              icons: CoreIcons.saveAs,
                              iconSize: 30,
                            ),
                            ConfigOptions(
                              key: CoreKeys.updateListConfig,
                              onTap: () {
                                showBottomSheet(BackupChoiceBottomSheet());
                              },
                              text: CoreStrings.loadListLogins,
                              fontSize: 20,
                              icons: CoreIcons.upload,
                              iconSize: 30,
                            ),
                            ConfigOptions(
                              // key: CoreKeys.deleteAccount,
                              onTap: () {
                                showBottomSheet(const ChangePasswordBottomSheet());
                              },
                              text: "Alterar Senha",
                              fontSize: 20,
                              icons: Icons.password,
                              iconSize: 30,
                            ),
                            ConfigOptions(
                              key: CoreKeys.logoutConfig,
                              onTap: () {
                                showBottomSheet(const LogoutAppBottomSheet());
                              },
                              text: CoreStrings.logout,
                              fontSize: 20,
                              icons: CoreIcons.logout,
                              iconSize: 30,
                            ),
                            ConfigOptions(
                              key: CoreKeys.deleteAccount,
                              onTap: () {
                                showBottomSheet(const DeleteAccountBottomSheet());
                              },
                              text: CoreStrings.deleteAccount,
                              fontSize: 20,
                              icons: CoreIcons.deleteAccount,
                              iconSize: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
