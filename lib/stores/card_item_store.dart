import 'package:flutter/material.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:mobx/mobx.dart';
part 'card_item_store.g.dart';

class CardItemStore = CardItemStoreBase with _$CardItemStore;

abstract class CardItemStoreBase with Store {
  DataBaseHelper db = DataBaseHelper();

  @observable
  ItensModel? itens = ItensModel();

  ObservableList<TypeModel>? listType = [TypeModel()].asObservable();

  @observable
  ObservableList<String> listTypeDrop = ObservableList<String>();

  @observable
  String visibilityPassword = '****';

  @observable
  String password = '';

  @observable
  bool visiblePass = false;

  @observable
  bool edit = false;

  @observable
  bool validation = false;

  @observable
  bool formValidator = false;

  @observable
  double height = 0;

  @observable
  double width = 0;

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
  ItensModel newIten = ItensModel.empty();

  @observable
  IconData icon = Icons.edit;

  @action
  listItemDropDown(List<TypeModel> list){
    List<String> copyType = [];
    listType = list.asObservable();
    listType?.map((e) {
      copyType.add(e.type.toString());
    }).toSet().toList();
    listTypeDrop = copyType.toSet().toList().asObservable();
    listTypeDrop;
  }

  @action
  Future<bool> saveEditItem(ItensModel item) async {        
    if (formValidator == true) {
      String passEncrypt = await EncryptDecrypt.encrypted(passwordController.text);
      newIten = ItensModel(
        id: itens?.id,
        type: typeController.text,
        service: serviceController.text,
        site: siteController.text,
        email: emailController.text,
        login: loginController.text,
        password: passEncrypt,
      );
      db.updateItem(newIten);
      clearController();
      return true;
    } else {
      return false;
    }
  }

  @action
  getItem(ItensModel item){
    itens = item;
    newIten = item;
  }

  @action
  getSize(double h, double w){
    height = h;
    width = w;
  }

  @action
  visibilityPass(String pass) async {
    visiblePass = !visiblePass;
      if (visiblePass == true) {
        visibilityPassword = await EncryptDecrypt.decrypt(pass);
      } else {
        visibilityPassword = CoreStrings.obscurePassword;
      }
  }

  @action
  Future<String> passDecrypt(String pass) async {
    password = await EncryptDecrypt.decrypt(pass);
    return password;
  }

  

  @action
  void validator(String password, String login, String service){
    if (password.isEmpty || login.isEmpty || service.isEmpty) {
      formValidator = false;
    } else {
      formValidator = true;
    }
  }

  @action
  String? validarEmail(String value) {
    String pattern = CoreStrings.regExpValidateEmail;
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return CoreStrings.provideEmail;
    } else if(!regExp.hasMatch(value)){
      return CoreStrings.emailInvalid;
    }else {
      return null;
    }
  }

  @action
  String? textFieldValidator(String value){
    if (value.isEmpty) {
      validation = false;
      return CoreStrings.fillField;
    } else {
      validation = true;
    return null;
    }
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

  @action
  changeIcon(bool verifyIcon){
    edit = verifyIcon;
    edit = !edit;
    if (verifyIcon == false) {
      icon = CoreIcons.save;
    } else {
      icon = CoreIcons.edit;
    }
  }  
}