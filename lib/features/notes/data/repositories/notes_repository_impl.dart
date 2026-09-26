import '../../domain/entities/note_category.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_data_source.dart';
import '../models/note_model.dart';

/// Concrete implementation of [NotesRepository] coordinating local data persistence.
class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource _localDataSource;

  NotesRepositoryImpl({NotesLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? NotesLocalDataSourceImpl();

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    final models = await _localDataSource.getNotes();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<NoteEntity?> getNoteById(String id) async {
    final model = await _localDataSource.getNoteById(id);
    return model?.toEntity();
  }

  @override
  Future<void> createNote(NoteEntity note) async {
    final model = NoteModel.fromEntity(note);
    await _localDataSource.insertNote(model);
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    final model = NoteModel.fromEntity(note);
    await _localDataSource.updateNote(model);
  }

  @override
  Future<void> deleteNote(String id) async {
    await _localDataSource.deleteNote(id);
  }

  @override
  Future<void> restoreNote(NoteEntity note) async {
    final model = NoteModel.fromEntity(note);
    await _localDataSource.insertNote(model);
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query, {NoteCategory? category}) async {
    final categoryValue = (category == null || category == NoteCategory.all)
        ? null
        : category.value;
    final models = await _localDataSource.searchNotes(query, category: categoryValue);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> togglePin(String id, bool isPinned) async {
    await _localDataSource.togglePin(id, isPinned ? 1 : 0);
  }
}
