import 'package:lockpass/data/models/itens_model.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class ItensRepositoryImpl implements ItensRepository {
  final DataBaseHelper database;

  ItensRepositoryImpl(this.database);

  @override
  Future<int> addItem(ItensEntity item) async {
    final model = ItensModel.fromEntity(item);
    return database.addItem(model);
  }

  @override
  Future<int> updateItem(ItensEntity item) async {
    final model = ItensModel.fromEntity(item);
    return database.updateItem(model);
  }

  @override
  Future<int> deleteItem(ItensEntity item) async {
    final model = ItensModel.fromEntity(item);
    return database.deleteItem(model);
  }

  @override
  Future<List<ItensEntity>> getActiveItensByUser(String userId) async {
    final models = await database.getActiveItensByUser(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> closeDatabase() async {
    await database.closeDatabase();
  }

  @override
  Future<void> deleteLocalDatabase() async {
    await database.deleteLocalDatabase();
  }

  @override
  Future<int> restoreItem(ItensEntity item) {
    final model = ItensModel.fromEntity(item);
    return database.restoreItem(model);
  }

  @override
  Future<int> softDeleteItem(ItensEntity item) {
    final model = ItensModel.fromEntity(item);
    return database.softDeleteItem(model);
  }

  @override
  Future<List<ItensEntity>> getDeletedItensByUser(String userId) async {
    final models = await database.getDeletedItensByUser(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<bool> hasDeletedItensByUser(String userId) {
    return database.hasDeletedItensByUser(userId);
  }
}
