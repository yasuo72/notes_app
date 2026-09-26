import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../errors/app_exception.dart';

/// Singleton helper managing SQLite database initialization, migrations, and connections.
class DatabaseHelper {
  static const String _databaseName = 'notes_app.db';
  static const int _databaseVersion = 1;

  static const String tableNotes = 'notes';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnContent = 'content';
  static const String columnCategory = 'category';
  static const String columnColorValue = 'color_value';
  static const String columnIsPinned = 'is_pinned';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  /// Returns active SQLite database instance, initializing if not already opened.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, _databaseName);

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
      );
    } catch (e, stack) {
      throw AppDatabaseException(
        'Failed to initialize SQLite database: $e',
        originalError: stack,
      );
    }
  }

  Future<void> _onConfigure(Database db) async {
    // Enable WAL (Write-Ahead Logging) mode for faster concurrent reads & writes
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableNotes (
        $columnId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnContent TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnColorValue INTEGER NOT NULL,
        $columnIsPinned INTEGER NOT NULL DEFAULT 0,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL
      )
    ''');

    // Indices for ultra-fast sorting and searching
    await db.execute(
      'CREATE INDEX idx_notes_pinned ON $tableNotes ($columnIsPinned DESC, $columnUpdatedAt DESC)',
    );
    await db.execute(
      'CREATE INDEX idx_notes_category ON $tableNotes ($columnCategory)',
    );
  }

  /// Closes database connection when app terminates.
  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }
}
