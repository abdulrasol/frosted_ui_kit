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

- **[BaseWidget](lib/src/shared/widgets/base_widget.dart)**: Foundational screen layout wrapper providing automatic glassmorphic app bar (`FrostedAppBar`) integration.
- **[Inputs](lib/src/shared/widgets/inputs.dart)**: `AppTextField` widget and `Inputs` mixin (`textField(...)`, `emailField(...)`, `passwordField(...)`, `nameField(...)`). Supports dynamic field types via `AppTextFieldType` (`text`, `email`, `password`, `name`, `phone`, `multiline`, `number`) with automatic keyboard types, obscure toggles, icons, validation, and theme support.
- **[Cards](lib/src/shared/widgets/cards.dart)**: `BluredCard` widget and `Cards` mixin (`bluredCard(...)`) for glassmorphic containers.
- **[Buttons](lib/src/shared/widgets/buttons.dart)**: `CricleButton`, `AppButton`, `AppFloatingActionButton`, and `Buttons` mixin (`appButton(...)`, `cricleButton(...)`, `backButton(...)`, `closeButton(...)`, `appFab(...)`) for action buttons. All screens must use these standardized buttons instead of direct `ElevatedButton` or `TextButton`.
- **[Loading Buttons](lib/src/shared/widgets/loading_button.dart)**: `FrostLoadingButton` widget driven by `FrostLoadingButtonController` for animated state transitions (idle, loading, success, error) with integrated Lottie support.
- **[BottomSheets](lib/src/shared/widgets/bottom_sheet.dart)**: `AppBottomSheet` widget and `BottomSheets` mixin (`showAppBottomSheet(...)`) for glassmorphic modal bottom sheets.
- **Dialogs**: `AppDialog` widget and `Dialogs` mixin (`showAppWarningDialog(...)`, `showAppErrorDialog(...)`, `showAppInputDialog(...)`, `showAppLoadingDialog(...)`) for glassmorphic popup dialogs.
- **[Loading](lib/src/shared/widgets/loading.dart)**: `AppLoadingIndicator` generic Lottie-based loading animation to replace `CircularProgressIndicator`.
- **[Steppers](lib/src/shared/widgets/stepper.dart)**: `FrostedStepper` widget and `Steppers` mixin (`appStepper(...)`) for glassmorphic multi-step progress indicators (horizontal & vertical).
- **[Tabs](lib/src/shared/widgets/tabs.dart)**: `AppSlidingTabs` widget and `Tabs` mixin (`appSlidingTabs(...)`) for glassmorphic sliding segmented tabs.
- **[ListTiles](lib/src/shared/widgets/list_tile.dart)**: `FrostedListSection` and `FrostedListTile` for creating grouped, glassmorphic settings-style lists with integrated dividers.
- **App Bars**: `FrostedAppBar` (in `app_bar.dart`) for floating, glassmorphic top navigation.
- **Navigation Bars**: `FrostedNavigationButtomBar` (in `navigation_bar.dart`) for floating, glassmorphic bottom navigation with animated bouncy active states and badge support (`badgeCount`) managed via `FrostedNavbarController`.

> **Widget Extension Rule**: If a new reusable widget pattern is required, build it under `lib/src/shared/widgets/` (or within the `frosted_ui_kit` package) following the established class + mixin pattern, document it completely with DartDoc, and reuse it consistently.

---

## 4. `frosted_ui_kit` Package Identity & Aesthetic Rules
The UI components in this repository constitute **`frosted_ui_kit`**, a Flutter design system heavily inspired by:
- **Apple Liquid Glass / Glassmorphism**: Translucent backdrops, soft backdrop blurs, realistic borders, subtle shadows, and layered depth.
- **Telegram (Modern Android UI)**: Fluid navigation, sliding tabs, rounded control surfaces, smooth micro-interactions, and reactive feedback.

---

## 5. Generic Authentication Module Standard (`lib/src/features/auth`)
- **Abstract & App-Agnostic**: All authentication entities (`UserEntity`), models (`UserModel`), datasources (`AuthRemoteDataSource`), and screens (`AuthScreen`) MUST remain 100% generic without application-specific legacy flags.
- **Custom Attributes**: Any app-specific backend fields must be handled dynamically via `customData: Map<String, dynamic>?`.

---

## 6. Mandatory Comprehensive Documentation Standard
- **100% DartDoc Coverage**: Every single class, enum, mixin, widget, property, method, callback, parameter, and extension created or modified in `frosted_ui_kit` MUST be fully documented using standard DartDoc (`///`) format.
- **Project Documentation (`doc/`)**: Maintain detailed technical markdown guides in [doc/FROSTED_UI_KIT.md](doc/FROSTED_UI_KIT.md). Any architectural change or component addition must be recorded in this documentation.
- **IDE Hover Clarity**: Ensure tooltips and auto-complete provide rich contextual explanations for developers using `frosted_ui_kit`.

---

## 7. Localization (l10n) Standard
- **No Direct UI Text / Hardcoded Strings**: Never hardcode user-facing text strings directly inside UI widgets or controllers.
- All user-facing strings must be defined in `.arb` localization files under `lib/src/core/l10n/arb/` (e.g. `app_en.arb`, `app_ar.arb`).
- Always access localized strings in UI widgets via `context.l10n.<key>`.


