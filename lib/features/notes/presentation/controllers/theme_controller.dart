import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';

/// GetX controller managing theme mode (Light vs Dark) and persistent state.
class ThemeController extends GetxController {
  final StorageService _storageService;

  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  ThemeController({StorageService? storageService})
      : _storageService = storageService ?? Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  void _loadThemePreference() {
    final isDark = _storageService.isDarkMode;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// Whether dark mode is currently active.
  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  /// Toggles between light and dark modes with instant GetX UI transition.
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = newMode;
    Get.changeThemeMode(newMode);
    await _storageService.setDarkMode(newMode == ThemeMode.dark);
  }
}
