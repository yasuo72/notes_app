import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/note_entity.dart';
import '../controllers/note_editor_controller.dart';
import '../widgets/category_selector_chips.dart';
import '../widgets/character_stats_badge.dart';

/// Full-screen Note Editor for creating and editing notes with live character count and form validation.
class NoteEditorView extends StatelessWidget {
  final NoteEntity? existingNote;

  const NoteEditorView({super.key, this.existingNote});

  @override
  Widget build(BuildContext context) {
    // Instantiate or tag controller based on editing state
    final controller = Get.put(
      NoteEditorController(existingNote: existingNote),
      tag: existingNote?.id ?? 'new_note',
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (controller.hasUnsavedChanges()) {
          final discard = await _showDiscardDialog(context);
          if (discard == true) {
            Get.back();
          }
        } else {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Close',
            onPressed: () async {
              if (controller.hasUnsavedChanges()) {
                final discard = await _showDiscardDialog(context);
                if (discard == true) {
                  Get.back();
                }
              } else {
                Get.back();
              }
            },
          ),
          title: Text(
            controller.isEditing ? 'Edit Note' : 'New Note',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          actions: [
            // Pin Toggle Button
            Obx(() => IconButton(
                  icon: Icon(
                    controller.isPinned.value
                        ? Icons.push_pin_rounded
                        : Icons.push_pin_outlined,
                    color: controller.isPinned.value
                        ? controller.selectedCategory.value.primaryColor
                        : null,
                  ),
                  tooltip: controller.isPinned.value ? 'Unpin' : 'Pin to top',
                  onPressed: controller.togglePin,
                )),

            // Save Action Button
            Obx(() => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ElevatedButton.icon(
                    onPressed: controller.isSaving.value
                        ? null
                        : () async {
                            final success = await controller.saveNote();
                            if (success) {
                              Get.back();
                            }
                          },
                    icon: controller.isSaving.value
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(
                      controller.isEditing ? 'Update' : 'Save',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                )),
          ],
        ),
        body: Column(
          children: [
            // Top Status Bar: Category Picker & Real-Time Character Counter
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategorySelectorChips(),
                  const SizedBox(height: 12),
                  // Phase 2: Live reactive character count, word count, reading time
                  Obx(() => CharacterStatsBadge(
                        characterCount: controller.characterCount.value,
                        wordCount: controller.wordCount.value,
                        readingTime: controller.readingTime.value,
                      )),
                ],
              ),
            ),
            const Divider(),

            // Editor Inputs: Title & Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field with Validation Error Display
                    TextField(
                      controller: controller.titleController,
                      focusNode: controller.titleFocusNode,
                      textCapitalization: TextCapitalization.sentences,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      decoration: const InputDecoration(
                        hintText: 'Note Title...',
                        hintStyle: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),

                    // Title Validation Error Hint
                    Obx(() {
                      final error = controller.titleError.value;
                      if (error == null) return const SizedBox(height: 8);
                      return Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                size: 14, color: Color(0xFFEF4444)),
                            const SizedBox(width: 4),
                            Text(
                              error,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 8),

                    // Content Field with Validation Error Display
                    TextField(
                      controller: controller.contentController,
                      focusNode: controller.contentFocusNode,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            height: 1.6,
                            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
                          ),
                      decoration: const InputDecoration(
                        hintText: 'Start typing your thoughts, ideas or tasks here...',
                        hintStyle: TextStyle(
                          color: Color(0xFF94A3B8),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),

                    // Content Validation Error Hint
                    Obx(() {
                      final error = controller.contentError.value;
                      if (error == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                size: 14, color: Color(0xFFEF4444)),
                            const SizedBox(width: 4),
                            Text(
                              error,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDiscardDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard Unsaved Changes?'),
        content: const Text(
          'You have unsaved edits in this note. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep Editing'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}
