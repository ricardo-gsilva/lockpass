import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/utils/ui/snack_bar_utils.dart';
import 'package:lockpass/core/utils/validators/validators.dart';
import 'package:lockpass/features/addItem/presentation/controller/add_item_controller.dart';
import 'package:lockpass/features/addItem/presentation/state/add_item_state.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/field_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class AddItemPage1 extends StatefulWidget {
  final List<ItensModel>? itens;
  const AddItemPage1({this.itens, super.key});

  @override
  State<AddItemPage1> createState() => _AddItemPage1State();
}

class _AddItemPage1State extends State<AddItemPage1> {
  TextEditingController typeController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late final AddItemController addItemController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();    
    addItemController = getIt<AddItemController>();
    addItemController.setDropDownGroups(widget.itens?? []);
  }

  @override
  void dispose() {
    super.dispose();
    typeController.dispose();
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
        listenWhen: (previous, current) =>
            previous.createdItem != current.createdItem ||
            previous.exception != current.exception,
        listener: (context, state) {
          if (state.createdItem) {
            SnackUtils.showSuccess(
              context,
              content: "Item criado com sucesso!",
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          }
          if (state.exception.isNotEmpty) {
            SnackUtils.showError(
              context,
              content: state.exception,
            );
          }
        },
        child: BlocBuilder<AddItemController, AddItemState>(
          builder: (context, state) {
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
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
                                    setState(() {
                                      typeController.text = newValue.toString();
                                    });
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
                          FieldCustom(
                            key: CoreKeys.fieldCustomAddNewGroup,
                            title: CoreStrings.addNewGroup,
                            label: CoreStrings.labelGroup,
                            keyboardType: TextInputType.name,
                            controller: typeController,
                          ),
                          FieldCustom(
                            key: CoreKeys.fieldCustomService,
                            title: CoreStrings.nameService,
                            label: CoreStrings.labelService,
                            keyboardType: TextInputType.name,
                            controller: serviceController,
                            validator: (value) {
                              if (value.isBlank) return CoreStrings.fillField;
                              return null;
                            },
                          ),
                          FieldCustom(
                            key: CoreKeys.fieldCustomWebSite,
                            title: CoreStrings.webSite,
                            label: CoreStrings.labelWebSite,
                            controller: siteController,
                            keyboardType: TextInputType.url,
                          ),
                          FieldCustom(
                            key: CoreKeys.fieldCustomEmailRegister,
                            title: CoreStrings.emailRegister,
                            label: CoreStrings.labelEmailRegister,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            validator: (value) {
                              if (value.isBlank) return CoreStrings.fillField;
                              if (!value.isValidEmail) return CoreStrings.emailInvalid;
                              return null;
                            },
                          ),
                          FieldCustom(
                            key: CoreKeys.fieldCustomLogin,
                            title: CoreStrings.login,
                            keyboardType: TextInputType.text,
                            controller: loginController,
                            validator: (value) {
                              if (value.isBlank) return CoreStrings.fillField;
                              return null;
                            },
                          ),
                          FieldCustom(
                            key: CoreKeys.fieldCustomPassword,
                            title: CoreStrings.password,
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            obscureText: state.obscureText,
                            validator: (value) {
                              if (value.isBlank) return CoreStrings.fillField;
                              return null;
                            },
                            icon: IconButtonCustom(
                                key: CoreKeys.visibilityPasswordAddItem,
                                color: CoreColors.textPrimary,
                                icon: state.sufixIcon
                                    ? CoreIcons.visibility
                                    : CoreIcons.visibilityOff,
                                onPressed: () {
                                  addItemController.visibilityPass();
                                }),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ButtonCustom(
                              key: CoreKeys.buttonCustomCreateItem,
                              isLoading: state.isLoading,
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.5,
                              backgroundButton: CoreColors.buttonColorSecond,
                              text: state.isLoading? "Salvando..." : CoreStrings.save,
                              colorText: CoreColors.textPrimary,
                              fontSize: 16,
                              onPressed: !state.isFormValid ? null :
                                () async {
                                  ItensModel item = ItensModel(
                                    type: typeController.text,
                                    service: serviceController.text,
                                    site: siteController.text,
                                    email: emailController.text,
                                    login: loginController.text,
                                    password: passwordController.text,
                                  );
                                  await addItemController.formValidator(item);
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
