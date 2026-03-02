import 'package:lockpass/data/models/itens_model.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class ItensRepositoryImpl implements ItensRepository {
  final DataBaseHelper _dbHelper;

  ItensRepositoryImpl({
    required DataBaseHelper dbHelper,
  }) : _dbHelper = dbHelper;

  @override
  Future<int> addItem(ItensEntity item) async {
    final model = ItensModel.fromEntity(item);
    return _dbHelper.addItem(model);
  }

  @override
  Future<int> updateItem(ItensEntity item) async {
    final model = ItensModel.fromEntity(item);
    return _dbHelper.updateItem(model);
  }

  @override
  Future<int> deleteItem(ItensEntity item) async {
    final model = ItensModel.fromEntity(item);
    return _dbHelper.deleteItem(model);
  }

  @override
  Future<List<ItensEntity>> getActiveItensByUser(String userId) async {
    final models = await _dbHelper.getActiveItensByUser(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> closeDatabase() async {
    await _dbHelper.closeDatabase();
  }

  @override
  Future<void> deleteLocalDatabase() async {
    await _dbHelper.deleteLocalDatabase();
  }

  @override
  Future<int> restoreItem(ItensEntity item) {
    final model = ItensModel.fromEntity(item);
    return _dbHelper.restoreItem(model);
  }

  @override
  Future<int> softDeleteItem(ItensEntity item) {
    final model = ItensModel.fromEntity(item);
    return _dbHelper.softDeleteItem(model);
  }

  @override
  Future<List<ItensEntity>> getDeletedItensByUser(String userId) async {
    final models = await _dbHelper.getDeletedItensByUser(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<bool> hasDeletedItensByUser(String userId) {
    return _dbHelper.hasDeletedItensByUser(userId);
  }
}
