import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final Color? confirmButtonColor;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.confirmButtonText,
    required this.onConfirm,
    this.confirmButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.bottomSystemSpace),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextCustom(
                            text: title,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CoreColors.textSecundary,
                          ),
                          const SizedBox(height: 16),
                          TextCustom(
                            text: description,
                            fontSize: 16,
                            color: CoreColors.textSecundary,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButtonCustom(
                                colorText: CoreColors.textTertiary,
                                text: CoreStrings.cancel,
                                fontSize: 16,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              ButtonCustom(
                                colorText: CoreColors.textPrimary,
                                backgroundButton: confirmButtonColor ?? CoreColors.buttonColorSecond,
                                text: confirmButtonText,
                                fontSize: 16,
                                onPressed: onConfirm,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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