// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FloorDB.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final database = _$FlutterDatabase();
    database.database = await database.open(name ?? ':memory:', _migrations);
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NoteDao _noteDaoInstance;

  Future<sqflite.Database> open(String name, List<Migration> migrations) async {
    final path = join(await sqflite.getDatabasesPath(), name);

    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);
      },
      onCreate: (database, _) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Note` (`id` INTEGER, `note` TEXT, `date` TEXT, PRIMARY KEY (`id`))');
      },
    );
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }
}

class _$NoteDao extends NoteDao {
  _$NoteDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _noteInsertionAdapter = InsertionAdapter(
            database,
            'Note',
            (Note item) => <String, dynamic>{
                  'id': item.id,
                  'note': item.note,
                  'date': item.date
                },
            changeListener),
        _noteUpdateAdapter = UpdateAdapter(
            database,
            'Note',
            'id',
            (Note item) => <String, dynamic>{
                  'id': item.id,
                  'note': item.note,
                  'date': item.date
                },
            changeListener),
        _noteDeletionAdapter = DeletionAdapter(
            database,
            'Note',
            'id',
            (Note item) => <String, dynamic>{
                  'id': item.id,
                  'note': item.note,
                  'date': item.date
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final _noteMapper = (Map<String, dynamic> row) =>
      Note.withID(row['id'] , row['note'], row['date']);

  final InsertionAdapter<Note> _noteInsertionAdapter;

  final UpdateAdapter<Note> _noteUpdateAdapter;

  final DeletionAdapter<Note> _noteDeletionAdapter;

  @override
  Future<Note> findNoteById(int id) async {
    return _queryAdapter.query('SELECT * FROM note WHERE id = ?',
        arguments: <dynamic>[id], mapper: _noteMapper);
  }

  @override
  Future<List<Note>> findAllNotes() async {
    return _queryAdapter.queryList('SELECT * FROM note', mapper: _noteMapper);
  }

  @override
  Stream<List<Note>> findAllNotesAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM note',
        tableName: 'Note', mapper: _noteMapper);
  }

  @override
  Future<void> deleteAllNotes() async {
    await _queryAdapter.queryNoReturn('DELETE FROM note');
  }

  @override
  Future<void> insertNote(Note note) async {
    await _noteInsertionAdapter.insert(note, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> insertNotes(List<Note> notes) async {
    await _noteInsertionAdapter.insertList(
        notes, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateNote(Note note) async {
    await _noteUpdateAdapter.update(note, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateNotes(List<Note> note) async {
    await _noteUpdateAdapter.updateList(note, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> deleteNote(Note note) async {
    await _noteDeletionAdapter.delete(note);
  }

  @override
  Future<void> deleteNotes(List<Note> notes) async {
    await _noteDeletionAdapter.deleteList(notes);
  }
}
