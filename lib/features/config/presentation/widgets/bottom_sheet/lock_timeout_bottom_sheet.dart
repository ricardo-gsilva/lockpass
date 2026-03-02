import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/config/presentation/state/config_state.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/features/config/presentation/state/config_status.dart';

class LockTimeoutBottomSheet extends StatefulWidget {
  const LockTimeoutBottomSheet({super.key});

  @override
  State<LockTimeoutBottomSheet> createState() => _LockTimeoutBottomSheetState();
}

class _LockTimeoutBottomSheetState extends State<LockTimeoutBottomSheet> {
  late final ConfigController controller;
  int valueTimer = 0;

  @override
  void initState() {
    super.initState();
    controller = context.read<ConfigController>();
    valueTimer = controller.getLockTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigController, ConfigState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ConfigSuccess(:final message):
            if (!context.mounted) return;
            OverlayToast.showSuccess(content: message);
            Navigator.pop(context);
            break;
          case ConfigError(:final message):
            if (!context.mounted) return;
            OverlayToast.showError(content: message);
            break;
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
                    padding: const EdgeInsets.all(20),
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
                              text: CoreStrings.screenLockTitle,
                              color: CoreColors.textSecundary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 15),
                            const TextCustom(
                              text: CoreStrings.screenLockExplanation,
                              color: CoreColors.textSecundary,
                              fontSize: 15,
                            ),
                            const SizedBox(height: 24),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonCustom(
                                  isLoading: isLoading,
                                  backgroundButton:
                                      valueTimer == 15 ? CoreColors.textButtonColor : CoreColors.buttonColorSecond,
                                  colorText: CoreColors.textPrimary,
                                  text: CoreStrings.duration15s,
                                  onPressed: () async {
                                    await controller.setLockTimeout(15);
                                  },
                                ),
                                SizedBox(height: 5),
                                ButtonCustom(
                                  isLoading: isLoading,
                                  backgroundButton:
                                      valueTimer == 30 ? CoreColors.textButtonColor : CoreColors.buttonColorSecond,
                                  colorText: CoreColors.textPrimary,
                                  text: CoreStrings.duration30s,
                                  onPressed: () async {
                                    await controller.setLockTimeout(30);
                                  },
                                ),
                                SizedBox(height: 5),
                                ButtonCustom(
                                  isLoading: isLoading,
                                  backgroundButton:
                                      valueTimer == 45 ? CoreColors.textButtonColor : CoreColors.buttonColorSecond,
                                  colorText: CoreColors.textPrimary,
                                  text: CoreStrings.duration45s,
                                  onPressed: () async {
                                    await controller.setLockTimeout(45);
                                  },
                                ),
                                SizedBox(height: 5),
                                ButtonCustom(
                                  isLoading: isLoading,
                                  backgroundButton:
                                      valueTimer == 60 ? CoreColors.textButtonColor : CoreColors.buttonColorSecond,
                                  colorText: CoreColors.textPrimary,
                                  text: CoreStrings.duration60s,
                                  onPressed: () async {
                                    await controller.setLockTimeout(60);
                                  },
                                ),
                                SizedBox(height: 5),
                                ButtonCustom(
                                  isLoading: isLoading,
                                  backgroundButton:
                                      valueTimer == 0 ? CoreColors.textButtonColor : CoreColors.buttonColorSecond,
                                  colorText: CoreColors.textPrimary,
                                  text: CoreStrings.doNotLock,
                                  onPressed: () async {
                                    await controller.setLockTimeout(0);
                                  },
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const TextCustom(
                                    text: CoreStrings.cancel,
                                    color: CoreColors.textTertiary,
                                  ),
                                ),
                              ],
                            )
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
