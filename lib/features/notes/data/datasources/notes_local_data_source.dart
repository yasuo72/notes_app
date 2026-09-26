import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/note_model.dart';

/// Contract for local SQLite storage data source.
abstract class NotesLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel?> getNoteById(String id);
  Future<void> insertNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
  Future<List<NoteModel>> searchNotes(String query, {String? category});
  Future<void> togglePin(String id, int isPinned);
}

/// Concrete SQLite implementation using [DatabaseHelper].
class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  final DatabaseHelper _dbHelper;

  NotesLocalDataSourceImpl({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final db = await _dbHelper.database;
      final rows = await db.query(
        DatabaseHelper.tableNotes,
        orderBy: '${DatabaseHelper.columnIsPinned} DESC, ${DatabaseHelper.columnUpdatedAt} DESC',
      );
      return rows.map((row) => NoteModel.fromMap(row)).toList();
    } catch (e, stack) {
      throw AppDatabaseException('Failed to fetch notes from SQLite: $e', originalError: stack);
    }
  }

  @override
  Future<NoteModel?> getNoteById(String id) async {
    try {
      final db = await _dbHelper.database;
      final rows = await db.query(
        DatabaseHelper.tableNotes,
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return NoteModel.fromMap(rows.first);
    } catch (e, stack) {
      throw AppDatabaseException('Failed to fetch note with id $id: $e', originalError: stack);
    }
  }

  @override
  Future<void> insertNote(NoteModel note) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        DatabaseHelper.tableNotes,
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e, stack) {
      throw AppDatabaseException('Failed to insert note into SQLite: $e', originalError: stack);
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    try {
      final db = await _dbHelper.database;
      final count = await db.update(
        DatabaseHelper.tableNotes,
        note.toMap(),
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [note.id],
      );
      if (count == 0) {
        throw NotFoundException('Note with id ${note.id} does not exist to update');
      }
    } catch (e, stack) {
      if (e is AppException) rethrow;
      throw AppDatabaseException('Failed to update note: $e', originalError: stack);
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        DatabaseHelper.tableNotes,
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [id],
      );
    } catch (e, stack) {
      throw AppDatabaseException('Failed to delete note with id $id: $e', originalError: stack);
    }
  }

  @override
  Future<List<NoteModel>> searchNotes(String query, {String? category}) async {
    try {
      final db = await _dbHelper.database;
      final searchPattern = '%$query%';

      String whereClause;
      List<dynamic> whereArgs;

      final hasCategory = category != null && category.isNotEmpty && category != 'all';

      if (hasCategory && query.isNotEmpty) {
        whereClause =
            '${DatabaseHelper.columnCategory} = ? AND (${DatabaseHelper.columnTitle} LIKE ? OR ${DatabaseHelper.columnContent} LIKE ?)';
        whereArgs = [category, searchPattern, searchPattern];
      } else if (hasCategory) {
        whereClause = '${DatabaseHelper.columnCategory} = ?';
        whereArgs = [category];
      } else if (query.isNotEmpty) {
        whereClause =
            '${DatabaseHelper.columnTitle} LIKE ? OR ${DatabaseHelper.columnContent} LIKE ?';
        whereArgs = [searchPattern, searchPattern];
      } else {
        return getNotes();
      }

      final rows = await db.query(
        DatabaseHelper.tableNotes,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: '${DatabaseHelper.columnIsPinned} DESC, ${DatabaseHelper.columnUpdatedAt} DESC',
      );

      return rows.map((row) => NoteModel.fromMap(row)).toList();
    } catch (e, stack) {
      throw AppDatabaseException('Failed to search notes in SQLite: $e', originalError: stack);
    }
  }

  @override
  Future<void> togglePin(String id, int isPinned) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        DatabaseHelper.tableNotes,
        {
          DatabaseHelper.columnIsPinned: isPinned,
          DatabaseHelper.columnUpdatedAt: DateTime.now().toIso8601String(),
        },
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [id],
      );
    } catch (e, stack) {
      throw AppDatabaseException('Failed to toggle pin for note $id: $e', originalError: stack);
    }
  }
}
