import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notes_controller.dart';

/// Clean, debounced live search bar for filtering notes.
class NoteSearchBar extends StatelessWidget {
  const NoteSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131B2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchTextController,
          onChanged: controller.onSearchChanged,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: 'Search notes by title, content or category...',
            hintStyle: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              size: 20,
            ),
            suffixIcon: Obx(() {
              if (controller.searchQuery.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                onPressed: controller.clearSearch,
                tooltip: 'Clear search',
              );
            }),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}
