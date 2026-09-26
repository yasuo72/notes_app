import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/services/share_service.dart';
import '../../../../core/theme/note_color_palette.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/animated_marquee_text.dart';
import '../../domain/entities/note_entity.dart';
import 'delete_confirm_bottom_sheet.dart';

/// Highly polished NoteCard supporting Staggered Masonry and List formats.
class NoteCard extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback onDelete;
  final bool isGridView;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onTogglePin,
    required this.onDelete,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = note.category;

    // Pick subtle background tint based on user's color selection
    final bgColor = NoteColorPalette.getBackgroundColor(note.colorValue, isDark);

    final borderColor = note.isPinned
        ? category.primaryColor.withValues(alpha: 0.75)
        : NoteColorPalette.getBorderColor(note.colorValue, isDark);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _showCardActionMenu(context),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: note.isPinned ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              if (note.isPinned)
                BoxShadow(
                  color: category.primaryColor.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar: Category Chip & Pin Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Badge (Flexible to prevent right overflow)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: category.primaryColor.withValues(alpha: isDark ? 0.2 : 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category.icon,
                            size: 12,
                            color: category.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              category.displayName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: category.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Pin / Action Icon
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (note.isPinned)
                        Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.only(right: 2),
                          decoration: BoxDecoration(
                            color: category.primaryColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.push_pin_rounded,
                            size: 14,
                            color: category.primaryColor,
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.more_vert_rounded, size: 18),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        onPressed: () => _showCardActionMenu(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Attached Photo Thumbnail Preview
              if (note.hasImage && File(note.imagePath!).existsSync()) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(note.imagePath!),
                    height: isGridView ? 100 : 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Title
              Text(
                note.title.isNotEmpty ? note.title : 'Untitled',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                  height: 1.3,
                ),
                maxLines: isGridView ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),

              if (note.content.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    height: 1.45,
                  ),
                  maxLines: isGridView ? 5 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 14),

              // Footer: Live Animated Running Date & Character Count
              Container(
                padding: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Live Indicator Dot
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: category.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: category.primaryColor.withValues(alpha: 0.6),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),

                    // Live Animated Running Date Text (scrolls left to right smoothly)
                    Expanded(
                      child: AnimatedMarqueeText(
                        text: DateFormatter.formatRelative(note.updatedAt),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Character Count Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${note.characterCount} ch',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCardActionMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF131B2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  note.isPinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
                  color: note.category.primaryColor,
                ),
                title: Text(note.isPinned ? 'Unpin Note' : 'Pin to Top'),
                onTap: () {
                  Navigator.pop(context);
                  onTogglePin();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Note'),
                onTap: () {
                  Navigator.pop(context);
                  onTap();
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: Color(0xFF3B82F6)),
                title: const Text('Share to External Apps'),
                onTap: () {
                  Navigator.pop(context);
                  ShareService.shareNote(note);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                title: const Text(
                  'Delete Note',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  DeleteConfirmBottomSheet.show(
                    context: context,
                    note: note,
                    onConfirmDelete: onDelete,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
