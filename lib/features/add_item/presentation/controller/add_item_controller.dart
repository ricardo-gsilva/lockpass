import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_state.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/core/services/auth_service.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_status.dart';

class AddItemController extends Cubit<AddItemState> {
  final AuthService _authService;
  final ItensRepository _itensRepository;

  AddItemController({
    required AuthService authService,
    required ItensRepository itensRepository,
  })  : _authService = authService,
        _itensRepository = itensRepository,
        super(const AddItemState());

  String get currentUserId => _authService.currentUserId;

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

    if (state.isFormValid != valid) {
      emit(state.copyWith(isFormValid: valid));
    }
  }

  Future<void> formValidator(ItensEntity item) async {
    if (item.password.isNullOrBlank ||
        item.login.isNullOrBlank ||
        item.service.isNullOrBlank) {
      emit(state.copyWith(status: AddItemFailure(CoreStrings.manyEmptyFields)));
      return;
    }

    final uid = _authService.currentUserId;
    if (uid.isNullOrBlank) {
      emit(state.copyWith(status: AddItemFailure("Usuário não autenticado.")));
      return;
    }

    final group = (item.group.isNullOrBlank)
        ? (state.listItensDrop.isNotEmpty
            ? state.listItensDrop.first
            : CoreStrings.noDefinedGroup)
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
    emit(state.copyWith(status: const AddItemLoading()));

    const minDuration = Duration(milliseconds: 600);
    final stopwatch = Stopwatch()..start();

    try {
      await _itensRepository.addItem(item);

      final remaining = minDuration - stopwatch.elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }

      emit(state.copyWith(status: AddItemSuccess()));
    } catch (_) {
      emit(state.copyWith(
        status: AddItemFailure("Erro ao salvar item!"),
      ));
    }
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
    if (!listEquals(state.listItensDrop, groups)) {
      emit(state.copyWith(listItensDrop: groups));
    }
  }
}
