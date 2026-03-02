import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';
import 'package:lockpass/features/config/presentation/widgets/bottom_sheet/reset_pin_bottom_sheet.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';
import 'package:lockpass/core/ui/components/info_dialog.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';
import 'package:lockpass/core/ui/components/textformfield_custom.dart';

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
  bool _isValid = false;

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
        widgets: [
          TextButtonCustom(
            key: CoreKeys.cancelCreatePin,
            text: CoreStrings.close,
            colorText: CoreColors.textPrimary,
            fontSize: 16,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ConfigController>();
    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ConfigPinCreatedSuccess(:final message):
            if (!mounted) return;
            OverlayToast.showSuccess(content: message);
            Navigator.pop(context);
            break;
          case ConfigError(:final message):
            if (!mounted) return;
            OverlayToast.showSuccess(content: message);
            Navigator.pop(context);
            break;
          default:
            return;
        }
        controller.clearStatus();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: context.bottomSystemSpace),
        child: GestureDetector(
          onTap: () {
            controller.resetPinForm();
            Navigator.pop(context);
          },
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
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: () {
                            final valid = _formKey.currentState?.validate() ?? false;
                            setState(() {
                              _isValid = valid;
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 45,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: CoreColors.textTertiary.withValues(alpha: 0.5),
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
                                    onPressed: () => _showInfo(CoreStrings.pinInfo, CoreStrings.info),
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
                                      text: CoreStrings.enterCurrentPin,
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
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextCustom(
                                text: !widget.hasPin ? CoreStrings.enterPin : CoreStrings.enterNewPin,
                                color: CoreColors.textSecundary,
                              ),
                              const SizedBox(height: 8),
                              TextFormFieldCustom(
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                label: CoreStrings.labelPin,
                                colorTextInput: CoreColors.textSecundary,
                                colorTextLabel: CoreColors.textSecundary,
                                cursorColor: CoreColors.textSecundary,
                                colorErrorText: CoreColors.textSecundary,
                                colorBorder: CoreColors.textSecundary,
                                controller: newAndUpdatePinController,
                                validator: (value) => value.pinError,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButtonCustom(
                                    key: CoreKeys.cancelCreatePin,
                                    text: CoreStrings.cancel,
                                    colorText: CoreColors.textTertiary,
                                    fontSize: 16,
                                    onPressed: () {
                                      controller.resetPinForm();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ButtonCustom(
                                    key: CoreKeys.buttonCreatePin,
                                    colorText: CoreColors.textPrimary,
                                    text: isLoading ? CoreStrings.saving : CoreStrings.save,
                                    fontSize: 16,
                                    backgroundButton: CoreColors.buttonColorSecond,
                                    onPressed: !_isValid
                                        ? null
                                        : () async {
                                            await controller.savePin(
                                              currentPinController.text,
                                              newAndUpdatePinController.text,
                                              widget.hasPin,
                                            );
                                          },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
