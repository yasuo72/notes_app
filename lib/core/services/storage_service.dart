import 'package:shared_preferences/shared_preferences.dart';

/// Service managing persistent local key-value preferences (Theme, View Mode).
class StorageService {
  static const String _keyDarkMode = 'is_dark_mode';
  static const String _keyGridView = 'is_grid_view';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Initializes SharedPreferences singleton.
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Returns whether dark mode is currently saved. Defaults to false.
  bool get isDarkMode => _prefs.getBool(_keyDarkMode) ?? false;

  /// Persists dark mode selection.
  Future<bool> setDarkMode(bool value) async {
    return await _prefs.setBool(_keyDarkMode, value);
  }

  /// Returns whether grid view layout is preferred over list. Defaults to true.
  bool get isGridView => _prefs.getBool(_keyGridView) ?? true;

  /// Persists grid view layout preference.
  Future<bool> setGridView(bool value) async {
    return await _prefs.setBool(_keyGridView, value);
  }

  static const String _keySampleSeeded = 'has_seeded_sample_notes';

  /// Whether initial sample data was already populated.
  bool get hasSeededSampleNotes => _prefs.getBool(_keySampleSeeded) ?? false;

  /// Marks sample data as seeded.
  Future<bool> setHasSeededSampleNotes(bool value) async {
    return await _prefs.setBool(_keySampleSeeded, value);
  }

  static const String _keyNoteFont = 'note_font_family';
  static const String _keyNoteFontSize = 'note_font_size';

  /// Preferred font family for notes. Defaults to 'Inter'.
  String get noteFontFamily => _prefs.getString(_keyNoteFont) ?? 'Inter';

  /// Persists preferred font family.
  Future<bool> setNoteFontFamily(String value) async {
    return await _prefs.setString(_keyNoteFont, value);
  }

  /// Preferred font size for note writing. Defaults to 16.0.
  double get noteFontSize => _prefs.getDouble(_keyNoteFontSize) ?? 16.0;

  /// Persists preferred font size.
  Future<bool> setNoteFontSize(double value) async {
    return await _prefs.setDouble(_keyNoteFontSize, value);
  }
}
