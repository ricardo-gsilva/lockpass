import 'package:lockpass/domain/entities/itens_entity.dart';

abstract class ItensRepository {
  Future<int> addItem(ItensEntity item);
  Future<int> updateItem(ItensEntity item);
  Future<int> deleteItem(ItensEntity item);
  Future<List<ItensEntity>> getItensByUser(String userId);
}
