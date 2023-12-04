import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/database/shared_preferences.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:lockpass/screens/add_item.dart';
import 'package:lockpass/screens/config.dart';
import 'package:lockpass/screens/list_item.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'home_page_store.g.dart';

class HomePageStore = HomePageStoreBase with _$HomePageStore;

abstract class HomePageStoreBase with Store {
  SharedPrefs? sharedPref;
  DataBaseHelper db = DataBaseHelper();

  @observable
  ObservableList<ItensModel> listItens = ObservableList<ItensModel>();

  @observable
  ObservableList<TypeModel> listTypes = ObservableList<TypeModel>();

  @observable
  ObservableList<ItensModel> filterItens = ObservableList<ItensModel>();

  @observable
  ObservableList<String> typeLenghtClear = ObservableList<String>();

  @observable
  ObservableList<String> filterType = ObservableList<String>();

  @observable
  ObservableList<TypeModel> type = ObservableList<TypeModel>();

  @observable
  bool searchTextField = false;

  @observable
  TextEditingController searchController = TextEditingController();

  @observable
  int pin = 0;

  @observable
  String? path;

  @observable
  int selectedIndex = 0;

  @observable
  int mode = 0;

  @observable
  bool isChecked = false;

  @observable
  List<Widget> listScreens = ObservableList<Widget>();

  @action
  sharedPrefs() {
    SharedPreferences.getInstance().then((value) {
      sharedPref = SharedPrefs(sharedPreferences: value);
    });
  }

  @action
  visibleSearch() {
    searchTextField = !searchTextField;
  }

  @action
  Future<bool> getPin() async {
    await sharedPrefs();
    bool isVisible = sharedPref?.getVisibleInfoCreatePin()?? false;
    if (isVisible) {
      return false;
    } else {
      String checkPin = sharedPref?.getPin() ?? '';
      if (checkPin.isEmpty) {
        return true;
      } else {
        return false;
      }
    }    
  }

  @action
  checkBoxVisibleInfoPin(bool check) async {
    await sharedPrefs();
    isChecked = check;
    sharedPref?.setVisibleInfoCreatePin(isChecked);
  }

  @action
  bool visibleIconSearch(int index) {
    if (index != 0) {
      return false;
    } else {
      return true;
    }
  }

  @action
  Future getPlatform() async {
    if (Platform.isAndroid) {
      path = await AndroidPathProvider.downloadsPath;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      path = directory.path;
    }
  }

  @action
  Future getData() async {
    if (mode == 0) {
      await db.getItens().then((lista) {
        listItens = lista.asObservable();
        filterList(listItens, '');
      });
      if (listItens.isNotEmpty) {
        searchList(searchController.text);
      }
    }
  }

  @action
  List<ItensModel> searchList(String search) {
    filterList(listItens, search);
    return filterItens;
  }

  @action
  bool loadingWidget(List<ItensModel> list) {
    if (list.isEmpty && selectedIndex == 0) {
      return true;
    } else if (list.isNotEmpty && selectedIndex == 0) {
      return false;
    } else {
      return false;
    }
  }

  @action
  filterList(List<ItensModel> itens, String search) {
    filterType = ObservableList();
    type = ObservableList();
    filterItens = itens
        .where((e) => e.login!.toLowerCase().contains(search))
        .toList()
        .asObservable();
    filterItens.map((e) {
      filterType.add(e.type.toString());
      typeLenghtClear = filterType.toSet().toList().asObservable();
    }).toList();
    if (typeLenghtClear.isNotEmpty) {
      typeLenghtClear.map((e) {
        type.add(TypeModel.fromMap({"type": e}));
      }).toList();
      listTypes = type.toSet().toList().asObservable();
    }
  }

  @action
  List<Widget> screens() {
    listScreens = [
      ListItem(mode: mode, itens: filterItens, listTypes: listTypes, getData: getData,),
      AddItem(itens: listItens),
      const Config(),
    ];
    return listScreens;
  }

  @action
  Future<void> requestPermission(Permission permission) async {
    await sharedPrefs();
    final status = await permission.request();
    if (status.isGranted) {
      sharedPref?.setPermissionStorage(true);
    } else {
      sharedPref?.setPermissionStorage(false);
    }
  }

  @action
  void onItemTapped(int index) {
    selectedIndex = index;
    if ((index > 0)) {
      if (mode == 1 || mode == 0) {
        mode = 1;
      }
    } else if (index == 0 && mode == 0) {
      mode = 1;
    } else {
      mode = 0;
    }

    if (mode == 0) {
      getData();
    }
    filterList(listItens, searchController.text);
  }
}
