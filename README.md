# 🗒️ NotesApp — Production-Grade Reactive Notes System

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.35.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.9.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/State_Management-GetX_4.7-8A2BE2?style=for-the-badge&logo=graphql&logoColor=white" alt="GetX" />
  <img src="https://img.shields.io/badge/Database-SQLite_2.4-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" />
  <img src="https://img.shields.io/badge/Architecture-Feature--First_Clean_Arch-4CAF50?style=for-the-badge" alt="Clean Architecture" />
  <img src="https://img.shields.io/badge/Code_Quality-Analyzed_0_Lints-success?style=for-the-badge" alt="Lints" />
</p>

---

## 📌 Executive Summary

**NotesApp** is an enterprise-ready, cross-platform mobile application developed with **Flutter**, adhering to **Clean Architecture** principles and **Feature-First modularity**. 

Designed with a senior software engineering mindset, it combines reactive state management (**GetX**), ACID-compliant local database persistence (**SQLite** via `sqflite`), real-time debounced query processing, dynamic masonry staggered layouts, and an adaptive light/dark theming engine.

---

## ✨ Features Breakdown

### 📱 Phase 1: Core Foundation & Modern UX
* **Full CRUD Operations**:
  * **Create**: Quick add action via floating button to distraction-free editor.
  * **Read**: Google Keep / Notion style Masonry Staggered Grid (`flutter_staggered_grid_view`) and Structured List view.
  * **Update**: Full edit mode with pre-filled state, timestamp tracking, and dirty-checking.
  * **Delete with Safety Net**: Bottom sheet confirmation with note snippet + **4-Second Undo SnackBar** (optimistic deletion with rollback).
* **View Layout Toggle**: 1-tap switcher between dual-column Masonry Grid and single-column List view.
* **Pin Priority Notes**: High-priority notes stay fixed at the top with glowing category badges.
* **Zero-State Empty Screen**: Custom illustration with contextual action triggers (`Create Note` when empty, `Clear Filter` on empty searches).
* **Defensive Form Validation**:
  * Title validation (non-empty, maximum 100 characters constraint).
  * Body content non-empty constraint.
  * Real-time error banners and unsaved changes modal guard.
* **Resilience & Loading States**:
  * Shimmer skeleton card placeholders during cold database boots.
  * Centralized exception handling with user-facing retry triggers.

---

### ⚡ Phase 2: Reactive GetX Capabilities & Organization
* **Live Keystroke Metrics (Real-Time Counter)**:
  * Reactive streams computing total **Character Count**, **Word Count**, and **Estimated Reading Time** (e.g., `142 chars • 26 words • 1 min read`).
  * Displayed seamlessly in both the editor status bar and card metadata chips.
* **Dynamic Theme Engine (Light & Dark)**:
  * Material 3 OLED Dark theme (`#0B0F19`) and Clean Slate Light theme (`#F8FAFC`).
  * Instant reactive switching powered by `ThemeController` and `Get.changeThemeMode()`.
  * Persistent user preference saved in local storage (`SharedPreferences`).
* **Debounced Real-Time Search**:
  * Integrated with GetX reactive workers: `debounce(searchQuery, ..., time: 250ms)`.
  * Prevents UI thread stutter and wasteful database locks on fast typing.
  * Multi-field full-text query matching across `title`, `content`, and `category`.
* **Category Tagging System**:
  * 4 distinct categories with dedicated visual styling and icons:
    * 💼 **Work** (`#3B82F6` — Royal Blue | `Icons.work_rounded`)
    * 🌸 **Personal** (`#EC4899` — Soft Rose | `Icons.person_rounded`)
    * ⚡ **Task** (`#F59E0B` — Warm Amber | `Icons.check_circle_outline_rounded`)
    * 💡 **Ideas** (`#10B981` — Emerald Mint | `Icons.lightbulb_outline_rounded`)
  * Interactive horizontal filter pill bar showing live note counts per category (e.g. `Work (4)`, `Ideas (2)`).

---

## 🏛️ Architecture & System Design

The project strictly follows **Clean Architecture with Feature-First packaging**:

```
                         ┌────────────────────────────────────────┐
                         │           Presentation Layer           │
                         │   • Views (List, Editor, Detail)       │
                         │   • GetX Controllers (Rx, Obx)         │
                         │   • Specialized Modular Widgets        │
                         └───────────────────┬────────────────────┘
                                             │ depends on
                                             ▼
                         ┌────────────────────────────────────────┐
                         │              Domain Layer              │
                         │   • NoteEntity (Immutable Business)    │
                         │   • NoteCategory Enum & Rules          │
                         │   • NotesRepository (Abstract Contract)│
                         └───────────────────▲────────────────────┘
                                             │ implemented by
                         ┌───────────────────┴────────────────────┐
                         │               Data Layer               │
                         │   • NotesRepositoryImpl                │
                         │   • NotesLocalDataSource (SQLite)      │
                         │   • NoteModel (JSON / Map DTO)         │
                         └────────────────────────────────────────┘
```

### Key Engineering Principles
1. **Single Responsibility (SRP)**: Controllers manage reactive state, Repositories handle data coordination, DataSources execute raw SQLite operations, and Views render UI.
2. **Dependency Inversion (DIP)**: High-level presentation and domain layers do not depend directly on concrete SQLite implementations; they depend on the abstract `NotesRepository`.
3. **Micro-Reactivity**: Using GetX `Obx()` ensures that only the affected widgets (e.g. character counter pill or search clear button) rebuild on state change, preserving a constant 60/120 FPS.

---

## 🗄️ Database Architecture (SQLite)

### Table Schema: `notes`
```sql
CREATE TABLE notes (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    category TEXT NOT NULL,
    color_value INTEGER NOT NULL,
    is_pinned INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

-- Compound index for 0ms sorting overhead
CREATE INDEX idx_notes_pinned ON notes (is_pinned DESC, updated_at DESC);

-- Category index for fast filtering
CREATE INDEX idx_notes_category ON notes (category);
```

### Optimization Techniques Applied:
* **WAL Mode (Write-Ahead Logging)**: Enables concurrent reads and writes without thread deadlocks.
* **Foreign Key Support**: `PRAGMA foreign_keys = ON;`.
* **Conflict Resolution**: `ConflictAlgorithm.replace` for predictable upserts.

---

## 🎨 Design System & Typography

| Token | Light Theme | Dark Theme | Purpose |
| :--- | :--- | :--- | :--- |
| **Scaffold Background** | `#F8FAFC` | `#0B0F19` | Surface canvas |
| **Card Surface** | `#FFFFFF` | `#131B2E` | Note cards & containers |
| **Primary Accent** | `#4F46E5` (Indigo) | `#6366F1` (Indigo Light) | Primary actions & buttons |
| **Border / Outlines** | `#E2E8F0` | `#1E293B` | Subtle card borders |
| **Text Primary** | `#0F172A` | `#F8FAFC` | High-contrast headings |
| **Text Secondary** | `#64748B` | `#94A3B8` | Body & relative timestamps |

* **Headings**: `GoogleFonts.plusJakartaSans` (Extra Bold, Tight Letter Spacing)
* **Body / Reading**: `GoogleFonts.inter` (Optimized legibility with 1.6x line-height)

---

## 📁 Project Directory Structure

```
note app/
├── lib/
│   ├── app/
│   │   ├── routes/
│   │   │   ├── app_pages.dart          # GetPage route definitions & lazy bindings
│   │   │   └── app_routes.dart         # Route path constants
│   │   └── theme/
│   │       ├── app_colors.dart         # Design system color tokens
│   │       ├── app_theme.dart          # Material 3 light/dark ThemeData
│   │       └── app_typography.dart     # Plus Jakarta Sans & Inter font styling
│   ├── core/
│   │   ├── database/
│   │   │   └── database_helper.dart    # SQLite singleton, tables, migrations & indices
│   │   ├── errors/
│   │   │   └── app_exception.dart      # Domain exceptions (AppDatabaseException, etc.)
│   │   ├── services/
│   │   │   └── storage_service.dart    # SharedPreferences wrapper for persistence
│   │   └── utils/
│   │       ├── date_formatter.dart     # Relative human-readable time conversion
│   │       └── text_stats_helper.dart  # Character, word & reading time calculator
│   ├── features/
│   │   └── notes/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── note_category.dart # Category enum with color & icon tokens
│   │       │   │   └── note_entity.dart   # Immutable business note entity
│   │       │   └── repositories/
│   │       │       └── notes_repository.dart # Abstract contract interface
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── notes_local_data_source.dart # Direct SQLite queries
│   │       │   ├── models/
│   │       │   │   └── note_model.dart     # DTO serialization & entity mapper
│   │       │   └── repositories/
│   │       │       └── notes_repository_impl.dart # Concrete repository
│   │       └── presentation/
│   │           ├── controllers/
│   │           │   ├── note_editor_controller.dart # Form validation & real-time metrics
│   │           │   ├── notes_controller.dart       # Main listing, search & undo logic
│   │           │   └── theme_controller.dart       # GetX light/dark mode switcher
│   │           ├── widgets/
│   │           │   ├── category_filter_bar.dart    # Interactive category pills with counts
│   │           │   ├── category_selector_chips.dart# Category picker inside editor
│   │           │   ├── character_stats_badge.dart  # Real-time stats pill
│   │           │   ├── delete_confirm_bottom_sheet.dart # Confirmation modal with preview
│   │           │   ├── empty_notes_view.dart       # Illustrated zero-state component
│   │           │   ├── note_card.dart              # Staggered & List view card
│   │           │   └── note_search_bar.dart        # Debounced live search field
│   │           └── views/
│   │               ├── note_detail_view.dart       # Read-only note display
│   │               ├── note_editor_view.dart       # Create / Edit note screen
│   │               └── notes_list_view.dart        # Dashboard home view
│   └── main.dart                                   # App bootstrap & service locator
└── test/
    └── widget_test.dart                            # Unit tests for text metrics & entities
```

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK: `^3.35.0` or higher
* Dart SDK: `^3.9.0` or higher
* Android Studio / VS Code / Antigravity IDE with Flutter extension

### Installation Steps

1. **Clone or Navigate to the Project**:
   ```bash
   cd "note app"
   ```

2. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Code Quality**:
   ```bash
   flutter analyze
   ```
   *(Expected output: `No issues found!`)*

4. **Execute Unit Tests**:
   ```bash
   flutter test
   ```
   *(Expected output: `All tests passed!`)*

5. **Launch Application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing Suite

Automated unit tests are located in `test/widget_test.dart` verifying core domain calculations:
* ✅ Text stats calculations (total characters, word delimiters, and reading speed).
* ✅ Note entity immutability and property getters.
* ✅ `NoteCategory` safe parsing from persistent string values.
* ✅ `DateFormatter` relative time precision ("Just now", "X mins ago", "Yesterday").

To run tests with full coverage report:
```bash
flutter test --coverage
```

---

## 📖 Deep Learning & Interview Preparation

For a line-by-line, code-by-code educational walkthrough explaining **Why**, **When**, and **Architectural Decisions** in **Hinglish**, refer to:  
👉 **[README77.md](file:///c:/Users/Rohit/flutter-ass/note%20app/README77.md)**

---

## 📄 License
This project is open-source under the [MIT License](LICENSE).
