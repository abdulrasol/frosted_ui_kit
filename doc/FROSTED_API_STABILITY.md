# API Stability and Deprecation

## Public entry point

Application code should import `package:frosted_ui_kit/frosted_ui_kit.dart`.
The package entry point exports the supported widgets, theme data, performance
configuration, localization types, and generic authentication types. Internal
`src/` imports are not part of the compatibility contract.

The public entry point is intentionally grouped into these API areas:

| Area | Public types |
| --- | --- |
| Surfaces and layout | `BlurredCard`, `GlassBackdrop`, `BaseWidget`, `FrostedAdaptiveSurfaceLayout` |
| Navigation | `FrostedAppBar`, `FrostedNavigationBottomBar`, `FrostedNavbarController` |
| Buttons and loading | `AppButton`, `CircleButton`, `FrostedButton`, `FrostedAsyncButton`, `FrostLoadingButton` |
| Inputs and modals | `AppTextField`, `AppDialog`, `AppBottomSheet` |
| Design system | `FrostedThemeData`, `FrostedPerformance`, `FrostedPerformanceData` |
| Supporting components | tabs, steppers, list tiles, loading indicators, localization, and generic auth types |

The auth data and domain exports remain public for 1.x compatibility. New
applications should depend on the domain contracts and presentation widgets;
the data implementations are exported only to support existing integrations.
The authentication review and lifecycle ownership rules are documented in
[Authentication API Review](FROSTED_AUTH_API_REVIEW.md).

Authentication-only consumers may instead import the optional facade:

```dart
import 'package:frosted_ui_kit/auth.dart';
```

## Compatibility policy

Existing 1.x APIs are retained when a spelling or naming correction is made.
Deprecated APIs remain available and forward to the canonical implementation.

| Deprecated API | Canonical API |
| --- | --- |
| `CricleButton` | `CircleButton` |
| `BluredCard` | `BlurredCard` |
| `Cards.bluredCard` | `Cards.blurredCard` |
| `FrostedNavigationButtomBar` | `FrostedNavigationBottomBar` |

No deprecated API is removed as part of this compatibility pass.

## Migration guidance

Replace deprecated names when touching existing code. Projects that need a
gradual migration can keep the old names temporarily; behavior and layout are
unchanged because the aliases delegate to the same implementation.

Breaking changes require a changelog entry, migration notes, and a major
version.
