import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/utils/ui/bottom_sheet_utils.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/widgets/reset_pin_bottom_sheet.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_dialog.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textbutton_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

final _formKey = GlobalKey<FormState>();

class CreateAndUpdatePinBottomSheet extends StatefulWidget {
  final String title;
  final bool hasPin;

  const CreateAndUpdatePinBottomSheet({
    super.key,
    required this.title,
    this.hasPin = false,
  });

  @override
  State<CreateAndUpdatePinBottomSheet> createState() => _CreatePinBottomSheetState();
}

class _CreatePinBottomSheetState extends State<CreateAndUpdatePinBottomSheet> {
  late final TextEditingController newAndUpdatePinController;
  late final TextEditingController currentPinController;

  @override
  void initState() {
    super.initState();
    newAndUpdatePinController = TextEditingController(text: '');
    currentPinController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    newAndUpdatePinController.dispose();
    currentPinController.dispose();
    super.dispose();
  }

  void _showInfo(String msg, String titleInfo) {
    showDialog(
      context: context,
      builder: (_) => InfoDialog(
        key: CoreKeys.alertDialogInfoCreatePin,
        title: titleInfo,
        content: msg,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _showSuccessAndClose() async {
    showDialog(
      context: context,
      builder: (_) => InfoDialog(
        key: CoreKeys.alertDialogInfoCreatePin,
        title: CoreStrings.pinCreated,
        content: CoreStrings.pinUseInfo,
        onPressed: () async {
          // Atualiza visual da config (hasPin)
          await context.read<ConfigController>().getPinVerification();

          Navigator.of(context).pop(); // fecha InfoDialog
          Navigator.of(context).pop(); // fecha BottomSheet
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final controller = context.read<ConfigController>();
    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) => previous.errorMessage != current.errorMessage 
      || previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.successMessage.isNotNullOrBlank) {
          if(Navigator.of(context).canPop()) Navigator.of(context).pop();
          SnackUtils.showSuccess(context, content: state.successMessage);
        }
        if (state.errorMessage.isNotNullOrBlank) {
          SnackUtils.showError(context, content: state.errorMessage);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: GestureDetector(
          onTap: () {
            controller.resetPinForm();
            Navigator.pop(context);
          },
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
                      return Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: () {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          controller.onFormChanged(
                            isFormValid: isValid,
                            isUpdate: widget.hasPin,
                            currentPin: currentPinController.text,
                            newPin: newAndUpdatePinController.text,
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // “handle” do bottomsheet
                            Center(
                              child: Container(
                                width: 45,
                                height: 5,
                                decoration: BoxDecoration(
                                  color:
                                      CoreColors.textTertiary.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextCustom(
                                  key: CoreKeys.titleCreatePin,
                                  text: widget.title,
                                  fontSize: 18,
                                  color: CoreColors.textSecundary,
                                ),
                                IconButtonCustom(
                                  key: CoreKeys.buttonInfoCreatePin,
                                  icon: CoreIcons.info,
                                  iconSize: 22,
                                  color: CoreColors.textSecundary,
                                  // onPressed: () => _showInfo(
                                      // CoreStrings.pinInfo, CoreStrings.info),
                                  onPressed: () {controller.removePin();},
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Visibility(
                              visible: widget.hasPin,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextCustom(
                                    key: CoreKeys.subTitleCreatePin,
                                    text: "Digite o PIN atual",
                                    color: CoreColors.textSecundary,
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormFieldCustom(
                                    key: CoreKeys.formFieldCreatePin,
                                    keyboardType: TextInputType.number,
                                    maxLength: 5,
                                    label: CoreStrings.labelPin,
                                    colorTextInput: CoreColors.textSecundary,
                                    colorTextLabel: CoreColors.textSecundary,
                                    cursorColor: CoreColors.textSecundary,
                                    colorErrorText: CoreColors.textSecundary,
                                    colorBorder: CoreColors.textSecundary,
                                    controller: currentPinController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length < 5) {
                                        return CoreStrings.pinMustContain;
                                      }
                                      return null;
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButtonCustom(
                                        text: "Esqueceu o PIN? Clique Aqui!",
                                        colorText: CoreColors.textSecundary,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          showCustomBottomSheet(
                                            context: context,
                                            useRootNavigator: true,
                                            child: BlocProvider.value(
                                              value: controller,
                                              child: ResetPinBottomSheet(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextCustom(
                              // key: CoreKeys.subTitleCreatePin,
                              text: !widget.hasPin
                                  ? "Digite o PIN"
                                  : "Digite o novo PIN",
                              color: CoreColors.textSecundary,
                            ),
                            const SizedBox(height: 8),
                            TextFormFieldCustom(
                              // key: CoreKeys.formFieldCreatePin,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              label: CoreStrings.labelPin,
                              colorTextInput: CoreColors.textSecundary,
                              colorTextLabel: CoreColors.textSecundary,
                              cursorColor: CoreColors.textSecundary,
                              colorErrorText: CoreColors.textSecundary,
                              colorBorder: CoreColors.textSecundary,
                              controller: newAndUpdatePinController,
                              validator: (value) {
                                if (value == null || value.trim().length < 5) {
                                  return CoreStrings.pinMustContain;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButtonCustom(
                                    key: CoreKeys.cancelCreatePin,
                                    text: CoreStrings.cancel,
                                    colorText: CoreColors.textTertiary,
                                    fontSize: 16,
                                    onPressed: () {
                                      controller.resetPinForm();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ButtonCustom(
                                    key: CoreKeys.buttonCreatePin,
                                    colorText: CoreColors.textPrimary,
                                    text: CoreStrings.save,
                                    fontSize: 16,
                                    backgroundButton:
                                        CoreColors.buttonColorSecond,
                                    onPressed: !state.isFormValid
                                        ? null
                                        : () async {
                                            final newAndUpdatePin = newAndUpdatePinController.text;
                                            final currentPin = currentPinController.text;
                                            await controller.savePin(currentPin, newAndUpdatePin, widget.hasPin);
                                          },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
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
