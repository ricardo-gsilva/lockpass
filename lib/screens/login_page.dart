// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/login_store.dart';
import 'package:lockpass/screens/create_user.dart';
import 'package:lockpass/screens/reset_password.dart';
import 'package:lockpass/screens/reset_pin.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/components/loading_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginStore store = LoginStore();

  @override
  void didChangeDependencies() async {
    store.sharedPrefs();
    store.getPlatform();
    store.getPermissionStorage();
    super.didChangeDependencies();
  }

  showResetPassword() {
    showDialog(
        context: context,
        builder: (_) {
          return Observer(builder: (context) {
            return const ResetPassword();
          });
        });
  }

  showCreateUser() {
    showDialog(
        context: context,
        builder: (_) {
          return Observer(builder: (context) {
            return const CreateUser();
          });
        });
  }

  showResetPin() {
    showDialog(
        context: context,
        builder: (_) {
          return Observer(builder: (context) {
            return const ResetPin();
          });
        });
  }

  @override
  void dispose() {
    store.emailController.dispose();
    store.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
          backgroundColor: CoreColors.primaryColor,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SingleChildScrollView(
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    SizedBox(
                      key: CoreKeys.appIconLoginPage,
                      height: 200,
                      child: Image.asset(CoreStrings.iconApp),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: store.pinCreated == false
                            ? _credentialLoginAndPassword()
                            : _credentialPin(),
                      ),
                    ),
                    ButtonCustom(
                      key: CoreKeys.buttonEnterLoginPage,
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.5,
                      backgroundButton: CoreColors.buttonColorSecond,
                      text: CoreStrings.enter,
                      colorText: CoreColors.textPrimary,
                      fontSize: 18,
                      onPressed: () async {
                        LoadingCustom().startLoading(context);
                        bool checkPin = await store.pinIsValid();
                        String pin = store.pinController.text;
                        Future.delayed(const Duration(milliseconds: 1500),
                            () async {
                          if (store.pinCreated) {
                            if (pin.isNotEmpty && checkPin) {
                              bool correctPin = await store.checkPin(pin);
                              if (correctPin) {
                                String pin = await store.pinDecrypt();
                                bool completed = await EncryptDecrypt().isolateCreateZip(store.path, pin, CoreStrings.automatic);
                                if (completed) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(CoreStrings.nHome, (route) => false);
                                }
                              } else {
                                showToast(
                                    position: StyledToastPosition.center,
                                    duration: const Duration(seconds: 3),
                                    context: context,
                                    CoreStrings.pinIncorrect);
                              }
                            } else if (pin.isEmpty) {
                              showToast(
                                  duration: const Duration(seconds: 3),
                                  context: context,
                                  CoreStrings.enterYourPin);
                            } else {
                              showToast(
                                  position: StyledToastPosition.center,
                                  duration: const Duration(seconds: 3),
                                  context: context,
                                  CoreStrings.pinNotCreated);
                            }
                          } else {
                            store.confirmLogin = await store.login(
                                store.emailController.text,
                                store.passwordController.text);
                            if (store.confirmLogin) {
                              if (checkPin) {
                                String pin = await store.pinDecrypt();
                                await EncryptDecrypt().isolateCreateZip(store.path, pin, CoreStrings.automatic);                                
                              }
                              Navigator.of(context).pushNamedAndRemoveUntil(CoreStrings.nHome, (route) => false);
                            } else {
                              showToast(
                                  duration: const Duration(seconds: 3),
                                  context: context,
                                  store.exception);
                            }
                          }
                          LoadingCustom().stopLoading();
                        });
                      },                      
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextButtonCustom(
                        key: CoreKeys.enterWithPinOrEmailLoginPage,
                        onPressed: () {
                          store.changeLoginWithPin(true);
                        },
                        text: store.pinCreated == false
                            ? CoreStrings.enterPin
                            : CoreStrings.enterLogin,
                        colorText: CoreColors.textSecundary,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }

  Widget _credentialLoginAndPassword() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CoreIcons.person,
                color: CoreColors.textSecundary,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormFieldCustom(
                    key: CoreKeys.formFieldEmailLoginPage,
                    keyboardType: TextInputType.emailAddress,
                    controller: store.emailController,
                    label: CoreStrings.login,
                    colorTextLabel: CoreColors.textSecundary,
                    cursorColor: CoreColors.textSecundary,
                    colorTextInput: CoreColors.textSecundary,
                    colorBorder: CoreColors.textSecundary,
                    colorErrorText: CoreColors.textSecundary,
                    validator: (value) {
                      return store.validarEmail(value ?? '');
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                CoreIcons.lock,
                color: CoreColors.textSecundary,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormFieldCustom(
                    key: CoreKeys.formFieldPasswordLoginPage,
                    controller: store.passwordController,
                    label: CoreStrings.password,
                    colorTextLabel: CoreColors.textSecundary,
                    cursorColor: CoreColors.textSecundary,
                    colorTextInput: CoreColors.textSecundary,
                    colorBorder: CoreColors.textSecundary,
                    obscureText: store.obscureText,
                    icon: IconButtonCustom(
                        key: CoreKeys.iconVisibilityPasswordLogin,
                        color: CoreColors.textSecundary,
                        icon: store.sufixIcon
                            ? CoreIcons.visibility
                            : CoreIcons.visibilityOff,
                        onPressed: () {
                          store.visibilityPass();
                        }),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButtonCustom(
                      key: CoreKeys.registerHereLoginPage,
                      onPressed: () {
                        showCreateUser();
                      },
                      text: CoreStrings.registerHere,
                      colorText: CoreColors.textSecundary)),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButtonCustom(
                      key: CoreKeys.forgotPasswordLoginPage,
                      onPressed: () {
                        showResetPassword();
                      },
                      text: CoreStrings.forgotPassword,
                      colorText: CoreColors.textSecundary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _credentialPin() {
    return Flex(
      direction: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextFormFieldCustom(
              key: CoreKeys.formFieldPinLoginPage,
              keyboardType: TextInputType.number,
              controller: store.pinController,
              label: CoreStrings.pin,
              maxLength: 5,
              colorTextLabel: CoreColors.textSecundary,
              cursorColor: CoreColors.textSecundary,
              colorTextInput: CoreColors.textSecundary,
              colorBorder: CoreColors.textSecundary,
              colorErrorText: CoreColors.textSecundary,
              validator: (value) {
                if (store.checkPinLength(value!) == false) {
                  return CoreStrings.pinMustContain;
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
                alignment: Alignment.centerRight,
                child: TextButtonCustom(
                  key: CoreKeys.forgotPinLoginPage,
                    onPressed: () {
                      showResetPin();
                    },
                    text: CoreStrings.forgotPin,
                    colorText: CoreColors.textSecundary)),
          ),
        ),
      ],
    );
  }
}
