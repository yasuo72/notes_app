import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/note_typography_helper.dart';
import '../../../../core/utils/text_stats_helper.dart';
import '../../domain/entities/note_category.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../data/repositories/notes_repository_impl.dart';
import 'notes_controller.dart';

/// GetX Controller managing Note creation and editing, form validation, image attachments, and live stats.
class NoteEditorController extends GetxController {
  final NotesRepository _repository;
  final NoteEntity? existingNote;
  final ImagePicker _imagePicker = ImagePicker();

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
  final RxnString imagePath = RxnString();

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
    if (Get.isRegistered<StorageService>()) {
      final storage = Get.find<StorageService>();
      selectedFont.value = NoteFontFamily.fromString(storage.noteFontFamily);
      fontSize.value = storage.noteFontSize;
    }
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
      imagePath.value = existingNote!.imagePath;
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

  final Rx<NoteFontFamily> selectedFont = NoteFontFamily.inter.obs;
  final RxDouble fontSize = 16.0.obs;

  /// Changes the typography font family and persists preference.
  void setFont(NoteFontFamily font) {
    selectedFont.value = font;
    if (Get.isRegistered<StorageService>()) {
      Get.find<StorageService>().setNoteFontFamily(font.familyName);
    }
  }

  /// Adjusts text size and persists preference.
  void setFontSize(double size) {
    fontSize.value = size;
    if (Get.isRegistered<StorageService>()) {
      Get.find<StorageService>().setNoteFontSize(size);
    }
  }

  /// Applies markdown styling (e.g. bold, italic, inline code) at selection or cursor.
  void applyFormatting(String prefix, [String suffix = '']) {
    final text = contentController.text;
    final selection = contentController.selection;

    if (selection.start >= 0 && selection.end >= 0 && selection.start != selection.end) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(selection.start, selection.end, '$prefix$selectedText$suffix');
      contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: selection.start,
          extentOffset: selection.start + prefix.length + selectedText.length + suffix.length,
        ),
      );
    } else {
      final cursorPosition = selection.isValid && selection.start >= 0 ? selection.start : text.length;
      final newText = text.replaceRange(cursorPosition, cursorPosition, '$prefix$suffix');
      contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: cursorPosition + prefix.length),
      );
    }
  }

  /// Inserts a block-level item (bullet, checkbox, heading) at cursor on a fresh line.
  void insertBlock(String blockPrefix) {
    final text = contentController.text;
    final selection = contentController.selection;
    final cursorPosition = selection.isValid && selection.start >= 0 ? selection.start : text.length;

    final needsLeadingNewline = cursorPosition > 0 && text[cursorPosition - 1] != '\n';
    final insertText = (needsLeadingNewline ? '\n' : '') + blockPrefix;

    final newText = text.replaceRange(cursorPosition, cursorPosition, insertText);
    contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition + insertText.length),
    );
  }

  /// Inserts formatted date/time stamp.
  void insertTimestamp() {
    final now = DateTime.now();
    final formatted = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    applyFormatting('[$formatted] ');
  }

  /// Toggles pinned state.
  void togglePin() {
    isPinned.value = !isPinned.value;
  }

  /// Picks photo from Camera or Gallery.
  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (picked != null) {
        imagePath.value = picked.path;
      }
    } catch (e) {
      Get.snackbar(
        'Image Attachment',
        'Could not access image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  /// Removes attached photo.
  void removeImage() {
    imagePath.value = null;
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
      return currentTitle.isNotEmpty ||
          currentContent.isNotEmpty ||
          imagePath.value != null;
    }

    return currentTitle != existingNote!.title ||
        currentContent != existingNote!.content ||
        selectedCategory.value != existingNote!.category ||
        selectedColorIndex.value != existingNote!.colorValue ||
        isPinned.value != existingNote!.isPinned ||
        imagePath.value != existingNote!.imagePath;
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
        imagePath: imagePath.value,
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
