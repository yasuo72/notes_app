import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/share_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/note_color_palette.dart';
import '../../../../core/theme/note_typography_helper.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/text_stats_helper.dart';
import '../../domain/entities/note_entity.dart';
import '../controllers/notes_controller.dart';
import '../widgets/delete_confirm_bottom_sheet.dart';
import 'note_editor_view.dart';

/// Detailed reading view for an individual Note.
class NoteDetailView extends StatelessWidget {
  final NoteEntity note;

  const NoteDetailView({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notesController = Get.find<NotesController>();
    final bgColor = NoteColorPalette.getBackgroundColor(note.colorValue, isDark);
    final font = Get.isRegistered<StorageService>()
        ? NoteFontFamily.fromString(Get.find<StorageService>().noteFontFamily)
        : NoteFontFamily.inter;
    final fontSize = Get.isRegistered<StorageService>()
        ? Get.find<StorageService>().noteFontSize
        : 16.0;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Pin / Unpin
          IconButton(
            icon: Icon(
              note.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
              color: note.isPinned ? note.category.primaryColor : null,
            ),
            tooltip: note.isPinned ? 'Unpin' : 'Pin',
            onPressed: () {
              notesController.togglePin(note);
              Get.back();
            },
          ),

          // Share Note to External Apps
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Note',
            onPressed: () => ShareService.shareNote(note),
          ),

          // Edit Note
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Note',
            onPressed: () async {
              final updated = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => NoteEditorView(existingNote: note),
                ),
              );
              if (updated == true && context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
          ),

          // Delete Note
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            tooltip: 'Delete Note',
            onPressed: () {
              DeleteConfirmBottomSheet.show(
                context: context,
                note: note,
                onConfirmDelete: () {
                  notesController.deleteNote(note);
                  Get.back(); // Pop detail view
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attached Hero Image Preview
            if (note.hasImage && File(note.imagePath!).existsSync()) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(note.imagePath!),
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Category & Stats Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: note.category.primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        note.category.icon,
                        size: 14,
                        color: note.category.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        note.category.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: note.category.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  TextStatsHelper.getReadingTime(note.content),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Note Title
            Text(
              note.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
            ),
            const SizedBox(height: 12),

            // Detailed Timestamp & Character Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      DateFormatter.formatDetailed(note.updatedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${note.characterCount} chars • ${note.wordCount} words',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Note Body Content with Active Typography
            SelectableText(
              note.content,
              style: font.getTextStyle(
                fontSize: fontSize,
                height: 1.65,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
