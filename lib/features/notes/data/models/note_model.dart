import '../../domain/entities/note_category.dart';
import '../../domain/entities/note_entity.dart';

/// Data model representing a Note row in the SQLite database.
class NoteModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final int colorValue;
  final int isPinned;
  final String? imagePath;
  final String createdAt;
  final String updatedAt;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.colorValue,
    required this.isPinned,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Converts SQLite Map row to [NoteModel].
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      colorValue: map['color_value'] as int,
      isPinned: (map['is_pinned'] as int?) ?? 0,
      imagePath: map['image_path'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  /// Converts [NoteModel] to SQLite Map representation.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'color_value': colorValue,
      'is_pinned': isPinned,
      'image_path': imagePath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Factory creating [NoteModel] from pure domain [NoteEntity].
  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      category: entity.category.value,
      colorValue: entity.colorValue,
      isPinned: entity.isPinned ? 1 : 0,
      imagePath: entity.imagePath,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }

  /// Converts [NoteModel] to pure domain [NoteEntity].
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      content: content,
      category: NoteCategory.fromString(category),
      colorValue: colorValue,
      isPinned: isPinned == 1,
      imagePath: imagePath,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
}
