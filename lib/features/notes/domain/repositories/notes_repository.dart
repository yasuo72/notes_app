import '../entities/note_category.dart';
import '../entities/note_entity.dart';

/// Abstract Domain Repository specifying CRUD and query contracts.
///
/// Concrete implementation in the Data layer will handle SQLite persistence.
abstract class NotesRepository {
  /// Fetches all notes sorted by isPinned (DESC) and updatedAt (DESC).
  Future<List<NoteEntity>> getAllNotes();

  /// Fetches a single note by its unique identifier.
  Future<NoteEntity?> getNoteById(String id);

  /// Inserts a new note into local storage.
  Future<void> createNote(NoteEntity note);

  /// Updates an existing note.
  Future<void> updateNote(NoteEntity note);

  /// Deletes a note by id.
  Future<void> deleteNote(String id);

  /// Restores a previously deleted note (used for 4-second Undo SnackBar).
  Future<void> restoreNote(NoteEntity note);

  /// Searches notes matching query across title/content with optional category filter.
  Future<List<NoteEntity>> searchNotes(String query, {NoteCategory? category});

  /// Toggles the pinned status of a note.
  Future<void> togglePin(String id, bool isPinned);
}
