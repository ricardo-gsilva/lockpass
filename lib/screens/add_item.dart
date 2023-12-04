// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/add_item_store.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/field_custom.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class AddItem extends StatefulWidget {
  final List<ItensModel>? itens;
  const AddItem({
    this.itens,
    super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  AddItemStore store = AddItemStore();

  @override
  void initState() {
    super.initState();
    store.listItemDropDown(widget.itens);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          body: Container(
            color: CoreColors.secondColor,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [                    
                    Visibility(
                      key: CoreKeys.visibilityDropDownAddItem,
                      visible: store.listItensDrop.isEmpty? false : true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: TextCustom(
                              text: CoreStrings.chooseGroupOrRegisterNew,
                              color: CoreColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          DropdownButtonFormField(
                            key: CoreKeys.dropDownAddItem,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: CoreColors.textTertiary, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: CoreColors.textPrimary, width: 1.0),
                              ),
                            ),
                            dropdownColor: CoreColors.tertiaryColor,
                            focusColor: CoreColors.tertiaryColor,
                            value: store.listItensDrop.isEmpty? '' : store.listItensDrop.first,
                            onChanged: (newValue){
                              setState(() {
                                store.typeController.text = newValue.toString();
                              });                  
                            },
                            items: store.listItensDrop.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: TextCustom(text: value.toString(),)
                              );
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
                      controller: store.typeController,
                    ),
                    FieldCustom(
                      key: CoreKeys.fieldCustomService,
                      title: CoreStrings.nameService,
                      label: CoreStrings.labelService,
                      keyboardType: TextInputType.name,
                      controller: store.serviceController,
                      validator: (value) {
                        return store.textFieldValidator(value!);
                      },
                    ),
                    FieldCustom(
                      key: CoreKeys.fieldCustomWebSite,
                      title: CoreStrings.webSite,
                      label: CoreStrings.labelWebSite,
                      controller: store.siteController,
                      keyboardType: TextInputType.url,
                    ),
                    FieldCustom(
                      key: CoreKeys.fieldCustomEmailRegister,
                      title: CoreStrings.emailRegister,
                        label: CoreStrings.labelEmailRegister,
                      keyboardType: TextInputType.emailAddress,
                      controller: store.emailController,
                      validator: (value){
                        return store.validarEmail(value?? '');
                      },
                    ),
                    FieldCustom(
                      key: CoreKeys.fieldCustomLogin,
                      title: CoreStrings.login,
                      keyboardType: TextInputType.text,
                      controller: store.loginController,
                      validator: (value) {
                        return store.textFieldValidator(value!);
                      },
                    ),
                    FieldCustom(
                      key: CoreKeys.fieldCustomPassword,
                      title: CoreStrings.password,
                      keyboardType: TextInputType.text,
                      controller: store.passwordController,
                      obscureText: store.obscureText,
                      validator: (value) {
                        return store.textFieldValidator(value!);
                      },
                      icon: IconButtonCustom(
                        key: CoreKeys.visibilityPasswordAddItem,
                        color: CoreColors.textPrimary,
                        icon: store.sufixIcon? CoreIcons.visibility : CoreIcons.visibilityOff,
                        onPressed: (){
                          store.visibilityPass();
                        }
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ButtonCustom(
                        key: CoreKeys.buttonCustomCreateItem,
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.3,
                        backgroundButton: CoreColors.buttonColorSecond,
                        text: CoreStrings.save,
                        colorText: CoreColors.textPrimary,
                        fontSize: 16,
                        onPressed: () async {
                          store.formValidator(store.passwordController.text,store.loginController.text, store.serviceController.text);
                          if (store.formIsValid) {
                            String passEncrypted = await EncryptDecrypt.encrypted(store.passwordController.text);
                                ItensModel i = ItensModel(
                                  type: ((store.typeController.text.isEmpty) && (store.listItensDrop.isEmpty))?
                                    CoreStrings.noDefinedGroup :
                                    ((store.typeController.text.isEmpty) && (store.listItensDrop.isNotEmpty))?
                                    store.listItensDrop.first : store.typeController.text,
                                  service: store.serviceController.text,
                                  site: store.siteController.text,
                                  email: store.emailController.text,
                                  login: store.loginController.text,
                                  password: passEncrypted,
                                );
                                store.addItem(i);
                                Navigator.popAndPushNamed(context, CoreStrings.nHome);
                          } else {
                            showToast(
                              context: context,
                              CoreStrings.manyEmptyFields,
                              position: StyledToastPosition.center,
                              duration: const Duration(seconds: 4)
                            );
                          }                    
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  void dispose() {    
    super.dispose();
    store.typeController.dispose();
    store.serviceController.dispose();
    store.emailController.dispose();
    store.siteController.dispose();
    store.loginController.dispose();
    store.passwordController.dispose();
  }
}
