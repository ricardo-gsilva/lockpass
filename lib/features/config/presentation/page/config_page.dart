import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/change_password_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/create_and_update_pin_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/delete_account_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/lock_timeout_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/logout_app_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/remove_pin_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/save_list_logins_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/restore_backup_choice_bottom_sheet.dart';
import 'package:lockpass/features/config/presentation/widgets/config_options_custom.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
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
  }

  @override
  void dispose() {
    configController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: configController,
      child: BlocListener<ConfigController, ConfigState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state){
          
        },
        child: BlocBuilder<ConfigController, ConfigState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: CoreColors.secondColor,
              body: state.status is ConfigLoading
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
                              icons: CoreIcons.pin,
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
                                icons: Icons.delete_outline,
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
                                showBottomSheet(RestoreBackupChoiceBottomSheet());
                              },
                              text: CoreStrings.restoreListLogins,
                              fontSize: 20,
                              icons: CoreIcons.upload,
                              iconSize: 30,
                            ),
                            ConfigOptions(
                              onTap: () {
                                showBottomSheet(const ChangePasswordBottomSheet());
                              },
                              text: CoreStrings.changePasswordAction,
                              fontSize: 20,
                              icons: Icons.password,
                              iconSize: 30,
                            ),
                            ConfigOptions(
                              onTap: () async {
                                showBottomSheet(
                                  LockTimeoutBottomSheet(),
                                  onComplete: () {
                                    configController.resetSelectedFolder();
                                  },
                                );
                              },
                              text: CoreStrings.screenLockTimer,
                              fontSize: 20,
                              icons: CoreIcons.timerBlock,
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
