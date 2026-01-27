import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/core/utils/ui/bottom_sheet_utils.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/widgets/create_and_update_pin_bottom_sheet.dart';
import 'package:lockpass/screens/delete_account.dart';
import 'package:lockpass/screens/logout.dart';
import 'package:lockpass/screens/save_list_logins.dart';
import 'package:lockpass/screens/upload_list_logins.dart';
import 'package:lockpass/widgets/config_options_custom.dart';

class ConfigPage1 extends StatefulWidget {
  const ConfigPage1({super.key});

  @override
  State<ConfigPage1> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage1> {
  DataBaseHelper db = DataBaseHelper();
  late final ConfigController configController;

  // void showDeletePin() {
  //   showDialog(
  //       context: context,
  //       builder: (_) {
  //         return DeletePin(removePin: store.removePin);
  //       });
  // }

  void showSaveListLogins() {
    showDialog(
        context: context,
        builder: (_) {
          return const SaveListLogins();
        });
  }

  void showUploadListLogins() {
    showDialog(
        context: context,
        builder: (_) {
          return const UploadListLogins();
        });
  }

  void showLogout() {
    showDialog(
        context: context,
        builder: (_) {
          return const LogoutApp();
        });
  }

  void showDeleteAccount() {
    showDialog(
        context: context,
        builder: (_) {
          return const DeleteAccount();
        });
  }

  @override
  void initState() {
    configController = getIt<ConfigController>();
    configController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: configController,
      child: BlocListener<ConfigController, ConfigState>(
        listenWhen: (previous, current) => false,
        listener: (context, state) {},
        child: BlocBuilder<ConfigController, ConfigState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: CoreColors.secondColor,
              body: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    children: [
                      ConfigOptions(
                        key: CoreKeys.createPinConfig,
                        onTap: () {
                          showCustomBottomSheet(
                            context: context,
                            child: BlocProvider.value(
                              value: configController,
                              child: CreateAndUpdatePinBottomSheet(
                                hasPin: state.hasPin,
                                title: state.hasPin
                                    ? CoreStrings.updatePin
                                    : CoreStrings.registerPin,
                              ),
                            ),
                          ).whenComplete((){
                            configController.resetPinForm();
                          });
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
                      // Visibility(
                      //   key: CoreKeys.visibilityDeletePinConfig,
                      //   visible: store.visibleRemovePin,
                      //   child: ConfigOptions(
                      //     key: CoreKeys.deletePinConfig,
                      //     onTap: () {
                      //       showDeletePin();
                      //     },
                      //     text: CoreStrings.deletePin,
                      //     fontSize: 20,
                      //     icons: CoreIcons.delete,
                      //     iconSize: 30,
                      //   ),
                      // ),
                      ConfigOptions(
                        key: CoreKeys.saveListLoginConfig,
                        onTap: () async {
                          showSaveListLogins();
                        },
                        text: CoreStrings.saveListLogins,
                        fontSize: 20,
                        icons: CoreIcons.saveAs,
                        iconSize: 30,
                      ),
                      ConfigOptions(
                        key: CoreKeys.updateListConfig,
                        onTap: () {
                          showUploadListLogins();
                        },
                        text: CoreStrings.loadListLogins,
                        fontSize: 20,
                        icons: CoreIcons.upload,
                        iconSize: 30,
                      ),
                      ConfigOptions(
                        key: CoreKeys.logoutConfig,
                        onTap: () {
                          showLogout();
                        },
                        text: CoreStrings.logout,
                        fontSize: 20,
                        icons: CoreIcons.logout,
                        iconSize: 30,
                      ),
                      ConfigOptions(
                        key: CoreKeys.deleteAccount,
                        onTap: () {
                          showDeleteAccount();
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
