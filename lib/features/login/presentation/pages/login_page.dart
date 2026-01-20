import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/utils/bottom_sheet_utils.dart';
import 'package:lockpass/core/utils/snack_bar_utils.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/state/login_state.dart';
import 'package:lockpass/features/login/presentation/widgets/create_account_bottom_sheet.dart';
import 'package:lockpass/features/login/presentation/widgets/login_fields.dart';
import 'package:lockpass/features/login/presentation/widgets/pin_login_bottom_sheet.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/features/login/presentation/widgets/reset_password_bottom_sheet.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({super.key});

  @override
  State<LoginPage1> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage1> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();
  late final loginController = getIt<LoginController>();

  @override
  void initState() {
    super.initState();
    loginController.init();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    pinController.dispose();
    resetPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: loginController,
      child: BlocListener<LoginController, LoginState>(
        listenWhen: (prev, curr) => prev.exception != curr.exception 
          || prev.confirmLogin != curr.confirmLogin,
        listener: (context, state) {
          if (state.exception.isNotEmpty) {
            SnackUtils.showError(context, content: state.exception);
            loginController.clearFeedback();
            return;
          }

          if (state.confirmLogin == true) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
            loginController.clearFeedback();
          }
        },
        child: Scaffold(
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
                        /// LOGIN FIELDS  
                        child: LoginFields(
                            controller: loginController,
                            emailController: emailController,
                            passwordController: passwordController),
                      ),
                    ),

                    /// REGISTER
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButtonCustom(
                        key: CoreKeys.registerHereLoginPage,
                        onPressed: () async {
                          final result = await showCustomBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            child: BlocProvider.value(
                              value: loginController,
                              child: CreateAccountBottomSheet(
                                controller: loginController,
                              ),
                            ),
                          );
                          if (result != null) {
                            emailController.text = result.email;
                            passwordController.text = result.password;
                          }
                        },
                        text: CoreStrings.registerHere,
                        colorText: CoreColors.textSecundary,
                      ),
                    ),

                    /// RESET PASSWORD
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButtonCustom(
                        key: CoreKeys.forgotPasswordLoginPage,
                        onPressed: () {
                          showCustomBottomSheet(
                            context: context,
                            child: BlocProvider.value(
                              value: loginController,
                              child: ResetPasswordBottomSheet(
                                controller: loginController,
                                resetPasswordController: resetPasswordController,
                              ),
                            ),
                          );
                        },
                        text: CoreStrings.forgotPassword,
                        colorText: CoreColors.textSecundary,
                      ),
                    ),
                    BlocBuilder<LoginController, LoginState>(
                      bloc: loginController,
                      builder: (context, state) {
                        return ButtonCustom(
                          key: CoreKeys.buttonEnterLoginPage,
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.75,
                          backgroundButton: CoreColors.buttonColorSecond,
                          text: state.isLoading? "Entrando..." : CoreStrings.enter,
                          colorText: CoreColors.textPrimary,
                          fontSize: 18,
                          isLoading: state.isLoading,
                          onPressed: () async {
                            await loginController.loginWithEmailAndPassword(
                              emailController.text,
                              passwordController.text,
                            );
                          },
                        );
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextButtonCustom(
                        key: CoreKeys.enterWithPin,
                        onPressed: () {
                          showCustomBottomSheet(
                            context: context,
                            child: PinLoginBottomSheet(
                              controller: loginController,
                              pinController: pinController,
                            ),
                          );
                        },
                        text: CoreStrings.enterPin,
                        colorText: CoreColors.textSecundary,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
