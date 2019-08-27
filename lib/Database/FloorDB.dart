import 'dart:async';
import 'package:notes_app/Model/Note.dart';
import 'NoteDao.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'FloorDB.g.dart';

@Database(version: 1, entities: [Note])
abstract class FlutterDatabase extends FloorDatabase {
  NoteDao get noteDao;
}


class DatabaseManager{

  static NoteDao _dao;
  static DatabaseManager _manager;

  DatabaseManager._createInstance();

  factory DatabaseManager() {
    if (_manager == null) {
      _manager = DatabaseManager._createInstance();
    }
    return _manager;
  }

  Future<NoteDao> get dao async{
    if (_dao == null) {
      _dao = await _getShared();
    }
    return _dao;
  }
  Future<NoteDao> _getShared() async{
    final database = await $FloorFlutterDatabase
        .databaseBuilder('notes_database.db')
        .build();
    final dao = database.noteDao;
    return dao;
  }

  Future<void> insertNote(Note note) async {
    NoteDao dao = await this.dao;
    return await dao.insertNote(note);
  }

  Future<void>  insertNotes(List<Note> notes) async {
    NoteDao dao = await this.dao;
    return await dao.insertNotes(notes);
  }

  Future<Note> getNote(int id) async {
    NoteDao dao = await this.dao;
    return await dao.findNoteById(id);
  }

  Future<List<Note>> getNotes() async {
    NoteDao dao = await this.dao;
    return await dao.findAllNotes();
  }

  Future<bool> isHasRows() async {
    NoteDao dao = await this.dao;
    var rows =  await dao.findAllNotes();
    if ( rows == null)
      return false;
    else if (rows.length <= 0)
      return false;
    else
      return true;
  }


  Future<void>  updateNote(Note note) async{
    NoteDao dao = await this.dao;
    return await dao.updateNote(note);
  }

  Future<void>  deleteNote(Note note) async{
    NoteDao dao = await this.dao;
    return await dao.deleteNote(note);
  }

  Future<void>  deleteAllNotes() async {
    NoteDao dao = await this.dao;
    return await dao.deleteAllNotes();
  }



}