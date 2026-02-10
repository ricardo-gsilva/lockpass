import 'package:lockpass/core/paths/lockpass_paths.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;
  static Database? _database;

  String typeTable = 'typeTable';
  String colTypeId = 'typeId';
  String colTypeType = 'typeType';

  String itensTable = 'itensTable';
  String colUserId = 'userId';
  String colId = 'id';
  String colType = 'type';
  String colService = 'service';
  String colSite = 'site';
  String colEmail = 'email';
  String colLogin = 'login';
  String colPassword = 'password';

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
      version: 2,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
        CREATE TABLE $typeTable(
          $colTypeId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colTypeType TEXT
        )  
      ''');

    await db.execute('''
        CREATE TABLE $itensTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colUserId TEXT,
          $colType TEXT,
          $colService TEXT,
          $colSite TEXT,
          $colEmail TEXT,
          $colLogin TEXT,
          $colPassword TEXT
        )  
      ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE $itensTable ADD COLUMN $colType TEXT");
    }
  }

  Future<int> addItem(ItensModel item) async {
    final db = await database;

    return db.insert(itensTable, item.toMap());
  }

  Future<int> addType(TypeModel type) async {
    Database db = await this.database;

    return await db.insert(typeTable, type.toMap());
  }

  Future<ItensModel> getItem(int id, String userId) async {
    Database db = await this.database;
    final maps = await db.query(
      itensTable,
      where: '$colId = ? AND $colUserId = ?',
      whereArgs: [id, userId],
    );

    if (maps.isNotEmpty) return ItensModel.fromMap(maps.first);
    return ItensModel.empty();
  }

  Future<List<ItensModel>> getItensByUser(String userId) async {
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

  Future<List<ItensModel>> getItens() async {
    Database db = await this.database;
    var table = await db.query(itensTable);

    return table.isNotEmpty
        ? table.map((i) => ItensModel.fromMap(i)).toList()
        : [];
  }

  Future<List<TypeModel>> getType() async {
    Database db = await this.database;
    var table = await db.query(typeTable);

    return table.isNotEmpty
        ? table.map((i) => TypeModel.fromMap(i)).toList()
        : [];
  }

  Future<int> updateItem(ItensModel itens) async {
    Database db = await this.database;
    return await db.update(itensTable, itens.toMap(),
        where: '$colId = ?', whereArgs: [itens.id]);
  }

  Future<int> deleteItem(ItensModel itens) async {
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
