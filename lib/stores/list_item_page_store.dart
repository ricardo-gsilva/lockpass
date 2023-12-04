// ignore_for_file: library_private_types_in_public_api

import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:mobx/mobx.dart';

part 'list_item_page_store.g.dart';

class ListItemStore = _ListItemStore with _$ListItemStore;

abstract class _ListItemStore with Store{
  DataBaseHelper db = DataBaseHelper();
  
  @observable
  ObservableList<ItensModel> listDynamic = [ItensModel()].asObservable();

  @observable
  ObservableList<dynamic> alphabetList = [].asObservable();
  
  @action
  changeBool(TypeModel type, List<TypeModel> listType) {
    if (type.visible == true) {
      type.visible = false;
    } else {
      listType.map((e) => e.visible = false).toList();
      type.visible = !type.visible!;
    }
  }

  @action
  listFilter(String type, List<ItensModel> listItens) {
    listDynamic = listItens.where((e) => e.type == type).toList().asObservable();
  }

  @action
  filterList(List<dynamic> list, List<ItensModel> itens) {
    if (list == itens) {
      list.sort((a, b) => a.service!.compareTo(b.service!));
      alphabetList = list.asObservable();
    } else {
      list.sort((a, b) => a.type!.compareTo(b.type!));
      alphabetList = list.asObservable();
    }
  }
}