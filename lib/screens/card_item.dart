// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/card_item_store.dart';
import 'package:lockpass/widgets/button_custom.dart';
import 'package:lockpass/widgets/edit_item.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/info_item_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';

class CardItem extends StatefulWidget {
  final List<TypeModel>? listType;
  final ItensModel? itens;
  const CardItem({this.listType, this.itens, super.key});

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  CardItemStore store = CardItemStore();

  @override
  void initState() {
    store.getItem(widget.itens!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      store.getSize(MediaQuery.of(context).size.height * 0.6,
          MediaQuery.of(context).size.width * 0.7);
      return TapRegion(
        onTapOutside: (event) {
          if (store.edit == false) {
            if ((store.newIten == widget.itens)) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, CoreStrings.nHome);
            }
          } else {
            store.changeIcon(store.edit);
          }
        },
        child: Center(
            child: Container(
          height: store.height,
          width: store.width,
          color: CoreColors.primaryColor,
          child: Flex(direction: Axis.vertical, children: [
            SizedBox(
              height: store.height * 0.13,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextCustom(
                        key: CoreKeys.titleLoginCardItem,                        
                        text: widget.itens!.login ?? '',
                        fontSize: 20,
                        color: CoreColors.textSecundary,
                      ),
                    ),
                    Material(
                      color: CoreColors.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: IconButtonCustom(
                          key: CoreKeys.iconButtonEditCardItem,
                          icon: store.icon,
                          onPressed: () async {
                            store.changeIcon(store.edit);
                            await store.passDecrypt(widget.itens!.password!);
                            if (store.edit == false) {
                              store.validator(
                                  store.passwordController.text,
                                  store.loginController.text,
                                  store.serviceController.text);
                              if (store.formValidator) {
                                ItensModel i = ItensModel(
                                    type: store.typeController.text,
                                    service: store.serviceController.text,
                                    site: store.siteController.text,
                                    email: store.emailController.text,
                                    login: store.loginController.text,
                                    password: store.passwordController.text);
                              bool save = await store.saveEditItem(i);
                              if (save) {
                                  Navigator.pop(context);
                                  Navigator.popAndPushNamed(context, CoreStrings.nHome);
                                  showMessage(CoreStrings.updateSucess);
                                } else {
                                  showMessage(CoreStrings.updateError);
                                }
                              } else {
                                showMessage(CoreStrings.manyEmptyFields);
                              }
                            } else {
                              store.listItemDropDown(widget.listType!);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: store.width,
                height: store.height * 0.5,
                color: CoreColors.secondColor,
                child: SingleChildScrollView(
                  child: store.edit == false
                      ? infoItem(widget.itens!)
                      : editItem(widget.itens!, widget.listType),
                ),
              ),
            ),
            rowButtons(widget.itens!),
          ]),
        )),
      );
    });
  }

  Widget rowButtons(ItensModel item) {
    return Observer(builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: store.height * 0.09,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: CoreColors.primaryColor,
                child: IconButtonCustom(
                  key: CoreKeys.arrowBackCardItem,
                  icon: CoreIcons.arrowBack,
                  color: CoreColors.textSecundary,
                  onPressed: () {
                    if (store.edit == false) {
                      if ((store.newIten == widget.itens)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        Navigator.popAndPushNamed(context, CoreStrings.nHome);
                      }
                    } else {
                      store.changeIcon(store.edit);
                    }
                  },
                ),
              ),
              Visibility(
                key: CoreKeys.visibleButtonSaveEdit,
                visible: store.edit,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ButtonCustom(
                    key: CoreKeys.buttonSaveEditCardItem,
                    height: 50,
                    text: CoreStrings.save,
                    colorText: CoreColors.textPrimary,
                    fontSize: 16,
                    width: MediaQuery.of(context).size.width * 0.3,
                    backgroundButton: CoreColors.buttonColorSecond,
                    onPressed: () async {
                      store.changeIcon(store.edit);
                      store.passDecrypt(widget.itens!.password!);
                      if (store.edit == false) {
                        store.validator(
                            store.passwordController.text,
                            store.loginController.text,
                            store.serviceController.text);
                        if (store.formValidator) {
                          ItensModel i = ItensModel(
                              id: item.id,
                              type: store.typeController.text,
                              service: store.serviceController.text,
                              site: store.siteController.text,
                              email: store.emailController.text,
                              login: store.loginController.text,
                              password: store.passwordController.text);

                          bool save = await store.saveEditItem(i);
                          if (save) {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(
                                context, CoreStrings.nHome);
                            showMessage(CoreStrings.updateSucess);
                          } else {
                            showMessage(CoreStrings.updateError);
                          }
                        } else {
                          showMessage(CoreStrings.manyEmptyFields);
                        }
                      } else {
                        store.listItemDropDown(widget.listType!);
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  ToastFuture showMessage(String msg) {
    return showToast(
        context: context,
        CoreStrings.updateCardItem,
        position: StyledToastPosition.top,
        duration: const Duration(seconds: 3));
  }

  Widget infoItem(ItensModel itens) {
    return Observer(builder: (context) {
      return Flex(direction: Axis.vertical, children: [
        InfoItemCustom(
          key: CoreKeys.groupCardItem,
          title: CoreStrings.group,
          subtitle: itens.type ?? '',
          fontSizeSubTitle: 18,
        ),
        InfoItemCustom(
          key: CoreKeys.serviceCardItem,
          title: CoreStrings.service,
          subtitle: itens.service ?? '',
          fontSizeSubTitle: 18,
        ),
        InfoItemCustom(
          key: CoreKeys.webSiteCardItem,
          title: CoreStrings.webSite,
          subtitle: itens.site ?? '',
          fontSizeSubTitle: 18,
        ),
        InfoItemCustom(
          key: CoreKeys.emailCardItem,
          title: CoreStrings.email,
          subtitle: itens.email ?? '',
          fontSizeSubTitle: 18,
        ),
        InfoItemCustom(
          key: CoreKeys.loginCardItem,
          title: CoreStrings.login,
          subtitle: itens.login ?? '',
          fontSizeSubTitle: 18,
        ),   
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: InfoItemCustom(
                key: CoreKeys.passwordCardItem,
                title: CoreStrings.password,
                subtitle: store.visibilityPassword,
                fontSizeSubTitle: 18,
              ),
            ),            
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Material(
                  color: CoreColors.secondColor,
                  child: IconButtonCustom(
                      key: CoreKeys.visiblePasswordCardItem,
                      onPressed: () async {
                        store.visibilityPass(itens.password.toString());
                      },
                      icon: store.visiblePass == false
                          ? CoreIcons.visibility
                          : CoreIcons.visibilityOff,
                      color: CoreColors.textPrimary)),
            )
          ],
        ),
      ]);
    });
  }

  Widget editItem(ItensModel itens, List<TypeModel>? listType) {
    return Observer(builder: (_) {
      store.listItemDropDown(listType!);
      store.getSize(MediaQuery.of(context).size.height * 0.6,
          MediaQuery.of(context).size.width * 0.7);
      return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const TextCustom(
                        text: CoreStrings.selectGroup,
                        color: CoreColors.textPrimary,
                        fontSize: 16,
                      ),
                      Material(
                        color: CoreColors.transparent,
                        child: DropdownButtonFormField(
                          value: store.listTypeDrop.isEmpty
                              ? ''
                              : store.listTypeDrop.first,
                          onChanged: (newValue) {
                            store.typeController.text = newValue.toString();
                          },
                          items: store.listTypeDrop.map((value) {
                            return DropdownMenuItem(
                                value: value,
                                child: TextCustom(
                                  text: value.toString(),
                                ));
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                EditItem(
                  title: CoreStrings.group,
                  width: store.width * 0.9,
                  controller: store.typeController =
                    TextEditingController(text: itens.type ?? '')
                ),
                EditItem(
                  title: CoreStrings.service,
                  width: store.width * 0.9,
                  controller: store.serviceController =
                    TextEditingController(text: itens.service?? ''),
                  validator: (value) {
                    return store.textFieldValidator(value!);
                  },
                ),
                EditItem(
                  title: CoreStrings.webSite,
                  width: store.width * 0.9,
                  controller: store.siteController =
                    TextEditingController(text: itens.site?? '')
                ),
                EditItem(
                  title: CoreStrings.email,
                  width: store.width * 0.9,
                  controller: store.emailController =
                    TextEditingController(text: itens.email?? ''),
                  validator: (value) {
                    return store.textFieldValidator(value!);
                  },
                ),
                EditItem(
                  title: CoreStrings.login,
                  width: store.width * 0.9,
                  controller: store.loginController =
                    TextEditingController(text: itens.login?? ''),
                  validator: (value) {
                    return store.textFieldValidator(value!);
                  },
                ),
                EditItem(
                  title: CoreStrings.password,
                  width: store.width * 0.9,
                  controller: store.passwordController =
                    TextEditingController(text: store.password),
                  validator: (value) {
                    return store.textFieldValidator(value!);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
