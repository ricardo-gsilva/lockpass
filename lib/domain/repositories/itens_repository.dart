import 'package:lockpass/domain/entities/itens_entity.dart';

abstract class ItensRepository {
  Future<int> addItem(ItensEntity item);
  Future<int> updateItem(ItensEntity item);
  Future<int> deleteItem(ItensEntity item);
  Future<List<ItensEntity>> getActiveItensByUser(String userId);
  Future<List<ItensEntity>> getDeletedItensByUser(String userId);
  Future<void> closeDatabase();
  Future<void> deleteLocalDatabase();
  Future<int> softDeleteItem(ItensEntity item);
  Future<int> restoreItem(ItensEntity item);
  Future<bool> hasDeletedItensByUser(String userId);
}
