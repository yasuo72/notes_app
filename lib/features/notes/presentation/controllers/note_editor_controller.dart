import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/text_stats_helper.dart';
import '../../domain/entities/note_category.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../data/repositories/notes_repository_impl.dart';
import 'notes_controller.dart';

/// GetX Controller managing Note creation and editing, form validation, and live character stats.
class NoteEditorController extends GetxController {
  final NotesRepository _repository;
  final NoteEntity? existingNote;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // Focus nodes
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();

  // Form states
  final Rx<NoteCategory> selectedCategory = NoteCategory.personal.obs;
  final RxInt selectedColorIndex = 0.obs;
  final RxBool isPinned = false.obs;
  final RxBool isSaving = false.obs;

  // Real-time character & word counts (Phase 2 Requirement)
  final RxInt characterCount = 0.obs;
  final RxInt wordCount = 0.obs;
  final RxString readingTime = '0 min read'.obs;

  // Validation error messages
  final RxnString titleError = RxnString();
  final RxnString contentError = RxnString();

  NoteEditorController({
    this.existingNote,
    NotesRepository? repository,
  }) : _repository = repository ?? NotesRepositoryImpl();

  bool get isEditing => existingNote != null;

  @override
  void onInit() {
    super.onInit();
    _populateInitialData();

    // Listen to content changes for real-time character & word stats
    contentController.addListener(_onContentChanged);
    titleController.addListener(_onTitleChanged);
  }

  @override
  void onClose() {
    titleController.removeListener(_onTitleChanged);
    contentController.removeListener(_onContentChanged);
    titleController.dispose();
    contentController.dispose();
    titleFocusNode.dispose();
    contentFocusNode.dispose();
    super.onClose();
  }

  void _populateInitialData() {
    if (existingNote != null) {
      titleController.text = existingNote!.title;
      contentController.text = existingNote!.content;
      selectedCategory.value = existingNote!.category;
      selectedColorIndex.value = existingNote!.colorValue;
      isPinned.value = existingNote!.isPinned;
    }
    _updateStats();
  }

  void _onTitleChanged() {
    if (titleError.value != null && titleController.text.trim().isNotEmpty) {
      titleError.value = null;
    }
  }

  void _onContentChanged() {
    _updateStats();
    if (contentError.value != null && contentController.text.trim().isNotEmpty) {
      contentError.value = null;
    }
  }

  void _updateStats() {
    final text = contentController.text;
    characterCount.value = TextStatsHelper.getCharacterCount(text);
    wordCount.value = TextStatsHelper.getWordCount(text);
    readingTime.value = TextStatsHelper.getReadingTime(text);
  }

  /// Sets selected category.
  void setCategory(NoteCategory category) {
    selectedCategory.value = category;
  }

  /// Sets card color index.
  void setColorIndex(int index) {
    selectedColorIndex.value = index;
  }

  /// Toggles pinned state.
  void togglePin() {
    isPinned.value = !isPinned.value;
  }

  /// Validates inputs and returns whether the form is clean.
  bool validate() {
    bool isValid = true;
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty) {
      titleError.value = 'Please enter a title for your note';
      isValid = false;
    } else if (title.length > 100) {
      titleError.value = 'Title cannot exceed 100 characters';
      isValid = false;
    } else {
      titleError.value = null;
    }

    if (content.isEmpty) {
      contentError.value = 'Note content cannot be empty';
      isValid = false;
    } else {
      contentError.value = null;
    }

    return isValid;
  }

  /// Checks whether user made changes compared to initial state.
  bool hasUnsavedChanges() {
    final currentTitle = titleController.text.trim();
    final currentContent = contentController.text.trim();

    if (existingNote == null) {
      return currentTitle.isNotEmpty || currentContent.isNotEmpty;
    }

    return currentTitle != existingNote!.title ||
        currentContent != existingNote!.content ||
        selectedCategory.value != existingNote!.category ||
        selectedColorIndex.value != existingNote!.colorValue ||
        isPinned.value != existingNote!.isPinned;
  }

  /// Saves or updates the note in SQLite.
  Future<bool> saveNote() async {
    if (!validate()) return false;

    isSaving.value = true;
    try {
      final now = DateTime.now();
      final note = NoteEntity(
        id: existingNote?.id ?? const Uuid().v4(),
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        category: selectedCategory.value,
        colorValue: selectedColorIndex.value,
        isPinned: isPinned.value,
        createdAt: existingNote?.createdAt ?? now,
        updatedAt: now,
      );

      if (isEditing) {
        await _repository.updateNote(note);
      } else {
        await _repository.createNote(note);
      }

      // Notify NotesController to update reactive list
      if (Get.isRegistered<NotesController>()) {
        Get.find<NotesController>().onNoteSaved(note);
      }

      Get.snackbar(
        'Success',
        isEditing ? 'Note updated successfully' : 'Note created successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        backgroundColor: const Color(0xFF065F46),
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Save Error',
        'Could not save note: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
