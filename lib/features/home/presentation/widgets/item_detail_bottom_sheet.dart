import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/features/home/presentation/widgets/item_edit_view.dart';
import 'package:lockpass/features/home/presentation/widgets/item_info_view.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class ItemDetailsBottomSheet extends StatefulWidget {
  final ItensModel item;
  final List<TypeModel> listGroups;

  const ItemDetailsBottomSheet({
    super.key,
    required this.item,
    required this.listGroups,
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

  @override
  void initState() {
    super.initState();
    groupController = TextEditingController(text: widget.item.type);
    serviceController = TextEditingController(text: widget.item.service);
    siteController = TextEditingController(text: widget.item.site ?? '');
    emailController = TextEditingController(text: widget.item.email);
    loginController = TextEditingController(text: widget.item.login);
    passwordController =
        TextEditingController(text: widget.item.password);
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

  void _resetControllers() {
    groupController.text = widget.item.type;
    serviceController.text = widget.item.service;
    siteController.text = widget.item.site ?? '';
    emailController.text = widget.item.email;
    loginController.text = widget.item.login;
    passwordController.text = widget.item.password;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final controller = context.read<HomeController>();
    return BlocListener<HomeController, HomeState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.errorMessage.isNotNullOrBlank) {
          SnackUtils.showError(
            context,
            content: state.errorMessage,
          );
        }
        if (state.successMessage.isNotNullOrBlank) {
          SnackUtils.showSuccess(
            context,
            content: state.successMessage,
          );
        }
        controller.clearMessages();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: GestureDetector(
          onTap: () {
            controller.toggleItemPasswordVisibility(false);
            Navigator.of(context).pop();
          },
          behavior: HitTestBehavior.opaque,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.99999,
                    ),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: BlocBuilder<HomeController, HomeState>(
                      buildWhen: (prev, curr) =>
                          prev.isEditingItem != curr.isEditingItem ||
                          prev.showItemPassword != curr.showItemPassword ||
                          prev.isSavingItem != curr.isSavingItem ||
                          prev.isFormValid != curr.isFormValid ||
                          prev.hasChanges != curr.hasChanges,
                      builder: (context, state) {
                        final item = state.selectedItem ?? widget.item;
                        final isEditing = state.isEditingItem;
                        final groupOptions = widget.listGroups
                            .map((t) => t.type ?? '')
                            .where((t) => t.isNotEmpty)
                            .toList();
                        return Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              final currentItem = item.copyWith(
                                type: groupController.text.trim(),
                                service: serviceController.text.trim(),
                                site: siteController.text.trim(),
                                email: emailController.text.trim(),
                                login: loginController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                              controller.onFormChanged(
                                originalItem: item,
                                currentItem: currentItem,
                                isFormValid: isValid,
                              );
                            },
                            child: SingleChildScrollView(
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
                                            .withOpacity(0.5),
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
                                      IconButtonCustom(
                                        icon: isEditing
                                            ? CoreIcons.close
                                            : CoreIcons.edit,
                                        color: CoreColors.textSecundary,
                                        onPressed: () {
                                          _resetControllers();
                                          controller.toggleItemEditing();
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // VIEW MODE

                                  isEditing
                                      ? ItemEditView(
                                          groupController: groupController,
                                          serviceController: serviceController,
                                          siteController: siteController,
                                          emailController: emailController,
                                          loginController: loginController,
                                          passwordController:
                                              passwordController,
                                          groupOptions: groupOptions,
                                          selectedType: state.selectedItem?.type ?? '',
                                        )
                                      : ItemInfoView(
                                          item: item,
                                          showPassword: state.showItemPassword,
                                          password: passwordController.text,
                                          onTogglePassword: controller
                                              .toggleItemPasswordVisibility,
                                        ),
                                  const SizedBox(height: 15),
                                  if (!isEditing)
                                    ButtonCustom(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      backgroundButton:
                                          CoreColors.buttonColorSecond,
                                      colorText: CoreColors.textPrimary,
                                      text: "Fechar",
                                      onPressed: () {
                                        controller.toggleItemPasswordVisibility(false);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  if (isEditing)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _resetControllers();
                                            controller.toggleItemEditing();
                                          },
                                          child: const Text(
                                            CoreStrings.cancel,
                                            style: TextStyle(
                                              color: CoreColors.textTertiary,
                                            ),
                                          ),
                                        ),
                                        ButtonCustom(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          backgroundButton:
                                              CoreColors.buttonColorSecond,
                                          colorText: CoreColors.textPrimary,
                                          text: state.isSavingItem
                                              ? 'Salvando...'
                                              : CoreStrings.save,
                                          onPressed: state.isFormValid &&
                                                  state.hasChanges &&
                                                  !state.isSavingItem
                                              ? () {
                                                  final updatedItem =
                                                      item.copyWith(
                                                    type: groupController.text
                                                        .trim(),
                                                    service: serviceController
                                                        .text
                                                        .trim(),
                                                    site: siteController.text
                                                        .trim(),
                                                    email: emailController.text
                                                        .trim(),
                                                    login: loginController.text
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim(), // texto puro
                                                  );
                                                  controller
                                                      .editItem(updatedItem);
                                                  controller
                                                      .toggleItemEditing();
                                                }
                                              : null,
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
