# Frosted UI Kit — Quick Start

This guide takes a new Flutter project from installation to its first glass
surface without requiring knowledge of the repository's internal structure.

## 1. Install the package

Add the package from pub.dev to `pubspec.yaml`:

```yaml
dependencies:
  frosted_ui_kit: ^1.2.0
```

Then run `flutter pub get`.

For local package development only, use a path relative to your own app:

```yaml
dependencies:
  frosted_ui_kit:
    path: ../frosted_ui_kit
```

## 2. Copy-paste example

Place this file in `lib/main.dart`. It is self-contained and does not import
anything from the package's internal `example` application:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() => runApp(const QuickStartApp());

class QuickStartApp extends StatelessWidget {
  const QuickStartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FrostedPerformance.fromData(
      data: FrostedPerformance.balanced,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          extensions: const [FrostedThemeData.light],
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          extensions: const [FrostedThemeData.dark],
        ),
        themeMode: ThemeMode.system,
        home: const QuickStartPage(),
      ),
    );
  }
}

class QuickStartPage extends StatelessWidget {
  const QuickStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Welcome', style: TextStyle(fontSize: 28)),
              const SizedBox(height: 20),
              FrostedButton.primary(
                label: 'Open sheet',
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => const AppBottomSheet(
                    title: 'Quick action',
                    child: Text('Your glass surface is ready.'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FrostedButton.secondary(
                label: 'Show dialog',
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const AppDialog(
                    child: Text('Dialogs adapt to small screens and keyboards.'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

For standardized results, use the `Dialogs` and `BottomSheets` mixins and
helpers such as `showAppWarningDialog` and `showAppInputDialog`.

## 3. Configure the theme

Add `FrostedThemeData` to `ThemeData.extensions`. Local widget properties take
precedence over theme tokens, followed by the package defaults:

```dart
ThemeData(
  extensions: const [
    FrostedThemeData(
      dialogRadius: 28,
      buttonRadius: 18,
      dialogBlur: 10,
      spacing: 14,
    ),
  ],
)
```

Use `FrostedPerformance.full` for high-end devices, `balanced` as a practical
general default, and `lite` for low-end devices or reduced-transparency modes:

```dart
FrostedPerformance.fromData(
  data: FrostedPerformance.lite,
  child: MaterialApp(home: const QuickStartPage()),
)
```

`lite` disables `BackdropFilter` while preserving layout, interaction, and the
core translucent surface treatment.

## 4. Configure localization

Add `flutter_localizations` to the application and provide delegates and
supported locales:

```dart
MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
)
```

The package provides defaults for common actions such as `confirm`, `cancel`,
and `ok`. Applications can pass their own localized strings to dialog APIs;
the package does not force a single language.

## 5. Choose the right component

| Need | Recommended component | Typical use |
|---|---|---|
| Regular action | `FrostedButton.primary` | Save, continue, send |
| Safe or cancel action | `FrostedButton.secondary` | Back, cancel, close |
| Dangerous action | `FrostedButton.destructive` | Delete, disable, remove |
| Icon-only action | `FrostedIconButton` or `CircleButton` | Settings, back, add |
| Async operation | `FrostedAsyncButton` | Save or upload with feedback |
| Text input | `AppTextField` or `showAppInputDialog` | Forms and search |
| Confirmation | `showAppWarningDialog` | Decisions requiring confirmation |
| Error message | `showAppErrorDialog` | Failed operations and warnings |
| Bottom content | `showAppBottomSheet` | Options and details |
| Full screen layout | `BaseWidget` | Floating app bar and scroll behavior |

## 6. Migration from older APIs

No migration is required. Existing names and mixins remain supported,
including `BluredCard` and the legacy button APIs. For new code:

- Prefer `BlurredCard`; `BluredCard` remains a compatibility alias.
- Prefer `FrostedButton` for everyday actions and `AppButton` for advanced customization.
- Pass `role: FrostedActionRole.destructive` instead of inferring risk from color.
- Use `FrostedPerformance` instead of disabling `BackdropFilter` per component.
- Use `showAppInputDialog` or `AppDialog(actions: ...)` for keyboard-aware layouts.

For advanced details, see [FrostedThemeData](FROSTED_THEME.md),
[shared glass surfaces](GLASS_SURFACES.md), and
[adaptive dialogs and bottom sheets](FROSTED_ADAPTIVE_MODALS.md).
