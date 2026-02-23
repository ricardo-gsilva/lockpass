import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/state/auth_state.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';

class PinLoginBottomSheet extends StatefulWidget {
  const PinLoginBottomSheet({
    super.key,
  });

  @override
  State<PinLoginBottomSheet> createState() => _PinLoginBottomSheetState();
}

class _PinLoginBottomSheetState extends State<PinLoginBottomSheet> {
  final TextEditingController pinController = TextEditingController();
  bool _obscurePin = true;

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LoginController>();
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final bottomPadding = mediaQuery.viewPadding.bottom;

    return BlocListener<LoginController, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case PinAuthenticated():
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            break;
          case AuthError(:final message):
            OverlayToast.showError(content: message);
            break;
          default:
            break;
        }
      },
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {},
                child: RepaintBoundary(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 20 + bottomPadding + bottomInset,
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: BlocBuilder<LoginController, AuthState>(
                        buildWhen: (previous, current) =>
                            previous.canSubmitPin != current.canSubmitPin,
                        builder: (context, state) {
                          final isLoading = state.status is AuthLoading;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const TextCustom(
                                text: "Entrar com PIN",
                                color: CoreColors.textSecundary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 15),
                              FieldsFactory.pin(
                                controller: pinController,
                                obscureText: _obscurePin,
                                onToggleVisibility: (){
                                  setState(() {
                                    _obscurePin = !_obscurePin;
                                  });
                                },                                  
                                onChanged: controller.onPinChanged,                                
                              ),                              
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "Cancelar",
                                      style: TextStyle(
                                          color: CoreColors.textSecundary),
                                    ),
                                  ),
                                  ButtonCustom(
                                    text: isLoading
                                        ? "Validando..."
                                        : "Logar com PIN",
                                    height: 50,
                                    backgroundButton:
                                        CoreColors.buttonColorSecond,
                                    colorText: CoreColors.textPrimary,
                                    onPressed: isLoading || !state.canSubmitPin
                                        ? null
                                        : () async {
                                            await controller.loginWithPin(
                                                pinController.text);
                                          },
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
