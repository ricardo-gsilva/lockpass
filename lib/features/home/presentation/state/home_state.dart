import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';

class HomeState {
  final List<ItensModel> listItens;  
  final List<TypeModel> listTypes;  
  final List<ItensModel> filterItens;
  final List<String> typeLenghtClear;
  final List<String> filterType;
  final List<TypeModel> type;
  final bool searchTextField;
  final int pin;
  final String? path;
  final int selectedIndex;
  final int mode;
  final bool isChecked;
  final String searchText;
  final bool showPinAlert;


  const HomeState({
    this.listItens = const [],
    this.listTypes = const [],
    this.filterItens = const [],
    this.typeLenghtClear = const [],
    this.filterType = const [],
    this.type = const [],
    this.searchTextField = false,
    this.pin = 0,
    this.path,
    this.selectedIndex = 0,
    this.mode = 0,
    this.isChecked = false,
    this.searchText = '',
    this.showPinAlert = false,
  });

  HomeState copyWith({
    List<ItensModel>? listItens,
    List<TypeModel>? listTypes,
    List<ItensModel>? filterItens,
    List<String>? typeLenghtClear,
    List<String>? filterType,
    List<TypeModel>? type,
    bool? searchTextField,
    int? pin,
    String? path,
    int? selectedIndex,
    int? mode,
    bool? isChecked,
    String? searchText,
    bool? showPinAlert,
  }) {
    return HomeState(
      listItens: listItens ?? this.listItens,
      listTypes: listTypes ?? this.listTypes,
      filterItens: filterItens ?? this.filterItens,
      typeLenghtClear: typeLenghtClear ?? this.typeLenghtClear,
      filterType: filterType ?? this.filterType,
      type: type ?? this.type,
      searchTextField: searchTextField ?? this.searchTextField,
      pin: pin ?? this.pin,
      path: path ?? this.path,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      mode: mode ?? this.mode,
      isChecked: isChecked ?? this.isChecked,
      searchText: searchText ?? this.searchText,
      showPinAlert: showPinAlert ?? this.showPinAlert,
    );
  }
}
