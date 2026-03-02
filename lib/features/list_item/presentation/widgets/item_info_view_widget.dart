import 'package:flutter/material.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/widgets/info_item_custom.dart';

class ItemInfoViewWidget extends StatelessWidget {
  final ItensEntity item;
  final bool showPassword;
  final String password;
  final VoidCallback onTogglePassword;
  final ListViewModeEnum listMode;

  const ItemInfoViewWidget({
    super.key,
    required this.item,
    required this.showPassword,
    required this.password,
    required this.onTogglePassword,
    required this.listMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoItemCustom(
          title: CoreStrings.group,
          subtitle: item.group.isNotNullOrBlank? item.group : CoreStrings.notInformed,
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        InfoItemCustom(
          title: CoreStrings.service,
          subtitle: item.service.isNotNullOrBlank? item.service : CoreStrings.notInformed,
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        InfoItemCustom(
          title: CoreStrings.webSite,
          subtitle: item.site.isNotNullOrBlank? item.site! : CoreStrings.notInformed,
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        InfoItemCustom(
          title: CoreStrings.email,
          subtitle: item.email.isNotNullOrBlank? item.email : CoreStrings.notInformed,
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        InfoItemCustom(
          title: CoreStrings.login,
          subtitle: item.login.isNotNullOrBlank? item.login : CoreStrings.notInformed,
          titleColor: CoreColors.textSecundary,
          subtitleColor: CoreColors.textSecundary,
        ),
        Visibility(
          visible: listMode == ListViewModeEnum.list,
          child: Row(
            children: [
              Expanded(
                child: InfoItemCustom(
                  title: CoreStrings.password,
                  subtitle: showPassword ? password : CoreStrings.obscurePassword,
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
        ),
      ],
    );
  }
}