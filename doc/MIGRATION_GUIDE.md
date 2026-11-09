# Migration Guide

This guide describes the safe migration path for existing `frosted_ui_kit`
applications. The 1.x compatibility policy keeps deprecated APIs available;
migrations can therefore be applied incrementally.

## Import boundary

Use the package entry point for application code:

```dart
import 'package:frosted_ui_kit/frosted_ui_kit.dart';
```

Do not import `lib/src/...` paths directly. They are implementation details and
may change without preserving private structure.

## Naming corrections

Replace legacy spellings when touching a file:

| Before | After |
| --- | --- |
| `CricleButton` | `CircleButton` |
| `BluredCard` | `BlurredCard` |
| `bluredCard(...)` | `blurredCard(...)` |
| `FrostedNavigationButtomBar` | `FrostedNavigationBottomBar` |

The old names remain available in 1.x and have the same behavior.

## Performance configuration

Wrap the application or a subtree in `FrostedPerformance` when you need an
explicit rendering policy:

```dart
FrostedPerformance.fromData(
  data: FrostedPerformance.android,
  child: MaterialApp(home: MyHomePage()),
)
```

Use `full` for maximum glass fidelity, `balanced` for reduced blur, `android`
for scrolling-heavy Android screens without backdrop readback, and `lite` for
the lowest raster cost. Changing the preset does not change layout or
semantics.

## Buttons

Visual appearance and action meaning are independent. Keep destructive meaning
explicit when changing button styles:

```dart
FrostedButton.destructive(
  label: 'Delete',
  onPressed: deleteItem,
)
```

Use `FrostedAsyncButton` for a Future-returning action when loading, success,
error, repeat-tap prevention, and mounted checks should be managed by the
widget. Keep `FrostLoadingButtonController` for manual state transitions.

## Dialogs and bottom sheets

The shared adaptive surface layout now handles narrow screens, large text,
keyboard insets, scrollable content, and destructive action emphasis. Existing
dialog and bottom-sheet helpers remain source-compatible. Prefer the shared
helpers over direct `showDialog` or `showModalBottomSheet` calls when adopting
the kit's visual and accessibility behavior.

## App bars and navigation

`BaseWidget.hideAppBarOnScroll` and `appBarScrollBehavior` are opt-in. Existing
screens keep the previous always-visible app bar behavior unless a scroll mode
is explicitly selected.

## Release checklist

Before upgrading a production app:

1. Run `flutter analyze` and the application test suite.
2. Check RTL, large text, keyboard, and narrow-screen modal layouts.
3. Run a profile scroll test on representative Android and iOS hardware.
4. Replace deprecation warnings incrementally.
5. Review `CHANGELOG.md` for visual or behavior changes in the target release.
