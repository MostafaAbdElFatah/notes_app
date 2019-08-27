import 'package:notes_app/Model/Note.dart';
import 'package:floor/floor.dart';

@dao
abstract class NoteDao {
  @Query('SELECT * FROM note WHERE id = :id')
  Future<Note> findNoteById(int id);

  @Query('SELECT * FROM note')
  Future<List<Note>> findAllNotes();

  @Query('SELECT * FROM note')
  Stream<List<Note>> findAllNotesAsStream();

  @insert
  Future<void> insertNote(Note note);

  @insert
  Future<void> insertNotes(List<Note> notes);

  @update
  Future<void> updateNote(Note note);

  @update
  Future<void> updateNotes(List<Note> note);

  @delete
  Future<void> deleteNote(Note note);

  @delete
  Future<void> deleteNotes(List<Note> notes);

  @Query('DELETE FROM note')
  Future<void> deleteAllNotes();
}