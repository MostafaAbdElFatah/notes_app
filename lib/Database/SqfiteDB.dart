import 'package:sqflite/sqflite.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notes_app/Model/Note.dart';

class DatabaseHelper {
  final _idColumnName = "id";
  final _noteColumnName = "note";
  final _dateColumnName = "date";
  final _noteTableName = "NoteTable";

  Future<Database> _database;
  static DatabaseHelper _manager;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_manager == null) {
      _manager = DatabaseHelper._createInstance();
    }
    return _manager;
  }

  Future<Database> get database {
    if (_database == null) {
      _database = initDatabase();
    }
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "note_db.db";
    var db = openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  void _createDatabase(Database db, int version) async {
    await db.execute("CREATE TABLE $_noteTableName ("
        "$_idColumnName INTEGER PRIMARY KEY,"
        "$_noteColumnName TEXT,"
        "$_dateColumnName TEXT"
        ")");
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(_noteTableName, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(_noteTableName, note.toMap(),
        where: '$_idColumnName = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async {
    Database db = await this.database;
    var result = await db.delete(_noteTableName,
        where: '$_idColumnName = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteAllNotes() async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $_noteTableName');
    return result;
  }

  Future<bool> isHasRows() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT COUNT (*) $_noteTableName');
    int count = Sqflite.firstIntValue(result);
    if( count > 0)
       return true;
    else
     return false;
  }

  Future<List<Note>> getNotes() async {
    Database db = await this.database;
    var mapList = await db.query(_noteTableName);
    List<Note> result = List<Note>();
    for(var map in mapList){
      result.add(Note.fromMapObject(map));
    }
    return result;
  }

  Future<Note> getNote(int id) async {
    Database db = await this.database;
    List<Map> results = await db.query("$_noteTableName",
        where: '$_idColumnName = ?',
        whereArgs: [id]);
    if (results.length > 0) {
      return new Note.fromMap(results.first);
    }
    return null;
  }
}
