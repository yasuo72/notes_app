import 'note_category.dart';

/// Pure Domain Entity representing a single Note in the application.
///
/// Immutable domain model decoupling business logic from SQLite or network representations.
class NoteEntity {
  final String id;
  final String title;
  final String content;
  final NoteCategory category;
  final int colorValue;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.colorValue,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Total character count across title and content.
  int get characterCount => content.length;

  /// Word count computed safely.
  int get wordCount {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  /// Estimated reading time in minutes (based on 200 wpm).
  int get estimatedReadingMinutes {
    final words = wordCount;
    if (words == 0) return 0;
    final minutes = (words / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  /// Creates a copy of this note with modified fields.
  NoteEntity copyWith({
    String? id,
    String? title,
    String? content,
    NoteCategory? category,
    int? colorValue,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          category == other.category &&
          colorValue == other.colorValue &&
          isPinned == other.isPinned &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      category.hashCode ^
      colorValue.hashCode ^
      isPinned.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
