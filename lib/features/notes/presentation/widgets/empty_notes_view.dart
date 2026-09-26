import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/app/routes/app_routes.dart';
import '../controllers/notes_controller.dart';

/// Zero-state widget showing a modern, friendly illustration and action buttons.
class EmptyNotesView extends StatelessWidget {
  final bool isSearchResult;

  const EmptyNotesView({
    super.key,
    this.isSearchResult = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<NotesController>();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative Glowing Circle with Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isSearchResult
                      ? [
                          const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          const Color(0xFFEF4444).withValues(alpha: 0.1),
                        ]
                      : [
                          const Color(0xFF4F46E5).withValues(alpha: 0.15),
                          const Color(0xFF06B6D4).withValues(alpha: 0.1),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isSearchResult
                      ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
                      : const Color(0xFF4F46E5).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: isSearchResult
                    ? const Icon(
                        Icons.search_off_rounded,
                        size: 56,
                        color: Color(0xFFF59E0B),
                      )
                    : Image.asset(
                        'assets/icon/app_icon.png',
                        width: 68,
                        height: 68,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Heading Title
            Text(
              isSearchResult ? 'No Matching Notes' : 'No Notes Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Informative Subtitle
            Text(
              isSearchResult
                  ? 'We couldn\'t find any notes matching "${controller.searchQuery.value}". Try another keyword or reset the category filter.'
                  : 'Capture ideas, organize tasks, plan projects, and store personal thoughts all in one place.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Call-to-action button
            if (isSearchResult)
              OutlinedButton.icon(
                onPressed: controller.clearSearch,
                icon: const Icon(Icons.clear_rounded, size: 18),
                label: const Text('Clear Search Filter'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            else ...[
              ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.editor),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Create First Note'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: controller.seedSampleNotes,
                icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                label: const Text('Load Sample Notes'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
