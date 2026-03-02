import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';

class InfoDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final List<Widget>? widgets;
  final double? fontSizeTitle;
  final double? fontSizeContent;
  final bool isDestructive;

  const InfoDialog({
    this.title,
    this.content,
    this.widgets,
    this.fontSizeTitle,
    this.fontSizeContent,
    this.isDestructive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CoreColors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 26,
        ),
        decoration: BoxDecoration(
          color: CoreColors.secondColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextCustom(
              text: title,
              fontSize: fontSizeTitle ?? 18,
              fontWeight: FontWeight.bold,
              color: isDestructive
                  ? CoreColors.deleteItem
                  : CoreColors.textPrimary,
            ),
            const SizedBox(height: 16),
            TextCustom(
              text: content,
              fontSize: fontSizeContent ?? 15,
              color: CoreColors.textPrimary,
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widgets ?? [],
            ),
          ],
        ),
      ),
    );
  }
}
