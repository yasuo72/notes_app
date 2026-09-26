import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/sample_notes_data.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/note_category.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../data/repositories/notes_repository_impl.dart';

/// GetX Controller managing Note listing, live debounced search, filtering, pin, and undo-delete.
class NotesController extends GetxController {
  final NotesRepository _repository;
  final StorageService _storageService;

  // Reactive States
  final RxList<NoteEntity> _allNotes = <NoteEntity>[].obs;
  final RxList<NoteEntity> filteredNotes = <NoteEntity>[].obs;

  final Rx<NoteCategory> selectedCategory = NoteCategory.all.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isGridView = true.obs;
  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();

  // Search input controller
  final TextEditingController searchTextController = TextEditingController();

  NotesController({
    NotesRepository? repository,
    StorageService? storageService,
  })  : _repository = repository ?? NotesRepositoryImpl(),
        _storageService = storageService ?? Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    isGridView.value = _storageService.isGridView;

    // Phase 2: Debounced reactive search worker (prevents UI lag on rapid typing)
    debounce(
      searchQuery,
      (_) => _applyFilter(),
      time: const Duration(milliseconds: 250),
    );

    // Reactively filter whenever selected category changes
    ever(selectedCategory, (_) => _applyFilter());

    // Initial load
    fetchNotes();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  /// Fetches notes from local SQLite database.
  Future<void> fetchNotes() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      var fetched = await _repository.getAllNotes();

      // Automatically populate realistic sample notes on first run if DB is empty
      if (fetched.isEmpty && !_storageService.hasSeededSampleNotes) {
        for (final sample in SampleNotesData.getInitialSampleNotes()) {
          await _repository.createNote(sample);
        }
        await _storageService.setHasSeededSampleNotes(true);
        fetched = await _repository.getAllNotes();
      }

      _allNotes.assignAll(fetched);
      _applyFilter();
    } catch (e) {
      errorMessage.value = e is AppException ? e.message : 'Failed to load notes. Please retry.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Manually restores or populates sample notes.
  Future<void> seedSampleNotes() async {
    isLoading.value = true;
    try {
      for (final sample in SampleNotesData.getInitialSampleNotes()) {
        await _repository.createNote(sample);
      }
      await _storageService.setHasSeededSampleNotes(true);
      final fetched = await _repository.getAllNotes();
      _allNotes.assignAll(fetched);
      _applyFilter();

      Get.snackbar(
        'Sample Notes Added',
        'Added ${SampleNotesData.getInitialSampleNotes().length} sample notes across all categories.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.auto_awesome_rounded, color: Color(0xFFF59E0B)),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to seed sample notes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggles between Staggered Grid and List layout.
  Future<void> toggleViewMode() async {
    isGridView.value = !isGridView.value;
    await _storageService.setGridView(isGridView.value);
  }

  /// Updates current search query.
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  /// Clears active search input.
  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
  }

  /// Sets active category filter pill.
  void selectCategory(NoteCategory category) {
    selectedCategory.value = category;
  }

  /// Returns total count of notes in a given category.
  int getCategoryCount(NoteCategory category) {
    if (category == NoteCategory.all) {
      return _allNotes.length;
    }
    return _allNotes.where((n) => n.category == category).length;
  }

  /// Filters notes based on both search query and selected category.
  void _applyFilter() {
    final query = searchQuery.value.trim().toLowerCase();
    final category = selectedCategory.value;

    List<NoteEntity> result = List.from(_allNotes);

    // Apply category filter
    if (category != NoteCategory.all) {
      result = result.where((note) => note.category == category).toList();
    }

    // Apply text search across title and content
    if (query.isNotEmpty) {
      result = result.where((note) {
        final titleMatch = note.title.toLowerCase().contains(query);
        final contentMatch = note.content.toLowerCase().contains(query);
        final catMatch = note.category.displayName.toLowerCase().contains(query);
        return titleMatch || contentMatch || catMatch;
      }).toList();
    }

    // Keep pinned items at top
    result.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    filteredNotes.assignAll(result);
  }

  /// Toggles the pinned status of a note.
  Future<void> togglePin(NoteEntity note) async {
    final updatedPinState = !note.isPinned;
    try {
      await _repository.togglePin(note.id, updatedPinState);
      final index = _allNotes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _allNotes[index] = note.copyWith(
          isPinned: updatedPinState,
          updatedAt: DateTime.now(),
        );
        _applyFilter();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update pin status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    }
  }

  /// Deletes note from SQLite with a 4-second Undo SnackBar safety net.
  Future<void> deleteNote(NoteEntity note) async {
    // Preserve local copy for undo
    final deletedNote = note;
    final originalIndex = _allNotes.indexWhere((n) => n.id == note.id);

    // Optimistically remove from state
    _allNotes.removeWhere((n) => n.id == note.id);
    _applyFilter();

    try {
      await _repository.deleteNote(note.id);

      // Show Undo SnackBar
      Get.closeCurrentSnackbar();
      Get.snackbar(
        'Note Deleted',
        '"${note.title.isNotEmpty ? note.title : 'Untitled'}" moved to trash.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        backgroundColor: const Color(0xFF1E293B),
        colorText: Colors.white,
        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
        mainButton: TextButton(
          onPressed: () async {
            Get.closeCurrentSnackbar();
            await _restoreDeletedNote(deletedNote, originalIndex);
          },
          child: const Text(
            'UNDO',
            style: TextStyle(
              color: Color(0xFF38BDF8),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      );
    } catch (e) {
      // Revert if DB fails
      if (originalIndex != -1) {
        _allNotes.insert(originalIndex, deletedNote);
        _applyFilter();
      }
      Get.snackbar('Error', 'Failed to delete note');
    }
  }

  /// Restores a deleted note back into SQLite and reactive state.
  Future<void> _restoreDeletedNote(NoteEntity note, int originalIndex) async {
    try {
      await _repository.restoreNote(note);
      if (originalIndex >= 0 && originalIndex <= _allNotes.length) {
        _allNotes.insert(originalIndex, note);
      } else {
        _allNotes.add(note);
      }
      _applyFilter();

      Get.snackbar(
        'Restored',
        'Note restored successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        backgroundColor: const Color(0xFF065F46),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to restore note');
    }
  }

  /// Called after creating or editing a note to ensure list freshness.
  void onNoteSaved(NoteEntity savedNote) {
    final index = _allNotes.indexWhere((n) => n.id == savedNote.id);
    if (index != -1) {
      _allNotes[index] = savedNote;
    } else {
      _allNotes.insert(0, savedNote);
    }
    _applyFilter();
  }
}
