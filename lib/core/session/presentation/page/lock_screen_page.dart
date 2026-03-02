import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/session/presentation/controller/lock_screen_controller.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_state.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_status.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/core/constants/core_colors.dart';

class LockScreenPage extends StatefulWidget {
  final ItensEntity? listItens;
  const LockScreenPage({this.listItens, super.key});

  @override
  State<LockScreenPage> createState() => _LockScreenPageState();
}

class _LockScreenPageState extends State<LockScreenPage> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final LockScreenController lockScreenController;
  bool _obscurePin = false;
  bool _obscurePassword = false;
  bool _usePin = false;
  bool _hasPin = false;

  @override
  void initState() {
    super.initState();
    lockScreenController = getIt<LockScreenController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasPin = await lockScreenController.getPinVerification();
      if(!mounted) return;
      setState(() {
        _hasPin = hasPin;
        _usePin = hasPin;
      });
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: lockScreenController,
      child: BlocListener<LockScreenController, LockScreenState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          switch (state.status) {
            case LockScreenSuccess():
              Navigator.pop(context);
              break;
            case LockScreenFailure(:final message):
              OverlayToast.showError(content: message);
              break;
            default:
              break;
          }
        },
        child: BlocBuilder<LockScreenController, LockScreenState>(
          builder: (context, state) {
            final isLoading = state.status is LockScreenLoading;
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                OverlayToast.showError(
                    content: CoreStrings.insertCredentialsPrompt);
              },
              child: Scaffold(
                backgroundColor: CoreColors.primaryColor,
                body: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Image.asset(
                              CoreStrings.iconApp,
                            ),
                          ),
                          TextCustom(
                            text: CoreStrings.unlockScreenTitle,
                            color: CoreColors.textSecundary,
                            fontSize: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: 
                            _usePin
                                ? Visibility(
                                  visible: _hasPin,
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 20, right: 10),
                                          child: const Icon(
                                            CoreIcons.pin,
                                            color: CoreColors.textSecundary,
                                          ),
                                        ),
                                        Expanded(
                                          child: FieldsFactory.pin(
                                              controller: pinController,
                                              color: CoreColors.textSecundary,
                                              obscureText: _obscurePin,
                                              onToggleVisibility: () {
                                                setState(() {
                                                  _obscurePin = !_obscurePin;
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                )
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, right: 10),
                                            child: const Icon(CoreIcons.person,
                                                color: CoreColors.textSecundary),
                                          ),
                                          Expanded(
                                            child: FieldsFactory.email(
                                                controller: emailController),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, right: 10),
                                            child: const Icon(CoreIcons.lock,
                                                color: CoreColors.textSecundary),
                                          ),
                                          Expanded(
                                            child: FieldsFactory.password(
                                                controller: passwordController,
                                                obscureText: _obscurePassword,
                                                onToggleVisibility: () {
                                                  setState(() {
                                                    _obscurePassword =
                                                        !_obscurePassword;
                                                  });
                                                }),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                          ),
                          ButtonCustom(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.75,
                            backgroundButton: CoreColors.buttonColorSecond,
                            text: isLoading ? CoreStrings.unlocking : CoreStrings.unlockAction,
                            colorText: CoreColors.textPrimary,
                            fontSize: 18,
                            isLoading: isLoading,
                            onPressed: () {
                              lockScreenController.unlock(
                                  pinOrEmailAndPassword: _usePin,
                                  pin: pinController.text,
                                  password: passwordController.text,
                                  email: emailController.text);
                            },
                          ),
                          SizedBox(height: 15),
                          if(_hasPin) TextButtonCustom(
                            onPressed: () {
                              pinController.clear();
                              emailController.clear();
                              passwordController.clear();
                              setState(() {
                                _usePin = !_usePin;
                              });
                            },
                            text: _usePin
                                ? CoreStrings.enterEmailAndPassword
                                : CoreStrings.enterPin,
                            colorText: CoreColors.textSecundary,
                          ),
                        ],
                      ),
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
