import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class CheckHasDeletedItemsUseCase {
  final AuthService _authService;
  final ItensRepository _repository;

  CheckHasDeletedItemsUseCase(
    this._authService,
    this._repository,
  );

  Future<bool> call() async {
    final uid = _authService.currentUserId;

    if (uid.isEmpty) {
      return false;
    }

    return _repository.hasDeletedItensByUser(uid);
  }
}