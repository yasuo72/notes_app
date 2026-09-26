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
}
