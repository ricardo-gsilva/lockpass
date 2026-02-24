import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/add_item/presentation/controller/add_item_controller.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_state.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_status.dart';

class AddItemPage extends StatefulWidget {
  final List<ItensEntity>? itens;
  const AddItemPage({this.itens, super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController groupController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late final AddItemController addItemController;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    addItemController = getIt<AddItemController>();
    addItemController.setDropDownGroups(widget.itens ?? []);
  }

  @override
  void dispose() {
    super.dispose();
    groupController.dispose();
    serviceController.dispose();
    siteController.dispose();
    emailController.dispose();
    loginController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: addItemController,
      child: BlocListener<AddItemController, AddItemState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          switch (state.status) {
            case AddItemSuccess():
              OverlayToast.showSuccess(content: "Item criado com sucesso!");
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );  
              break;
            case AddItemFailure(:final message):
              OverlayToast.showError(content: message);
            default:
              break;
          }          
        },
        child: BlocBuilder<AddItemController, AddItemState>(
          builder: (context, state) {
            final isLoading = state.status is AddItemLoading;
            return Scaffold(
              body: Container(
                color: CoreColors.secondColor,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      onChanged: () {
                        addItemController.onFormChanged(
                          service: serviceController.text,
                          email: emailController.text,
                          login: loginController.text,
                          password: passwordController.text,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Visibility(
                            key: CoreKeys.visibilityDropDownAddItem,
                            visible: state.listItensDrop.isEmpty ? false : true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: TextCustom(
                                    text: CoreStrings.chooseGroupOrRegisterNew,
                                    color: CoreColors.transparent,
                                    fontSize: 16,
                                  ),
                                ),
                                DropdownButtonFormField(
                                  key: CoreKeys.dropDownAddItem,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: CoreColors.transparent,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 16),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          color: CoreColors.textTertiary,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                          color: CoreColors.textPrimary,
                                          width: 1.0),
                                    ),
                                  ),
                                  dropdownColor: CoreColors.dropDownField,
                                  focusColor: CoreColors.transparent,
                                  initialValue: state.listItensDrop.isEmpty
                                      ? ''
                                      : state.listItensDrop.first,
                                  onChanged: (newValue) {
                                    groupController.text = newValue.toString();
                                  },
                                  items: state.listItensDrop.map((value) {
                                    return DropdownMenuItem(
                                        value: value,
                                        child: TextCustom(
                                          text: value.toString(),
                                        ));
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: TextCustom(
                              text: CoreStrings.addNewGroup,
                              color: CoreColors.textPrimary,
                              fontSize: 16,
                            ),
                            contentPadding: const EdgeInsets.only(),
                            subtitle: FieldsFactory.text(
                              label: CoreStrings.labelGroup,
                              controller: groupController,
                              color: CoreColors.textPrimary,
                            ),
                          ),
                          ListTile(
                            title: TextCustom(
                              text: CoreStrings.nameService,
                              color: CoreColors.textPrimary,
                              fontSize: 16,
                            ),
                            contentPadding: const EdgeInsets.only(),
                            subtitle: FieldsFactory.text(
                              label: CoreStrings.labelService,
                              controller: serviceController,
                              color: CoreColors.textPrimary,
                              validator: (value) {
                                if (value.isNullOrBlank) return CoreStrings.fillField;
                                return null;
                              },
                            ),
                          ),
                          ListTile(
                            title: TextCustom(
                              text: CoreStrings.webSite,
                              color: CoreColors.textPrimary,
                              fontSize: 16,
                            ),
                            contentPadding: const EdgeInsets.only(),
                            subtitle: FieldsFactory.text(
                              label: CoreStrings.labelWebSite,
                              controller: siteController,
                              keyboardType: TextInputType.url,
                              color: CoreColors.textPrimary,
                            ),
                          ),
                          ListTile(
                            title: TextCustom(
                              text: CoreStrings.emailRegister,
                              color: CoreColors.textPrimary,
                              fontSize: 16,
                            ),
                            contentPadding: const EdgeInsets.only(),
                            subtitle: FieldsFactory.email(
                              label: CoreStrings.labelEmailRegister,
                              controller: emailController,
                              color: CoreColors.textPrimary,
                              validator: (value) => value.emailError,
                            ),
                          ),
                          ListTile(
                            title: TextCustom(
                              text: CoreStrings.login,
                              color: CoreColors.textPrimary,
                              fontSize: 16,
                            ),
                            contentPadding: const EdgeInsets.only(),
                            subtitle: FieldsFactory.text(
                              controller: loginController,
                              keyboardType: TextInputType.url,
                              color: CoreColors.textPrimary,
                              validator: (value) {
                                if (value.isNullOrBlank) return CoreStrings.fillField;
                                return null;
                              },
                            ),
                          ),
                          ListTile(
                            title: TextCustom(
                              text: CoreStrings.password,
                              color: CoreColors.textPrimary,
                              fontSize: 16,
                            ),
                            contentPadding: const EdgeInsets.only(),
                            subtitle: FieldsFactory.password(
                              controller: passwordController,
                              color: CoreColors.textPrimary,
                              obscureText: _obscurePassword,
                              onToggleVisibility: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              validator: (value) {
                                if (value.isNullOrBlank) return CoreStrings.fillField;
                                return null;
                              },
                            ),
                          ),                          
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ButtonCustom(
                              key: CoreKeys.buttonCustomCreateItem,
                              isLoading: isLoading,
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.5,
                              backgroundButton: CoreColors.buttonColorSecond,
                              text:
                                  isLoading ? "Salvando..." : CoreStrings.save,
                              colorText: CoreColors.textPrimary,
                              fontSize: 16,
                              onPressed: !state.isFormValid
                                  ? null
                                  : () async {
                                      ItensEntity item = ItensEntity(
                                        userId: addItemController.currentUserId,
                                        group: groupController.text,
                                        service: serviceController.text,
                                        site: siteController.text,
                                        email: emailController.text,
                                        login: loginController.text,
                                        password: passwordController.text,
                                      );
                                      await addItemController
                                          .formValidator(item);
                                    },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
