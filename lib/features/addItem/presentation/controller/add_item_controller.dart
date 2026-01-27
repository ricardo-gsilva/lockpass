import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/utils/validators/validators.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/features/addItem/presentation/state/add_item_state.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/models/itens_model.dart';

class AddItemController extends Cubit<AddItemState> {
  final DataBaseHelper _db;

  AddItemController({
    required DataBaseHelper db, 
  }) : _db = db,
  super(const AddItemState());
  
  void listItemDropDown(List<ItensModel>? itens){
    final list = itens?.map((e) => e.type.toString()).toSet().toList();
    emit(state.copyWith(listItensDrop: list));
  }

  void visibilityPass(){
    emit( state.copyWith(
      sufixIcon: !state.sufixIcon,
      obscureText: !state.sufixIcon,
    ));
  }

  void onFormChanged({
    required String service,
    required String email,
    required String login,
    required String password,
  }) {
    final valid = service.isNotNullOrBlank &&
        email.isNotNullOrBlank &&
        email.isValidEmail &&
        login.isNotNullOrBlank &&
        password.isNotNullOrBlank;

    emit(state.copyWith(isFormValid: valid));
  }


  Future<void> formValidator(ItensModel item) async {    
    if (item.password.isNullOrBlank || item.login.isNullOrBlank ||
        item.service.isNullOrBlank) {
        emit(state.copyWith(
          exception: CoreStrings.manyEmptyFields,
          message: '',
          createdItem: false,
        ));
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if(uid.isNullOrBlank){
      emit(state.copyWith(
        exception: "Usuário não autenticado.",
        message: '',
        createdItem: false,
      ));
      return;
    }

    final type = (item.type.isNullOrBlank) ? (state.listItensDrop.isNotEmpty
        ? state.listItensDrop.first : CoreStrings.noDefinedGroup) 
        : item.type!.trim();    

    final encryptedPass = await EncryptDecrypt.encrypted(item.password!.trim());

    final itemFinal = item.copyWith(
      userId: uid,
      type: type,
      password: encryptedPass,
    );
    await addItem(itemFinal);
  }  

  Future<void> addItem(ItensModel item) async {
    emit(state.copyWith(
      isLoading: true,
      exception: "",
      message: "",
    ));

    final loadingTime = Stopwatch()..start();

    const minDuration = Duration(milliseconds: 600);
    final elapsed = loadingTime.elapsed;
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }

    try {
      await _db.addItem(item);      

      emit( state.copyWith(
        isLoading: false,
        message: "Item salvo com sucesso!",
        createdItem: true
      ));
    } catch (e) {
      emit( state.copyWith(
        isLoading: false,
        exception: "Erro ao salvar item!",
        createdItem: false
      ));
    }
  }

  void clearFeedback() {
    emit(state.copyWith(exception: '', message: ''));
  }

  void setDropDownGroups(List<ItensModel> itens) {
    final groups = itens
            .map((e) => e.type)
            .whereType<String>()
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toSet()
            .toList()
            ..sort();
    emit(state.copyWith(listItensDrop: groups));
  }
}