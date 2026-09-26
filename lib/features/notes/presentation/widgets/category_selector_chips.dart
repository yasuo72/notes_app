import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/note_category.dart';
import '../controllers/note_editor_controller.dart';

/// Category selection chips inside Note Editor with optional direct controller injection.
class CategorySelectorChips extends StatelessWidget {
  final NoteEditorController? controller;

  const CategorySelectorChips({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    final editorController = controller ?? Get.find<NoteEditorController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter out 'all' since notes must have an actual category
    final editableCategories = NoteCategory.values
        .where((c) => c != NoteCategory.all)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: editableCategories.map((category) {
            return Obx(() {
              final isSelected = editorController.selectedCategory.value == category;
              final primaryColor = category.primaryColor;

              return ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  category.icon,
                  size: 16,
                  color: isSelected ? Colors.white : primaryColor,
                ),
                label: Text(category.displayName),
                selected: isSelected,
                selectedColor: primaryColor,
                backgroundColor: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155)),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? primaryColor
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    width: 1.2,
                  ),
                ),
                onSelected: (selected) {
                  if (selected) {
                    editorController.setCategory(category);
                  }
                },
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}
