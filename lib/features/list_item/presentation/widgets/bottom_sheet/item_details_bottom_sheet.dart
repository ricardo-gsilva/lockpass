import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/ui/overlays/bottom_sheet_utils.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_status.dart';
import 'package:lockpass/features/list_item/presentation/widgets/bottom_sheet/delete_item_bottom_sheet.dart';
import 'package:lockpass/features/list_item/presentation/widgets/item_edit_view_widget.dart';
import 'package:lockpass/features/list_item/presentation/widgets/item_info_view_widget.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';

class ItemDetailsBottomSheet extends StatefulWidget {
  final ItensEntity item;

  const ItemDetailsBottomSheet({
    super.key,
    required this.item,
  });

  @override
  State<ItemDetailsBottomSheet> createState() => _ItemDetailsBottomSheetState();
}

class _ItemDetailsBottomSheetState extends State<ItemDetailsBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController groupController;
  late TextEditingController serviceController;
  late TextEditingController siteController;
  late TextEditingController emailController;
  late TextEditingController loginController;
  late TextEditingController passwordController;
  bool _isEditingItem = false;
  bool _showItemPassword = false;

  void _toggleEditing() {
    setState(() {
      _isEditingItem = !_isEditingItem;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showItemPassword = !_showItemPassword;
    });
  }

  @override
  void initState() {
    super.initState();
    groupController = TextEditingController(text: widget.item.group);
    serviceController = TextEditingController(text: widget.item.service);
    siteController = TextEditingController(text: widget.item.site ?? '');
    emailController = TextEditingController(text: widget.item.email);
    loginController = TextEditingController(text: widget.item.login);
    passwordController = TextEditingController(text: widget.item.password);
  }

  @override
  void dispose() {
    groupController.dispose();
    serviceController.dispose();
    siteController.dispose();
    emailController.dispose();
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _resetControllers(ItensEntity item) {
    groupController.text = item.group;
    serviceController.text = item.service;
    siteController.text = item.site ?? '';
    emailController.text = item.email;
    loginController.text = item.login;
    passwordController.text = item.password;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ListItemController>();
    return BlocListener<ListItemController, ListItemState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        switch (state.status) {
          case ItemUpdatedSuccess():
            OverlayToast.showSuccess(content: "Item atualizado com sucesso!");
            break;

          case ItemDeletedPermanentlySuccess():
            OverlayToast.showSuccess(content: "Item excluído permanentemente");
            Navigator.maybePop(context);
            break;

          case ItemRestoredSuccess():
            OverlayToast.showSuccess(content: "Item restaurado");
            Navigator.maybePop(context);
            break;

          case ListItemError(:final message):
            OverlayToast.showError(content: message);
            break;

          default:
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: context.bottomSystemSpace),
        child: GestureDetector(
          onTap: () {
            controller.onBottomSheetClosed();
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
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: BlocBuilder<ListItemController, ListItemState>(
                      buildWhen: (prev, curr) =>
                          prev.canSave != curr.canSave ||
                          prev.status != curr.status ||
                          prev.selectedItem != curr.selectedItem,
                      builder: (context, state) {
                        final item = state.selectedItem ?? widget.item;
                        final groupOptions = state.allGroups
                            .map((g) => g.groupName)
                            .where((name) => name.isNotEmpty)
                            .toSet()
                            .toList();
                        return Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: () {
                                final isValid =
                                    _formKey.currentState?.validate() ?? false;
                                final currentItem = item.copyWith(
                                  group: groupController.text.trim(),
                                  service: serviceController.text.trim(),
                                  site: siteController.text.trim(),
                                  email: emailController.text.trim(),
                                  login: loginController.text.trim(),
                                  password: passwordController.text.trim(),
                                );

                                controller.onFormChanged(
                                  originalItem: widget.item,
                                  currentItem: currentItem,
                                  isFormValid: isValid,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 45,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: CoreColors.textTertiary
                                            .withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextCustom(
                                        text: item.login,
                                        color: CoreColors.textSecundary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      Visibility(
                                        visible: state.listMode ==
                                            ListViewModeEnum.list,
                                        child: IconButtonCustom(
                                          icon: _isEditingItem
                                              ? CoreIcons.close
                                              : CoreIcons.edit,
                                          color: CoreColors.textSecundary,
                                          onPressed: () {
                                            _resetControllers(item);
                                            _toggleEditing();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _isEditingItem
                                      ? ItemEditViewWidget(
                                          groupController: groupController,
                                          serviceController: serviceController,
                                          siteController: siteController,
                                          emailController: emailController,
                                          loginController: loginController,
                                          passwordController:
                                              passwordController,
                                          groupOptions: groupOptions,
                                          selectedType:
                                              state.selectedItem?.group ?? '',
                                        )
                                      : ItemInfoViewWidget(
                                          item: item,
                                          showPassword: _showItemPassword,
                                          password: passwordController.text,
                                          listMode: state.listMode,
                                          onTogglePassword: () {
                                            _togglePasswordVisibility();
                                          },
                                        ),
                                  const SizedBox(height: 15),
                                  _buildActionButtons(state, item),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

  Widget _buildActionButtons(ListItemState state, ItensEntity item) {
    final controller = context.read<ListItemController>();
    final isLoading = state.status is ListItemLoading;
    if (_isEditingItem) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: () {
              _resetControllers(item);
              _toggleEditing();
            },
            child: const Text(
              CoreStrings.cancel,
              style: TextStyle(color: CoreColors.textTertiary),
            ),
          ),
          ButtonCustom(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.3,
            backgroundButton: CoreColors.buttonColorSecond,
            colorText: CoreColors.textPrimary,
            text: isLoading ? 'Salvando...' : CoreStrings.save,
            onPressed: state.canSave && !isLoading
                ? () {
                    final updatedItem = item.copyWith(
                      group: groupController.text.trim(),
                      service: serviceController.text.trim(),
                      site: siteController.text.trim(),
                      email: emailController.text.trim(),
                      login: loginController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    controller.editItem(updatedItem);
                    _toggleEditing();
                  }
                : null,
          ),
        ],
      );
    }

    if (state.listMode == ListViewModeEnum.trash) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonCustom(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.35,
                backgroundButton: CoreColors.buttonColorSecond,
                colorText: CoreColors.textPrimary,
                text: "Restaurar",
                onPressed: () async {
                  await controller.restoreItem(item);
                },
              ),
              ButtonCustom(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.35,
                backgroundButton: CoreColors.deleteItem,
                colorText: CoreColors.textPrimary,
                text: "Excluir",
                onPressed: () {
                  showCustomBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    child: BlocProvider.value(
                      value: controller,
                      child: ConfirmationBottomSheet(
                        title: "Excluir Permanentemente",
                        description:
                            "Essa ação é irreversível. Você não poderá recuperar esse item!",
                        confirmButtonText: "Excluir",
                        confirmButtonColor: CoreColors.buttonColorSecond,
                        onConfirm: () async {
                          await controller.deletePermanently(item);
                          if (context.mounted) {
                            Future.delayed(Duration.zero, () {
                              if (context.mounted) Navigator.of(context).pop();
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              CoreStrings.cancel,
              style: TextStyle(color: CoreColors.textTertiary),
            ),
          ),
        ],
      );
    }
    return ButtonCustom(
      height: 50,
      backgroundButton: CoreColors.buttonColorSecond,
      colorText: CoreColors.textPrimary,
      text: "Fechar",
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
