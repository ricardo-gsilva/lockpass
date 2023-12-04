import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

// ignore: must_be_immutable
class InfoDialog extends StatelessWidget {
  String? title;
  String? content;
  VoidCallback? onPressed;

  InfoDialog({
    this.title,
    this.content,
    this.onPressed,
    super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AlertDialog(
        backgroundColor: CoreColors.secondColor,
        title: TextCustom(
          text: title,
        ),
        titlePadding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 5),
        content: TextCustom(text: content),
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 5),
        actions: [
          IconButtonCustom(
            key: CoreKeys.buttonArrowBackPrivateInfoDialog,
            color: CoreColors.textPrimary,
            onPressed: onPressed!,
            icon: CoreIcons.arrowBack,
          ),
        ],
      ),
    );
  }
}
