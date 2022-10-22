import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    print('created');
    await db.execute(
        'CREATE TABLE notes (id INTEGER PRIMARY KEY, note TEXT,date TEXT,time TEXT,title TEXT)');
  }

  Future<List> getNotes({String? myWhere}) async {
    var dbClient = await db;
    List<Map> response = await dbClient.query('notes', where: myWhere);

    return response;
  }

  insert({Map<String, Object?>? values}) async {
    var dbClient = await db;
    int response = await dbClient.insert('notes', values!);
    return response;
  }

  Future<int> delete(String myWhere) async {
    var dbClient = await db;
    return await dbClient.delete('notes', where: myWhere);
  }

  Future<int> update(Map<String, Object> values, String myWhere) async {
    var dbClient = await db;
    int response = await dbClient.update('notes', values, where: myWhere);
    return response;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
