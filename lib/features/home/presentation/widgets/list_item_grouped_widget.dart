import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/core/utils/ui/bottom_sheet_utils.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/features/home/presentation/widgets/delete_item_bottom_sheet.dart';
import 'package:lockpass/widgets/text_custom.dart';

class ListItemGroupedWidget extends StatelessWidget {
  const ListItemGroupedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeController, HomeState>(
      builder: (context, state) {
        final controller = context.read<HomeController>();
        if (state.allTypes.isEmpty) return const SizedBox.shrink();

        final groupKeys =
            controller.buildTypesFromFiltered(state.filteredItems);

        return ListView.builder(
          shrinkWrap: true,
          itemCount: groupKeys.length,
          itemBuilder: (context, groupIndex) {
            final type = state.allTypes[groupIndex];
            final isExpanded = type.visible ?? false;
            final groupItems = state.filteredItems
                .where((item) => item.type == type.type)
                .toList();

            return Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 8, left: 12, right: 12),
              child: Container(
                // DESIGN: O Card principal agora é mais redondo e tem uma sombra leve
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: CoreColors.titleItem,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Column(
                  children: [
                    // DESIGN: Header do grupo mais limpo
                    ListTile(
                      onTap: () =>
                          context.read<HomeController>().toggleGroup(type),
                      title: Text(
                        type.type.toString().toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 1.1),
                      ),
                      trailing: Icon(
                        isExpanded
                            ? Icons.remove_circle_outline
                            : Icons.add_circle_outline,
                        color: Colors.black54,
                      ),
                    ),

                    // SUA LÓGICA ORIGINAL: Mantida exatamente como estava
                    Visibility(
                      visible: isExpanded,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: groupItems.length,
                        itemBuilder: (context, index) {
                          final item = groupItems[index];
                          return Dismissible(
                            key: Key(item.login ?? '$groupIndex-$index'),
                            background: Container(color: CoreColors.deleteItem),
                            confirmDismiss: (direction) async {
                              final confirm = await showCustomBottomSheet<bool>(
                                context: context,
                                child: BlocProvider.value(
                                  value: controller,
                                  child: DeleteItemBottomSheet(item: item),
                                ),
                              );
                              return confirm ?? false;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4, left: 5, right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: CoreColors.cardItem.withOpacity(0.5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2))
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // DESIGN: Removemos o container interno pesado e usamos o ListTile direto
                                    ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      title: TextCustom(text: item.service),
                                      subtitle: Text(item.login ?? '',
                                          style: TextStyle(
                                              color: Colors.black54, fontSize: 13)),
                                      trailing: const Icon(CoreIcons.visibility,
                                          size: 20),
                                      onTap: () {/* Seu código de info */},
                                    ),
                                    // DESIGN: Divisor sutil para separar os itens sem poluir
                                    if (index < groupItems.length - 1)
                                      Divider(
                                          height: 1,
                                          indent: 20,
                                          endIndent: 20,
                                          color: Colors.black.withOpacity(0.05)),
                                    // Espaço final para não colar na borda do card
                                    if (index == groupItems.length - 1)
                                      const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
