import 'package:flutter/material.dart';
import 'package:lockpass/widgets/text_custom.dart';

class InfoItemCustom extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? fontSizeSubTitle;
  final Color? titleColor;
  final Color? subtitleColor;

  const InfoItemCustom({
    required this.title,
    required this.subtitle,
    this.fontSizeSubTitle,
    this.titleColor,
    this.subtitleColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextCustom(
            text: title,
            color: titleColor,
          ),
          TextCustom(
            text: subtitle,
            color: subtitleColor,
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}
