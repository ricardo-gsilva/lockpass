import 'package:flutter/material.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:mobx/mobx.dart';
part 'add_item_store.g.dart';

class AddItemStore = AddItemStoreBase with _$AddItemStore;

abstract class AddItemStoreBase with Store {
  DataBaseHelper db = DataBaseHelper();

  @observable
  TextEditingController typeController = TextEditingController();

  @observable
  TextEditingController serviceController = TextEditingController();

  @observable
  TextEditingController siteController = TextEditingController();

  @observable
  TextEditingController emailController = TextEditingController();

  @observable
  TextEditingController loginController = TextEditingController();

  @observable
  TextEditingController passwordController = TextEditingController();
  
  @observable
  bool fieldIsValid = false;

  @observable
  bool formIsValid = false;

  @observable
  bool sufixIcon = true;

  @observable
  bool obscureText = true;

  @observable
  ObservableList<String> listItens = ObservableList();

  @observable
  ObservableList<String> listItensDrop = ObservableList();

  @action
  void listItemDropDown(List<ItensModel>? itens){
    itens?.map((e) {
      listItens.add(e.type.toString());
    }).toSet().toList();
    listItensDrop = listItens.toSet().toList().asObservable();
  }

  @action
  visibilityPass(){
    sufixIcon = !sufixIcon;
    obscureText = sufixIcon;
  }
  
  @action
  String? validarEmail(String value) {
    String pattern = CoreStrings.regExpValidateEmail;
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return null;
    } else if(!regExp.hasMatch(value)){
      return CoreStrings.emailInvalid;
    }else {
      return null;
    }
  }

  @action
  String? textFieldValidator(String value){
    if (value.isEmpty) {
      fieldIsValid = false;
      return CoreStrings.fillField;
    } else {
      fieldIsValid = true;
      return null;
    }
  }

  @action
  formValidator(String password, String login, String service){
    if (password.isEmpty || login.isEmpty || service.isEmpty) {
      formIsValid = false;
    } else {
      formIsValid = true;
    }
  }

  @action
  addItem(ItensModel item){
    listItens.add(item.type!);
    db.addItem(item);
    clearController();
  }

  @action
  void clearController(){
      typeController.clear();
      serviceController.clear();
      siteController.clear();
      emailController.clear();
      loginController.clear();
      passwordController.clear();
  }
}