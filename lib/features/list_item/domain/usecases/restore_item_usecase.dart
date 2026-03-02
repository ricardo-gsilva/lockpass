import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class RestoreItemUseCase {
  final ItensRepository _repository;

  RestoreItemUseCase(this._repository);

  Future<void> call(ItensEntity item) async {
    await _repository.restoreItem(item);
  }
}