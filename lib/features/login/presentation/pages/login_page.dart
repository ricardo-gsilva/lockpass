import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/ui/components/credential_fields_custom.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/state/auth_state.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';
import 'package:lockpass/features/login/presentation/widgets/create_account_bottom_sheet.dart';
import 'package:lockpass/features/login/presentation/widgets/pin_login_bottom_sheet.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/login/presentation/widgets/reset_password_bottom_sheet.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailResetPasswordController = TextEditingController();
  late final LoginController loginController;

  @override
  void initState() {
    super.initState();
    loginController = getIt<LoginController>();
    loginController.init();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    pinController.dispose();
    emailResetPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: loginController,
      child: BlocListener<LoginController, AuthState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          switch (state.status) {
            case EmailAuthenticated():
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                (route) => false,
              );
              break;
            case AuthError(:final message):
              OverlayToast.showError(content: message);
              break;
            default:
              break;
          }
        },
        child: BlocBuilder<LoginController, AuthState>(
          builder: (context, state) {
            final isLoading = state.status is AuthLoading;
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

                            /// LOGIN FIELDS
                            // child: LoginFields(
                            //     controller: loginController,
                            //     emailController: emailController,
                            //     passwordController: passwordController),
                            child: CredentialsFieldsCustom(
                              emailController: emailController,
                              passwordController: passwordController,
                              obscureText: state.obscureText,
                              onTogglePassword:
                                  loginController.togglePasswordVisibility,
                            ),
                          ),
                        ),

                        /// REGISTER
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButtonCustom(
                              key: CoreKeys.registerHereLoginPage,
                              onPressed: () async {
                                final result = await showCustomBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useRootNavigator: true,
                                  child: BlocProvider.value(
                                      value: loginController,
                                      child: CreateAccountBottomSheet()),
                                );
                                if (result != null) {
                                  emailController.text = result.email;
                                }
                              },
                              text: CoreStrings.registerHere,
                              colorText: CoreColors.textSecundary,
                            ),
                          ),
                        ),

                        /// RESET PASSWORD
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButtonCustom(
                              key: CoreKeys.forgotPasswordLoginPage,
                              onPressed: () {
                                showCustomBottomSheet(
                                  context: context,
                                  child: BlocProvider.value(
                                    value: loginController,
                                    child: ResetPasswordBottomSheet(),
                                  ),
                                );
                              },
                              text: CoreStrings.forgotPassword,
                              colorText: CoreColors.textSecundary,
                            ),
                          ),
                        ),
                        ButtonCustom(
                          key: CoreKeys.buttonEnterLoginPage,
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.75,
                          backgroundButton: CoreColors.buttonColorSecond,
                          text: isLoading ? "Entrando..." : CoreStrings.enter,
                          colorText: CoreColors.textPrimary,
                          fontSize: 18,
                          isLoading: isLoading,
                          onPressed: () async {
                            await loginController.loginWithEmailAndPassword(
                              emailController.text,
                              passwordController.text,
                            );
                          },
                        ),
                        Visibility(
                          visible: state.canAuthWithPin,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextButtonCustom(
                              key: CoreKeys.enterWithPin,
                              onPressed: () {
                                showCustomBottomSheet(
                                  context: context,
                                  child: BlocProvider.value(
                                    value: loginController,
                                    child: PinLoginBottomSheet(),
                                  ),
                                );
                              },
                              text: CoreStrings.enterPin,
                              colorText: CoreColors.textSecundary,
                            ),
                          ),
                        )
                      ],
                    ),
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
