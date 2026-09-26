import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'features/notes/presentation/controllers/notes_controller.dart';
import 'features/notes/presentation/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Services
  final storageService = await StorageService.init();
  Get.put<StorageService>(storageService, permanent: true);

  // Initialize Global Controllers
  final themeController = Get.put<ThemeController>(
    ThemeController(storageService: storageService),
    permanent: true,
  );

  Get.put<NotesController>(
    NotesController(storageService: storageService),
    permanent: true,
  );

  runApp(NotesApp(themeController: themeController));
}

class NotesApp extends StatelessWidget {
  final ThemeController themeController;

  const NotesApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          title: 'Notes',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode.value,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 250),
        ));
  }
}
