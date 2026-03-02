import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/features/add_item/domain/usecases/create_item_usecase.dart';
import 'package:lockpass/features/add_item/domain/usecases/load_item_groups_usecase.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_state.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_status.dart';

class AddItemController extends Cubit<AddItemState> {
  final CreateItemUseCase _createItemUseCase;
  final LoadItemGroupsUseCase _loadItemGroupsUseCase;

  AddItemController({
    required CreateItemUseCase createItemUseCase,
    required LoadItemGroupsUseCase loadItemGroupsUseCase,
  })  : _createItemUseCase = createItemUseCase,
        _loadItemGroupsUseCase = loadItemGroupsUseCase,
        super(const AddItemState());

  void onFormChanged({
    required String group,
    required String service,
    required String email,
    required String login,
    required String password,
  }) {
    final valid = group.isNotNullOrBlank &&
        service.isNotNullOrBlank &&
        email.isNotNullOrBlank &&
        email.isValidEmail &&
        login.isNotNullOrBlank &&
        password.isNotNullOrBlank;

    if (state.isFormValid != valid) {
      emit(state.copyWith(isFormValid: valid));
    }
  }

  Future<void> submit(ItensEntity item) async {
    if (item.password.isNullOrBlank || item.login.isNullOrBlank || item.service.isNullOrBlank) {
      emit(state.copyWith(
        status: AddItemFailure(CoreStrings.manyEmptyFields),
      ));
      return;
    }

    emit(state.copyWith(status: const AddItemLoading()));

    const minDuration = Duration(milliseconds: 600);
    final stopwatch = Stopwatch()..start();

    try {
      await _createItemUseCase(
        item,
        state.listItensDrop,
      );

      final remaining = minDuration - stopwatch.elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }

      emit(state.copyWith(status: AddItemSuccess()));
    } on AuthErrorType catch (type) {
      emit(state.copyWith(
        status: AddItemFailure(type.message),
      ));
    } catch (e) {
      var errorMessage = CoreStrings.saveItemError;
      if (e.toString().contains("SECURITY_FAILURE")) {
        errorMessage = CoreStrings.dataProtectionError;
      }

      emit(state.copyWith(status: AddItemFailure(errorMessage)));
    }
  }

  Future<void> setDropDownGroups() async {
    final groups = await _loadItemGroupsUseCase();

    if (!listEquals(state.listItensDrop, groups)) {
      emit(state.copyWith(listItensDrop: groups));
    }
  }
}
