import '../entities/note.dart';

abstract class NoteRepository {
  Future<void> saveNote(Note note);
  Future<Note?> getNote(String id);
  Future<List<Note>> getAllNotes();
  Future<void> deleteNote(String id);
  Future<void> updateNote(Note note);
}
