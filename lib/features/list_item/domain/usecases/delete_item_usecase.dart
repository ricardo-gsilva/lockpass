import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class DeleteItemUseCase {
  final ItensRepository _repository;

  DeleteItemUseCase(this._repository);

  Future<void> call(ItensEntity item) async {
    await _repository.deleteItem(item);
  }
}