import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/notes/domain/entities/note_entity.dart';
import '../utils/date_formatter.dart';

/// Service managing sharing of notes (text & attached images) to external applications.
class ShareService {
  ShareService._();

  /// Shares note text and attached image file via system share sheet to WhatsApp, Gmail, etc.
  static Future<void> shareNote(NoteEntity note) async {
    try {
      final title = note.title.isNotEmpty ? note.title : 'Untitled Note';
      final category = note.category.displayName;
      final date = DateFormatter.formatDetailed(note.updatedAt);

      final buffer = StringBuffer();
      buffer.writeln('📌 $title');
      buffer.writeln('📂 Category: $category');
      buffer.writeln('🕒 $date');
      buffer.writeln('────────────────────');
      buffer.writeln(note.content);
      buffer.writeln('────────────────────');
      buffer.writeln('✨ Shared via Notes App');

      final text = buffer.toString();

      if (note.imagePath != null && File(note.imagePath!).existsSync()) {
        await Share.shareXFiles(
          [XFile(note.imagePath!)],
          text: text,
          subject: title,
        );
      } else {
        await Share.share(
          text,
          subject: title,
        );
      }
    } catch (e) {
      debugPrint('Share exception: $e');
      Get.snackbar(
        'Share',
        'Could not open share menu. If newly installed, please rebuild the app.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
