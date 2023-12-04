import 'package:flutter/material.dart';
import 'package:lockpass/widgets/text_custom.dart';

class InfoItemCustom extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final double? fontSizeSubTitle;

  const InfoItemCustom({
    this.title,
    this.subtitle,
    this.fontSizeSubTitle,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10, left: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextCustom(text: title),
          TextCustom(
            text: subtitle,
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}
