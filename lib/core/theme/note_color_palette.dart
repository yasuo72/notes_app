import 'package:flutter/material.dart';

/// Metadata for a single note color preset.
class NoteColorItem {
  final int id;
  final String name;
  final Color lightBackground;
  final Color darkBackground;
  final Color lightBorder;
  final Color darkBorder;
  final Color dotColor;

  const NoteColorItem({
    required this.id,
    required this.name,
    required this.lightBackground,
    required this.darkBackground,
    required this.lightBorder,
    required this.darkBorder,
    required this.dotColor,
  });
}

/// Central palette provider for note background tints and border highlights.
class NoteColorPalette {
  NoteColorPalette._();

  static const List<NoteColorItem> presets = [
    NoteColorItem(
      id: 0,
      name: 'Default',
      lightBackground: Color(0xFFFFFFFF),
      darkBackground: Color(0xFF131B2E),
      lightBorder: Color(0xFFE2E8F0),
      darkBorder: Color(0xFF1E293B),
      dotColor: Color(0xFF94A3B8),
    ),
    NoteColorItem(
      id: 1,
      name: 'Warm Amber',
      lightBackground: Color(0xFFFEF9C3), // Soft yellow sticky note
      darkBackground: Color(0xFF2E2412),
      lightBorder: Color(0xFFFDE047),
      darkBorder: Color(0xFF53421A),
      dotColor: Color(0xFFF59E0B),
    ),
    NoteColorItem(
      id: 2,
      name: 'Soft Rose',
      lightBackground: Color(0xFFFFE4E6), // Pastel rose
      darkBackground: Color(0xFF2E151E),
      lightBorder: Color(0xFFFDA4AF),
      darkBorder: Color(0xFF592334),
      dotColor: Color(0xFFF43F5E),
    ),
    NoteColorItem(
      id: 3,
      name: 'Mint Sage',
      lightBackground: Color(0xFFDCFCE7), // Pastel green
      darkBackground: Color(0xFF122E1E),
      lightBorder: Color(0xFF86EFAC),
      darkBorder: Color(0xFF1D5434),
      dotColor: Color(0xFF10B981),
    ),
    NoteColorItem(
      id: 4,
      name: 'Sky Cyan',
      lightBackground: Color(0xFFE0F2FE), // Pastel cyan
      darkBackground: Color(0xFF10263C),
      lightBorder: Color(0xFF7DD3FC),
      darkBorder: Color(0xFF1A466A),
      dotColor: Color(0xFF06B6D4),
    ),
    NoteColorItem(
      id: 5,
      name: 'Lavender',
      lightBackground: Color(0xFFF3E8FF), // Pastel lilac
      darkBackground: Color(0xFF241639),
      lightBorder: Color(0xFFD8B4FE),
      darkBorder: Color(0xFF452471),
      dotColor: Color(0xFF8B5CF6),
    ),
  ];

  /// Retrieves [NoteColorItem] safely by index with wrap-around fallback.
  static NoteColorItem getItem(int index) {
    if (index < 0 || index >= presets.length) {
      return presets[0];
    }
    return presets[index];
  }

  /// Returns contextual card background color based on brightness.
  static Color getBackgroundColor(int index, bool isDark) {
    final item = getItem(index);
    return isDark ? item.darkBackground : item.lightBackground;
  }

  /// Returns contextual border color based on brightness.
  static Color getBorderColor(int index, bool isDark) {
    final item = getItem(index);
    return isDark ? item.darkBorder : item.lightBorder;
  }
}
