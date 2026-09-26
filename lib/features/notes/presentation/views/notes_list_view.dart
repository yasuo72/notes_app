import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:note_app/app/routes/app_routes.dart';
import '../controllers/notes_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/empty_notes_view.dart';
import '../widgets/note_card.dart';
import '../widgets/note_search_bar.dart';

/// Main Notes Screen with Masonry Staggered Grid / List toggle, live GetX search, category filters, and theme switcher.
class NotesListView extends StatelessWidget {
  const NotesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.sticky_note_2_rounded,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'My Notes',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
            const SizedBox(width: 8),
            // Live Total Note Count Badge
            Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    '${notesController.filteredNotes.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )),
          ],
        ),
        actions: [
          // Phase 2: Theme Switcher using GetX (Light / Dark)
          Obx(() => IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: anim,
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: Icon(
                    themeController.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    key: ValueKey(themeController.isDarkMode),
                    color: themeController.isDarkMode
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF6366F1),
                  ),
                ),
                tooltip: themeController.isDarkMode ? 'Switch to Light' : 'Switch to Dark',
                onPressed: themeController.toggleTheme,
              )),

          // View Layout Toggle: Staggered Grid vs List
          Obx(() => IconButton(
                icon: Icon(
                  notesController.isGridView.value
                      ? Icons.view_agenda_outlined
                      : Icons.grid_view_rounded,
                ),
                tooltip: notesController.isGridView.value
                    ? 'Switch to List View'
                    : 'Switch to Grid View',
                onPressed: notesController.toggleViewMode,
              )),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: notesController.fetchNotes,
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Phase 2: Reactive Live Search Bar
            const NoteSearchBar(),
            const SizedBox(height: 12),

            // Phase 2: Interactive Category Filter Pill Bar
            const CategoryFilterBar(),
            const SizedBox(height: 12),

            // Notes List / Grid Content
            Expanded(
              child: Obx(() {
                // Loading Skeleton State
                if (notesController.isLoading.value) {
                  return _buildLoadingSkeleton(isDark);
                }

                // Error State with Retry
                if (notesController.errorMessage.value != null) {
                  return _buildErrorState(
                    context,
                    notesController.errorMessage.value!,
                    notesController.fetchNotes,
                  );
                }

                // Empty State
                if (notesController.filteredNotes.isEmpty) {
                  return EmptyNotesView(
                    isSearchResult: notesController.searchQuery.value.isNotEmpty ||
                        notesController.selectedCategory.value.name != 'all',
                  );
                }

                final notes = notesController.filteredNotes;

                // Staggered Masonry Grid Layout (Google Keep style)
                if (notesController.isGridView.value) {
                  return MasonryGridView.count(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return NoteCard(
                        note: note,
                        isGridView: true,
                        onTap: () => Get.toNamed(AppRoutes.detail, arguments: note),
                        onTogglePin: () => notesController.togglePin(note),
                        onDelete: () => notesController.deleteNote(note),
                      );
                    },
                  );
                }

                // Clean Structured List Layout
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      isGridView: false,
                      onTap: () => Get.toNamed(AppRoutes.detail, arguments: note),
                      onTogglePin: () => notesController.togglePin(note),
                      onDelete: () => notesController.deleteNote(note),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.editor),
        icon: const Icon(Icons.edit_note_rounded, size: 22),
        label: const Text(
          'New Note',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
        ),
      ),
    );
  }

  /// Shimmer loading skeleton representation
  Widget _buildLoadingSkeleton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: 6,
        itemBuilder: (_, index) {
          final heights = [130.0, 180.0, 150.0, 120.0, 170.0, 140.0];
          return Container(
            height: heights[index % heights.length],
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131B2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Error state with retry action
  Widget _buildErrorState(BuildContext context, String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
