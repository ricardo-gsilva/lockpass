import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/addItem/presentation/state/add_item_state.dart';
import 'package:lockpass/helpers/encrypt_decrypt.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/services/auth_service.dart';

class AddItemController extends Cubit<AddItemState> {
  final AuthService _authService;
  final ItensRepository _itensRepository;

  AddItemController({
    required AuthService authService,
    required ItensRepository itensRepository,
  }) :  _authService = authService,
        _itensRepository = itensRepository,
  super(const AddItemState());

  String get currentUserId => _authService.currentUserId;
  
  void listItemDropDown(List<ItensEntity>? itens){
    final list = itens?.map((e) => e.group.toString()).toSet().toList();
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


  Future<void> formValidator(ItensEntity item) async {    
    if (item.password.isNullOrBlank || item.login.isNullOrBlank ||
        item.service.isNullOrBlank) {
        emit(state.copyWith(
          exception: CoreStrings.manyEmptyFields,
          message: '',
          createdItem: false,
        ));
      return;
    }

    final uid = _authService.currentUserId;
    if(uid.isNullOrBlank){
      emit(state.copyWith(
        exception: "Usuário não autenticado.",
        message: '',
        createdItem: false,
      ));
      return;
    }

    final group = (item.group.isNullOrBlank) ? (state.listItensDrop.isNotEmpty
        ? state.listItensDrop.first : CoreStrings.noDefinedGroup) 
        : item.group.trim();    

    final encryptedPass = EncryptDecrypt.encrypt(item.password.trim(), uid);

    final itemFinal = item.copyWith(
      userId: uid,
      group: group,
      password: encryptedPass,
    );
    await addItem(itemFinal);
  }  

  Future<void> addItem(ItensEntity item) async {
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
      // await _db.addItem(item);
      await _itensRepository.addItem(item);

      emit( state.copyWith(
        isLoading: false,
        message: "Item salvo com sucesso!",
        createdItem: true
      ));
    } catch (e, s) {
      print('❌ ERRO AO SALVAR ITEM');
      

  print(e);
  print(s);
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

  void setDropDownGroups(List<ItensEntity> itens) {
    final groups = itens
            .map((e) => e.group)
            .whereType<String>()
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toSet()
            .toList()
            ..sort();
    emit(state.copyWith(listItensDrop: groups));
  }
}