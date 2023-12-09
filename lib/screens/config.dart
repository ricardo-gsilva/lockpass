import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/delete_account.dart';
import 'package:lockpass/stores/config_page_store.dart';
import 'package:lockpass/screens/create_pin.dart';
import 'package:lockpass/screens/delete_pin.dart';
import 'package:lockpass/screens/logout.dart';
import 'package:lockpass/screens/save_list_logins.dart';
import 'package:lockpass/screens/upload_list_logins.dart';
import 'package:lockpass/widgets/config_options_custom.dart';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  DataBaseHelper db = DataBaseHelper();
  ConfigPageStore store = ConfigPageStore();

  void showCreatePin() {
    showDialog(
        context: context,
        builder: (_) {
          return CreatePin(
              pinVerify: store.getPinVerification, title: store.textPin);
        });
  }

  void showDeletePin() {
    showDialog(
        context: context,
        builder: (_) {
          return DeletePin(removePin: store.removePin);
        });
  }

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
  void didChangeDependencies() async {
    await store.verifyPlatform();
    store.getPinVerification();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColors.secondColor,
      body: SingleChildScrollView(
        child: SizedBox(
            child: Column(children: [
          Observer(builder: (context) {
            return ConfigOptions(
              key: CoreKeys.createPinConfig,
              onTap: () {
                showCreatePin();
              },
              text: store.textPin,
              fontSize: 20,
              icons: CoreIcons.password,
              iconSize: 30,
              iconColor: store.colorPin,
              textColor: store.colorPin,
            );
          }),
          Observer(builder: (context) {
            return Visibility(
              key: CoreKeys.visibilityDeletePinConfig,
              visible: store.visibleRemovePin,
              child: ConfigOptions(
                key: CoreKeys.deletePinConfig,
                onTap: () {
                  showDeletePin();
                },
                text: CoreStrings.deletePin,
                fontSize: 20,
                icons: CoreIcons.delete,
                iconSize: 30,
              ),
            );
          }),
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
        ])),
      ),
    );
  }
}
