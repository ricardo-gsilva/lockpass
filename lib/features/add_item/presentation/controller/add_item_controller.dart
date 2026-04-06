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

typedef AddItemDelayFn = Future<void> Function(Duration duration);

Future<void> _defaultDelay(Duration duration) => Future.delayed(duration);

class AddItemController extends Cubit<AddItemState> {
  final CreateItemUseCase _createItemUseCase;
  final LoadItemGroupsUseCase _loadItemGroupsUseCase;
  final Duration _minSubmitDuration;
  final AddItemDelayFn _delay;

  AddItemController({
    required CreateItemUseCase createItemUseCase,
    required LoadItemGroupsUseCase loadItemGroupsUseCase,
    Duration minSubmitDuration = const Duration(milliseconds: 600),
    AddItemDelayFn delay = _defaultDelay,
  })  : _createItemUseCase = createItemUseCase,
        _loadItemGroupsUseCase = loadItemGroupsUseCase,
        _minSubmitDuration = minSubmitDuration,
        _delay = delay,
        super(const AddItemState());

  void onFormChanged({
    required String group,
    required String service,
    required String login,
    required String password,
  }) {
    final valid = group.isNotNullOrBlank &&
        service.isNotNullOrBlank &&
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

    final stopwatch = _minSubmitDuration > Duration.zero ? (Stopwatch()..start()) : null;

    try {
      await _createItemUseCase(
        item,
        state.listItensDrop,
      );

      if (stopwatch != null) {
        final remaining = _minSubmitDuration - stopwatch.elapsed;
        if (remaining > Duration.zero) {
          await _delay(remaining);
        }
      }

      emit(state.copyWith(status: const AddItemSuccess()));
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
