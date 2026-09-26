import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/core/utils/text_stats_helper.dart';
import 'package:note_app/core/utils/date_formatter.dart';
import 'package:note_app/features/notes/domain/entities/note_category.dart';
import 'package:note_app/features/notes/domain/entities/note_entity.dart';

void main() {
  group('TextStatsHelper & Entity Unit Tests', () {
    test('Calculates character and word count correctly', () {
      const text = 'Flutter is an awesome cross-platform framework!';
      expect(TextStatsHelper.getCharacterCount(text), 47);
      expect(TextStatsHelper.getWordCount(text), 6);
      expect(TextStatsHelper.getReadingTime(text), '1 min read');
    });

    test('NoteEntity computes reading time and stats accurately', () {
      final note = NoteEntity(
        id: '123',
        title: 'Project Roadmap',
        content: 'Antigravity builds top notch production apps.',
        category: NoteCategory.work,
        colorValue: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.characterCount, 45);
      expect(note.wordCount, 6);
      expect(note.category, NoteCategory.work);
      expect(note.isPinned, false);
    });

    test('NoteCategory parser handles string safely', () {
      expect(NoteCategory.fromString('work'), NoteCategory.work);
      expect(NoteCategory.fromString('PERSONAL'), NoteCategory.personal);
      expect(NoteCategory.fromString('task'), NoteCategory.task);
      expect(NoteCategory.fromString('ideas'), NoteCategory.ideas);
      expect(NoteCategory.fromString('unknown_val'), NoteCategory.personal);
    });

    test('DateFormatter returns human friendly relative strings', () {
      final now = DateTime.now();
      expect(DateFormatter.formatRelative(now), 'Just now');

      final fiveMinsAgo = now.subtract(const Duration(minutes: 5));
      expect(DateFormatter.formatRelative(fiveMinsAgo), '5 mins ago');
    });

    test('NoteEntity hasImage check works accurately', () {
      final noteWithoutImage = NoteEntity(
        id: '1',
        title: 'Title',
        content: 'Content',
        category: NoteCategory.work,
        colorValue: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(noteWithoutImage.hasImage, false);

      final noteWithImage = noteWithoutImage.copyWith(imagePath: '/path/to/img.png');
      expect(noteWithImage.hasImage, true);
    });
  });
}
