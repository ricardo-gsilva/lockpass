import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/components/textformfield_custom.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/reset_pin_bottom_sheet.dart';

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
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ConfigPinRemoveSuccess(:final message):
            if (!mounted) return;
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            OverlayToast.showSuccess(content: message);
            break;
          case ConfigError(:final message):
            if (!mounted) return;
            OverlayToast.showError(content: message);
          default:
            return;
        }
        controller.clearStatus();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: context.bottomSystemSpace),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {},
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: BlocBuilder<ConfigController, ConfigState>(builder: (context, state) {
                      final isLoading = state.status is ConfigLoading;
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const TextCustom(
                              text: CoreStrings.removePinAction,
                              color: CoreColors.textSecundary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 20),
                            const TextCustom(
                              text: CoreStrings.removePinExplanation,
                              color: CoreColors.textSecundary,
                              fontSize: 15,
                            ),
                            const SizedBox(height: 24),
                            TextFormFieldCustom(
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              label: CoreStrings.enterCurrentPin,
                              colorTextInput: CoreColors.textSecundary,
                              colorTextLabel: CoreColors.textSecundary,
                              cursorColor: CoreColors.textSecundary,
                              colorErrorText: CoreColors.textSecundary,
                              colorBorder: CoreColors.textSecundary,
                              controller: currentPinController,
                              validator: (value) => value.pinError,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButtonCustom(
                                  text: CoreStrings.forgotPinAction,
                                  colorText: CoreColors.textSecundary,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showCustomBottomSheet(
                                      context: context,
                                      child: BlocProvider.value(
                                        value: controller,
                                        child: ResetPinBottomSheet(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const TextCustom(
                                    text: CoreStrings.cancel,
                                    color: CoreColors.textTertiary,
                                  ),
                                ),
                                ButtonCustom(
                                  isLoading: isLoading,
                                  backgroundButton: CoreColors.buttonColorSecond,
                                  colorText: CoreColors.textPrimary,
                                  text: isLoading ? CoreStrings.removing : CoreStrings.removePinAction,
                                  onPressed: () async {
                                    await controller.confirmAndRemovePin(currentPinController.text);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
