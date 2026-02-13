import 'package:lockpass/data/models/itens_model.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class ItensRepositoryImpl implements ItensRepository {
  final DataBaseHelper database;

  ItensRepositoryImpl(this.database);

  @override
  Future<int> addItem(ItensEntity item) async {
    final model = ItensModel.fromEntity(item);
    final db = await database.database;
    return db.insert(database.itensTable, model.toMap());
  }

  @override
  Future<int> updateItem(ItensEntity item) async {
    final model = ItensModel.fromEntity(item);
    final db = await database.database;

    return db.update(
      database.itensTable,
      model.toMap(),
      where: '${database.colId} = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<int> deleteItem(ItensEntity item) async {
    final db = await database.database;
    return db.delete(
      database.itensTable,
      where: '${database.colId} = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<List<ItensEntity>> getItensByUser(String userId) async {
    final db = await database.database;

    final result = await db.query(
      database.itensTable,
      where: '${database.colUserId} = ?',
      whereArgs: [userId],
    );

    return result
        .map((map) => ItensModel.fromMap(map).toEntity())
        .toList();
  }
}
