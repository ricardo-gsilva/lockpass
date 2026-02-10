import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class RemovePinBottomSheet extends StatefulWidget {
  const RemovePinBottomSheet({
    super.key,
  });

  @override
  State<RemovePinBottomSheet> createState() => _RemovePinBottomSheetState();
}

class _RemovePinBottomSheetState extends State<RemovePinBottomSheet> {
  final TextEditingController currentPinController = TextEditingController();

  @override
  void dispose() {
    currentPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();
    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.successMessage.isNotNullOrBlank) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          SnackUtils.showSuccess(context, content: state.successMessage);
        }
        if (state.errorMessage.isNotNullOrBlank) {
          SnackUtils.showError(context, content: state.errorMessage);
        }
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: BlocBuilder<ConfigController, ConfigState>(
                        builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const TextCustom(
                            text: "Remover PIN",
                            color: CoreColors.textSecundary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const TextCustom(
                            text:
                                "Digite o PIN atual para confirmar sua identidade.\n\nAo remover o PIN, o acesso ao aplicativo passará a ser realizado utilizando o e-mail e a senha cadastrados.\n\nCaso deseje, será possível criar um novo PIN posteriormente.",
                            color: CoreColors.textSecundary,
                            fontSize: 15,
                          ),
                          const SizedBox(height: 24),
                          TextFormFieldCustom(
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            label: 'Digite seu PIN atual',
                            colorTextInput: CoreColors.textSecundary,
                            colorTextLabel: CoreColors.textSecundary,
                            cursorColor: CoreColors.textSecundary,
                            colorErrorText: CoreColors.textSecundary,
                            colorBorder: CoreColors.textSecundary,
                            controller: currentPinController,
                            validator: (value) {
                              if (value == null || value.trim().length < 5) {
                                return CoreStrings.pinMustContain;
                              }
                              return null;
                            },
                          ),

                          /// BOTÃO CRIAR
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Cancelar",
                                  style:
                                      TextStyle(color: CoreColors.textTertiary),
                                ),
                              ),
                              ButtonCustom(
                                isLoading: state.isLoading,
                                backgroundButton: CoreColors.buttonColorSecond,
                                colorText: CoreColors.textPrimary,
                                text: state.isLoading
                                    ? 'Removendo... '
                                    : "Remover PIN",
                                onPressed: () async {
                                  // Navigator.of(context).pop();
                                  // showCustomBottomSheet(
                                  //   context: context,
                                  //   child: BlocProvider.value(
                                  //     value: controller,
                                  //     child: ResetPinBottomSheet(),
                                  //   ),
                                  // );
                                  await controller.confirmAndRemovePin(currentPinController.text);
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
