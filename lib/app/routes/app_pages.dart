import 'package:get/get.dart';
import '../../features/notes/domain/entities/note_entity.dart';
import '../../features/notes/presentation/controllers/notes_controller.dart';
import '../../features/notes/presentation/views/note_detail_view.dart';
import '../../features/notes/presentation/views/note_editor_view.dart';
import '../../features/notes/presentation/views/notes_list_view.dart';
import 'app_routes.dart';

/// App routing registration and GetPage declarations.
class AppPages {
  AppPages._();

  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const NotesListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NotesController>(() => NotesController());
      }),
    ),
    GetPage(
      name: AppRoutes.editor,
      page: () {
        final note = Get.arguments as NoteEntity?;
        return NoteEditorView(existingNote: note);
      },
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () {
        final note = Get.arguments as NoteEntity;
        return NoteDetailView(note: note);
      },
    ),
  ];
}
