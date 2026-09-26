import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/note_color_palette.dart';
import '../../domain/entities/note_entity.dart';
import '../controllers/note_editor_controller.dart';
import '../widgets/category_selector_chips.dart';
import '../widgets/character_stats_badge.dart';
import '../widgets/note_formatting_toolbar.dart';

/// Full-screen Note Editor for creating and editing notes with live character count, image attachment, and validation.
class NoteEditorView extends StatefulWidget {
  final NoteEntity? existingNote;

  const NoteEditorView({super.key, this.existingNote});

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  late final NoteEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(NoteEditorController(existingNote: widget.existingNote));
  }

  @override
  void dispose() {
    Get.delete<NoteEditorController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (controller.hasUnsavedChanges()) {
          final discard = await _showDiscardDialog(context);
          if (discard == true && context.mounted) {
            Navigator.of(context).pop();
          }
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Obx(() {
        final bgColor = NoteColorPalette.getBackgroundColor(
          controller.selectedColorIndex.value,
          isDark,
        );

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Close',
              onPressed: () async {
                if (controller.hasUnsavedChanges()) {
                  final discard = await _showDiscardDialog(context);
                  if (discard == true && context.mounted) {
                    Navigator.of(context).pop();
                  }
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            title: Text(
              controller.isEditing ? 'Edit Note' : 'New Note',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              // Color Tint Action Button
              IconButton(
                icon: Icon(
                  Icons.palette_outlined,
                  color: NoteColorPalette.getItem(controller.selectedColorIndex.value).dotColor,
                ),
                tooltip: 'Color (${NoteColorPalette.getItem(controller.selectedColorIndex.value).name})',
                onPressed: () => _showColorPickerSheet(context),
              ),

              // Attach Photo Action Button
              IconButton(
                icon: const Icon(Icons.add_photo_alternate_outlined),
                tooltip: 'Add Image Attachment',
                onPressed: () => _showImagePickerSheet(context),
              ),

              // Pin Toggle Button
              IconButton(
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
              ),

            // Save Action Button
            Obx(() => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ElevatedButton.icon(
                    onPressed: controller.isSaving.value
                        ? null
                        : () async {
                            final isEditing = controller.isEditing;
                            final success = await controller.saveNote();
                            if (success && context.mounted) {
                              Navigator.of(context).pop(true);
                              Get.closeCurrentSnackbar();
                              Get.snackbar(
                                isEditing ? 'Note Updated' : 'Note Created',
                                isEditing
                                    ? 'Your changes have been saved.'
                                    : 'Your new note has been saved.',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 3),
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                                backgroundColor: const Color(0xFF065F46),
                                colorText: Colors.white,
                                icon: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.greenAccent,
                                ),
                              );
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
                  CategorySelectorChips(controller: controller),
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

            // Editor Inputs: Image Preview, Title & Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Attached Image Preview with Remove Action
                    Obx(() {
                      final path = controller.imagePath.value;
                      if (path == null || path.isEmpty) return const SizedBox.shrink();
                      final file = File(path);
                      if (!file.existsSync()) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                file,
                                height: 190,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Material(
                                color: Colors.black.withValues(alpha: 0.65),
                                shape: const CircleBorder(),
                                child: InkWell(
                                  onTap: controller.removeImage,
                                  customBorder: const CircleBorder(),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

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

                    // Content Field with Dynamic Font & Size Styling
                    Obx(() => TextField(
                          controller: controller.contentController,
                          focusNode: controller.contentFocusNode,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          style: controller.selectedFont.value.getTextStyle(
                            fontSize: controller.fontSize.value,
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
                        )),

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

            // Docked Writing Assistance Toolbar (Markdown shortcuts, colors, fonts)
            NoteFormattingToolbar(controller: controller),
          ],
        ),
      );
    }),
  );
  }

  void _showImagePickerSheet(BuildContext context) {
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
                leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF3B82F6)),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF10B981)),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPickerSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF131B2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.palette_rounded, color: Color(0xFFF59E0B), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Choose Note Background Tint',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: NoteColorPalette.presets.map((item) {
                  return Obx(() {
                    final isSelected = controller.selectedColorIndex.value == item.id;
                    final bg = isDark ? item.darkBackground : item.lightBackground;
                    final border = item.dotColor;

                    return InkWell(
                      onTap: () {
                        controller.setColorIndex(item.id);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? border : border.withValues(alpha: 0.3),
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: item.dotColor,
                                shape: BoxShape.circle,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
            ],
          ),
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
