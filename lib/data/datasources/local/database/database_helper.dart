import 'package:lockpass/core/paths/lockpass_paths.dart';
import 'package:lockpass/data/models/itens_model.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;
  static Database? _database;

  //Itens
  String itensTable = 'itensTable';
  String colUserId = 'userId';
  String colId = 'id';
  String colGroup = 'itemGroup';
  String colService = 'service';
  String colSite = 'site';
  String colEmail = 'email';
  String colLogin = 'login';
  String colPassword = 'password';

  //Legado
  String colType = 'type';
  String typeTable = 'typeTable';
  String colTypeId = 'typeId';
  String colTypeType = 'typeType';

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
          $colUserId TEXT,
          $colGroup TEXT,
          $colService TEXT,
          $colSite TEXT,
          $colEmail TEXT,
          $colLogin TEXT,
          $colPassword TEXT
        )  
      ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int> addItem(ItensModel item) async {
    final db = await database;

    return db.insert(itensTable, item.toMap());
  }

  // Future<int> addGroup(GroupsEntity group) async {
  //   Database db = await this.database;

  //   return await db.insert(groupTable, group.toMap());
  // }

  Future<ItensEntity> getItem(int id, String userId) async {
    Database db = await this.database;
    final maps = await db.query(
      itensTable,
      where: '$colId = ? AND $colUserId = ?',
      whereArgs: [id, userId],
    );

    if (maps.isNotEmpty) return ItensModel.fromMap(maps.first);
    return ItensEntity.empty();
  }

  Future<List<ItensEntity>> getItensByUser(String userId) async {
    Database db = await database;

    final table = await db.query(
      itensTable,
      where: '$colUserId = ?',
      whereArgs: [userId],
    );

    return table.isNotEmpty
        ? table.map((i) => ItensModel.fromMap(i)).toList()
        : [];
  }

  Future<List<ItensEntity>> getItens() async {
    Database db = await this.database;
    var table = await db.query(itensTable);

    return table.isNotEmpty
        ? table.map((i) => ItensModel.fromMap(i)).toList()
        : [];
  }

  // Future<List<GroupsEntity>> getGroup() async {
  //   Database db = await this.database;
  //   var table = await db.query(groupTable);

  //   return table.isNotEmpty
  //       ? table.map((i) => GroupsEntity.fromMap(i)).toList()
  //       : [];
  // }

  Future<int> updateItem(ItensModel itens) async {
    Database db = await this.database;
    return await db.update(itensTable, itens.toMap(),
        where: '$colId = ?', whereArgs: [itens.id]);
  }

  Future<int> deleteItem(ItensEntity itens) async {
    Database db = await this.database;
    return await db
        .delete(itensTable, where: '$colId = ?', whereArgs: [itens.id]);
  }

  Future<int> countItens() async {
    Database db = await this.database;
    List<Map<String, dynamic>> count =
        await db.rawQuery('SELECT COUNT (*) from $itensTable');

    return Sqflite.firstIntValue(count)!;
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
}
