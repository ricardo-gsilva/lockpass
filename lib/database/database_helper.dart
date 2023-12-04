import 'dart:io';

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
  String colTypeVisible = 'typeVisible';

  String itensTable = 'itensTable';  
  String colId = 'id';
  String colType = 'type';
  String colService = 'service';
  String colSite = 'site';
  String colEmail = 'email';
  String colLogin = 'login';
  String colPassword = 'password';
  
  DataBaseHelper._createInstance();

  factory DataBaseHelper(){
    return _dataBaseHelper ??= DataBaseHelper._createInstance();    
  }

  Future<Database> get database async {
    return _database ??= await initializeDatabase();
  }  

  Future<Database> initializeDatabase() async {    
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}_itens.db';

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
        CREATE TABLE $typeTable(
          $colTypeId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colTypeType TEXT,
          $colTypeVisible TEXT
        )  
      '''
    );

    await db.execute('''
        CREATE TABLE $itensTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colType TEXT,
          $colService TEXT,
          $colSite TEXT,
          $colEmail TEXT,
          $colLogin TEXT,
          $colPassword TEXT
        )  
      '''
    );
  }

  Future<int> addItem(ItensModel itens) async {
    Database db = await this.database;

    return await db.insert(itensTable, itens.toMap());
  }

  Future<int> addType(TypeModel type) async {
    Database db = await this.database;

    return await db.insert(typeTable, type.toMap());
  }

  Future<ItensModel> getItem(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.query(
      itensTable,
      columns: [colId, colType, colService, colSite, colEmail, colLogin, colPassword],
      where: '$colId = ?',
      whereArgs: [id]
    );

    if(maps.isNotEmpty){
      return ItensModel.fromMap(maps.first);
    } else {
      return ItensModel.empty();
    }
  }

  Future<List<ItensModel>> getItens() async {
    Database db = await this.database;
    var table = await db.query(itensTable);

    return table.isNotEmpty? table.map(
      (i) => ItensModel.fromMap(i)).toList() : [];
  }

  Future<List<TypeModel>> getType() async {
    Database db = await this.database;
    var table = await db.query(typeTable);

    return table.isNotEmpty? table.map(
      (i) => TypeModel.fromMap(i)).toList() : [];
  }

  Future<int> updateItem(ItensModel itens) async{
    Database db = await this.database;
    return await db.update(
      itensTable, itens.toMap(),
      where: '$colId = ?',
      whereArgs: [itens.id]
    );
  }

  Future<int> deleteItem(ItensModel itens) async{
    Database db = await this.database;
    return await db.delete(
      itensTable,
      where: '$colId = ?',
      whereArgs:  [itens.id]
    );
  }

  Future<int> countItens() async{
    Database db = await this.database;
    List<Map<String, dynamic>> count = await db.rawQuery('SELECT COUNT (*) from $itensTable');

    return Sqflite.firstIntValue(count)!;    
  }

  Future closeDataBase() async{
    Database db = await this.database;
    return db.close();
  }
}