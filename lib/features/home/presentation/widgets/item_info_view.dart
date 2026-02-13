import 'package:flutter/material.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/widgets/info_item_custom.dart';

class ItemInfoView extends StatelessWidget {
  final ItensModel item;
  final bool showPassword;
  final String password;
  final VoidCallback onTogglePassword;

  const ItemInfoView({
    super.key,
    required this.item,
    required this.showPassword,
    required this.password,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoItemCustom(
          title: CoreStrings.group,
          subtitle: item.type.isNotNullOrBlank? item.type : 'Não informado!',
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        InfoItemCustom(
          title: CoreStrings.service,
          subtitle: item.service.isNotNullOrBlank? item.service : 'Não informado!',
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        InfoItemCustom(
          title: CoreStrings.webSite,
          subtitle: item.site.isNotNullOrBlank? item.site! : 'Não informado!',
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        InfoItemCustom(
          title: CoreStrings.email,
          subtitle: item.email.isNotNullOrBlank? item.email : 'Não informado!',
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        InfoItemCustom(
          title: CoreStrings.login,
          subtitle: item.login.isNotNullOrBlank? item.login : 'Não informado!',
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        Row(
          children: [
            Expanded(
              child: InfoItemCustom(
                title: CoreStrings.password,
                subtitle: showPassword ? password : '••••••••',
                titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
              ),
            ),
            IconButton(
              icon: Icon(
                showPassword
                    ? CoreIcons.visibilityOff
                    : CoreIcons.visibility,
                    color: CoreColors.textSecundary,
              ),
              onPressed: onTogglePassword,
            ),
          ],
        ),
      ],
    );
  }
}