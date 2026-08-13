# Project Guidelines & Rules

This project follows strict development guidelines for code quality, Clean Architecture, reusable design components, and comprehensive documentation.

## 1. Automated Verification
- **Run `flutter analyze` after every code modification.**
- Any warnings, lints, or errors reported by `flutter analyze` must be resolved immediately before completing a task.

---

## 2. Architecture & Directory Structure
Follow **Clean Architecture** for all features under `lib/src/features/<feature_name>/`:

```
lib/src/features/<feature_name>/
├── domain/
│   ├── entities/        # Pure domain model objects
│   ├── repositories/    # Abstract repository interfaces (contracts)
│   └── usecases/        # [OPTIONAL] Single-responsibility use cases for complex business logic
├── data/
│   ├── models/          # Data transfer objects with JSON serialization (maps to entities)
│   ├── datasources/     # Remote (REST/PocketBase) & Local data sources
│   └── repositories/    # Repository implementation classes
└── presentation/
    ├── screen/          # UI Screen page widgets
    └── widgets/         # Modular sub-widgets split into separate files
```

### Architecture Rules:
- **Optional UseCases**: `usecases/` are optional and should only be created for complex/large business logic actions. For straightforward CRUD or repository calls, presentation controllers/screens can call repositories directly.
- **Split Big Widgets into Sub-Widgets**: Avoid creating monolithic screen files. Split complex screens and large UI components into small, focused sub-widgets saved in separate files under `presentation/widgets/`.

---

## 3. Standardized Shared Widgets
Use the standardized core shared widgets in `lib/src/shared/widgets/` for UI elements:

- **[BaseWidget](file:///Users/rasol/DevsTools/codes/flutter/starter/lib/src/shared/widgets/base_widget.dart)**: Foundational screen layout wrapper providing automatic glassmorphic app bar (`PrimaryAppBar`) integration.
- **[Inputs](file:///Users/rasol/DevsTools/codes/flutter/starter/lib/src/shared/widgets/inputs.dart)**: `AppTextField` widget and `Inputs` mixin (`textField(...)`) for text inputs with label, validation, and theme support.
- **[Cards](file:///Users/rasol/DevsTools/codes/flutter/starter/lib/src/shared/widgets/cards.dart)**: `BluredCard` widget and `Cards` mixin (`bluredCard(...)`) for glassmorphic containers.
- **[Buttons](file:///Users/rasol/DevsTools/codes/flutter/starter/lib/src/shared/widgets/buttons.dart)**: `CricleButton`, `AppButton` (supporting `AppButtonStyle` variants: `glass`, `colored`, `outlined`, `text`), and `Buttons` mixin (`appButton(...)`, `cricleButton(...)`, `backButton(...)`, `closeButton(...)`) for action buttons. All screens must use these standardized buttons instead of direct `ElevatedButton` or `TextButton`.
- **[BottomSheets](file:///Users/rasol/DevsTools/codes/flutter/starter/lib/src/shared/widgets/bottom_sheet.dart)**: `AppBottomSheet` widget and `BottomSheets` mixin (`showAppBottomSheet(...)`) for glassmorphic modal bottom sheets.
- **[Tabs](file:///Users/rasol/DevsTools/codes/flutter/starter/lib/src/shared/widgets/tabs.dart)**: `AppSlidingTabs` widget and `Tabs` mixin (`appSlidingTabs(...)`) for glassmorphic sliding segmented tabs.

> **Widget Extension Rule**: If a new reusable widget pattern is required, build it under `lib/src/shared/widgets/` following the established class + mixin pattern, document it completely with DartDoc, and reuse it consistently.

---

## 4. Documentation Standard
- **Comment Everything**: Every class, mixin, method, constructor, property, parameter, and utility function must be documented using standard DartDoc (`///`) format.
- Ensure IDE hover tooltips and auto-complete provide clear explanations and usage details for all APIs.

---

## 5. Localization (l10n) Standard
- **No Direct UI Text / Hardcoded Strings**: Never hardcode user-facing text strings directly inside UI widgets or controllers.
- All user-facing strings must be defined in `.arb` localization files under `lib/src/core/l10n/arb/` (e.g. `app_en.arb`, `app_ar.arb`).
- Always access localized strings in UI widgets via `context.l10n.<key>`.
