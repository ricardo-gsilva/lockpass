import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class MoveItemToTrashUseCase {
  final ItensRepository _repository;

  MoveItemToTrashUseCase(this._repository);

  Future<void> call(ItensEntity item) async {
    await _repository.softDeleteItem(item);
  }
}