import 'dart:io';

import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/paths/lockpass_paths.dart';
import 'package:lockpass/data/models/itens_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;
  static Database? _database;

  String itensTable = 'itensTable';
  String colUserId = 'userId';
  String colId = 'id';
  String colGroup = 'itemGroup';
  String colService = 'service';
  String colSite = 'site';
  String colEmail = 'email';
  String colLogin = 'login';
  String colPassword = 'password';
  String colType = 'type';
  String typeTable = 'typeTable';
  String colTypeId = 'typeId';
  String colTypeType = 'typeType';
  String colIsDeleted = 'is_deleted';
  String colDeletedAt = 'deleted_at';

  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    return _dataBaseHelper ??= DataBaseHelper._createInstance();
  }

  Future<Database> get database async {
    return _database ??= await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    final dbDir = await LockPassPaths.dbDir;
    final dbPath = '${dbDir.path}/lockpass_itens.db';

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE $itensTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colUserId TEXT NOT NULL,
        $colGroup TEXT NOT NULL,
        $colService TEXT NOT NULL,
        $colSite TEXT,
        $colEmail TEXT NOT NULL,
        $colLogin TEXT NOT NULL,
        $colPassword TEXT NOT NULL,
        $colIsDeleted INTEGER NOT NULL DEFAULT 0,
        $colDeletedAt TEXT
      )
    ''');

    await db.execute('CREATE INDEX idx_${itensTable}_is_deleted ON $itensTable($colIsDeleted)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int> addItem(ItensModel item) async {
    final model = ItensModel.fromEntity(item);
    final db = await database;

    return db.insert(
      itensTable,
      model.toMap(),
    );
  }

  Future<List<ItensModel>> getActiveItensByUser(String userId) async {
    final db = await database;

    final result = await db.query(
      itensTable,
      where: '$colUserId = ? AND $colIsDeleted = 0',
      whereArgs: [userId],
    );

    return result.map((map) => ItensModel.fromMap(map)).toList();
  }

  Future<List<ItensModel>> getDeletedItensByUser(String userId) async {
    final db = await database;

    final result = await db.query(
      itensTable,
      where: '$colUserId = ? AND $colIsDeleted = 1',
      whereArgs: [userId],
    );

    return result.map((map) => ItensModel.fromMap(map)).toList();
  }

  Future<int> updateItem(ItensModel item) async {
    Database db = await database;
    if (item.id == null) {
      throw Exception(CoreStrings.itemUpdateIdError);
    }
    return await db.update(
      itensTable,
      item.toMap(),
      where: '$colId = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(ItensModel item) async {
    Database db = await database;
    return await db.delete(
      itensTable,
      where: '$colId = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> deleteLocalDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/lockpass_itens.db';

    await deleteDatabase(path);
  }

  Future<int> softDeleteItem(ItensModel item) async {
    final db = await database;

    return await db.update(
      itensTable,
      {
        colIsDeleted: 1,
        colDeletedAt: DateTime.now().toIso8601String(),
      },
      where: '$colId = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> restoreItem(ItensModel item) async {
    final db = await database;

    return await db.update(
      itensTable,
      {
        colIsDeleted: 0,
        colDeletedAt: null,
      },
      where: '$colId = ?',
      whereArgs: [item.id],
    );
  }

  Future<bool> hasDeletedItensByUser(String userId) async {
    final db = await database;

    final result = await db.query(
      itensTable,
      columns: [colId],
      where: '$colUserId = ? AND $colIsDeleted = 1',
      whereArgs: [userId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<void> replaceDatabase(List<int> newDbBytes) async {
    final db = await database;
    final String path = db.path;

    // 1. Pega referências dos arquivos
    final dbFile = File(path);
    final walFile = File('$path-wal');
    final shmFile = File('$path-shm');

    // Arquivo temporário para o backup de emergência (Rollback)
    final backupFile = File('$path.rollback');

    // 2. Fecha a conexão
    await db.close();
    _database = null;

    // 3. Backup de segurança: Renomeia o banco atual em vez de deletar
    if (await dbFile.exists()) {
      await dbFile.rename(backupFile.path);
    }

    try {
      // 4. Limpa os logs (importante deletar antes de escrever o novo)
      if (await walFile.exists()) await walFile.delete();
      if (await shmFile.exists()) await shmFile.delete();

      // 5. Tenta escrever o novo banco
      await dbFile.writeAsBytes(newDbBytes);

      // 6. Se chegou aqui com sucesso, deleta o arquivo de rollback
      if (await backupFile.exists()) await backupFile.delete();
    } catch (e) {
      // 7. OCORREU ERRO: Rollback!
      if (await backupFile.exists()) {
        if (await dbFile.exists()) await dbFile.delete();
        await backupFile.rename(path);
      }
      throw Exception("${CoreStrings.criticalRestoreError} $e");
    }
  }
}
