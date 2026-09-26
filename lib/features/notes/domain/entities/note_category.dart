import 'package:flutter/material.dart';

/// Enum representing the primary categories a Note can belong to.
///
/// Each category contains UX metadata such as title, icon, and curated
/// colors for both light and dark themes to maintain visual hierarchy.
enum NoteCategory {
  all,
  work,
  personal,
  task,
  ideas;

  /// String value saved in SQLite database.
  String get value => switch (this) {
        NoteCategory.work => 'work',
        NoteCategory.personal => 'personal',
        NoteCategory.task => 'task',
        NoteCategory.ideas => 'ideas',
        NoteCategory.all => 'all',
      };

  /// User-facing formatted title.
  String get displayName => switch (this) {
        NoteCategory.work => 'Work',
        NoteCategory.personal => 'Personal',
        NoteCategory.task => 'Task',
        NoteCategory.ideas => 'Ideas',
        NoteCategory.all => 'All Notes',
      };

  /// Distinct icon reflecting category purpose.
  IconData get icon => switch (this) {
        NoteCategory.work => Icons.work_rounded,
        NoteCategory.personal => Icons.person_rounded,
        NoteCategory.task => Icons.check_circle_outline_rounded,
        NoteCategory.ideas => Icons.lightbulb_outline_rounded,
        NoteCategory.all => Icons.dashboard_outlined,
      };

  /// Vibrant primary accent color.
  Color get primaryColor => switch (this) {
        NoteCategory.work => const Color(0xFF3B82F6),
        NoteCategory.personal => const Color(0xFFEC4899),
        NoteCategory.task => const Color(0xFFF59E0B),
        NoteCategory.ideas => const Color(0xFF10B981),
        NoteCategory.all => const Color(0xFF6366F1),
      };

  /// Light tint for card background / chips in Light Mode.
  Color get lightBackgroundColor => switch (this) {
        NoteCategory.work => const Color(0xFFEFF6FF),
        NoteCategory.personal => const Color(0xFFFDF2F8),
        NoteCategory.task => const Color(0xFFFFFBEB),
        NoteCategory.ideas => const Color(0xFFECFDF5),
        NoteCategory.all => const Color(0xFFEEF2FF),
      };

  /// Dark tint for card background / chips in Dark Mode.
  Color get darkBackgroundColor => switch (this) {
        NoteCategory.work => const Color(0xFF1E293B),
        NoteCategory.personal => const Color(0xFF3B1E2B),
        NoteCategory.task => const Color(0xFF3B2E1E),
        NoteCategory.ideas => const Color(0xFF1E3B2E),
        NoteCategory.all => const Color(0xFF1E203B),
      };

  /// Safe parser from string to [NoteCategory].
  static NoteCategory fromString(String? raw) {
    if (raw == null) return NoteCategory.personal;
    final normalized = raw.trim().toLowerCase();
    for (final cat in NoteCategory.values) {
      if (cat.value == normalized || cat.name.toLowerCase() == normalized) {
        return cat;
      }
    }
    return NoteCategory.personal;
  }
}
