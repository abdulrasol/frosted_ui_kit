## 2.0.2

* Migrated Material component imports to `package:material_ui` to ensure seamless compatibility with Flutter 3.47+ and resolve deprecated member warnings.
* Updated `FrostedAppLocalizations` to properly integrate with `material_ui` and `cupertino_ui` localization delegates across supported locales (Arabic and English).
* Refined example catalog test and runtime dependencies for consistent localization support.

## 2.0.1

* Fixed app-bar flicker during top overscroll by honoring movement thresholds
  and ignoring direction-only, nested and horizontal scroll notifications.
* Unified glass rendering-mode precedence across cards and water-drop controls;
  explicit Full/Balanced now enable Android blur. Local performance scopes are
  captured by dialog and bottom-sheet routes.
* Expanded `cupertino_icons` compatibility to `>=1.0.8 <3.0.0`, including 2.0.0,
  without forcing existing consumers to upgrade immediately.

## 2.0.0

* **Breaking release**: Promoted the modern `Frosted UI Kit` API, theme
  tokens, adaptive modal foundations, performance presets, and accessibility
  improvements to the 2.0 stable line. Deprecated legacy names remain
  available for compatibility and are documented in the migration guide.
* **Branding**: Added the Frosted UI Kit glass-droplet logo and synchronized
  package and example-app brand assets across Android, iOS, macOS, and web.
* **API**: Added `FrostedThemeData`, `FrostedPerformance`, `FrostedButton`,
  `FrostedIconButton`, `FrostedAsyncButton`, and the optional `auth.dart`
  entry point for simpler adoption.
* **Stepper**: Added optional `stepBuilder` support for numbers, icons,
  images, Lottie, or any bounded custom widget, with completed/current/upcoming
  step state and accessibility semantics.
* **Modals**: Unified Dialog and BottomSheet adaptive layout for narrow
  screens, large text, keyboard insets, and destructive actions.
* **UI**: Added selected-state styling for list tiles and tabs, improved
  glass surface consistency, and refined the light/dark visual system.
* **Performance**: Added Android-friendly transparency fallbacks, shared
  surface tokens, repaint isolation, and documented profile baselines for
  Android and iOS.

* **API stability**: Added correctly-spelled `FrostedNavigationBottomBar` and
  deprecated the legacy `CricleButton`, `BluredCard`, and `Cards.bluredCard`
  names without removing them. Existing behavior remains compatible.
* **Tooling**: Added GitHub Actions CI for formatting, analysis, package and
  example tests, and pub package validation.
* **UI fix**: Aligned the default app-bar title surface with the shared
  water-drop control treatment on Android without changing custom colors.

## 1.2.0

* **Modals**: Unified Dialog and BottomSheet header/body/actions layout with responsive action stacking, keyboard-aware sheet sizing, localized default dialog actions, and destructive roles.
* **Performance**: Modal surfaces keep one shared blur, honor `FrostedPerformance.lite`, and use hard-edge sheet clipping by default for lower-end devices.
* **API**: Added `FrostedAsyncButton`, which owns Future loading, success, error, repeat-tap prevention, mounted checks, and optional error reporting without requiring a controller.
* **API**: Added `FrostedActionRole` so primary, secondary, and destructive meaning is independent from `AppButtonStyle`. Added `FrostedButton.destructive` and action-role theme tokens; existing buttons remain primary by default.
* **Feature**: Added `BaseWidget.hideAppBarOnScroll` and `appBarScrollBehavior` (`AppBarScrollBehavior.hideAll`, `AppBarScrollBehavior.collapseTitle`, and `AppBarScrollBehavior.none`) to allow the default floating `FrostedAppBar` to hide or collapse on downward scroll and reappear on upward scroll with smooth transitions and hysteresis control.
* **Feature**: Added subtle status bar background gradient via `BaseWidget.showStatusBarGradient` to improve legibility of system status bar icons when content scrolls underneath.
* **UI**: Refined the light status-bar gradient with a more visible dark tint toward the top instead of adding a pale scaffold-colored veil; dark-mode rendering is unchanged.
* **Fix**: Prevented bottom-edge bounce and ballistic settling from revealing a scroll-hidden app bar; real upward content movement still reveals it.
* **UI**: Introduced `CircleButtonStyle.waterDrop` as the default style for `CircleButton`, featuring a low-sigma liquid glass blur, animated press scaling, tooltips, and full accessibility semantics. Added support for `selected`, `selectedColor`, and `selectedIconColor`.
* **UI**: Added `AppButtonStyle.waterDrop` styling option for `AppButton`.
* **Fix**: Dialogs (`AppDialog`) are now fully keyboard-aware and scrollable with `SingleChildScrollView` constrained by viewport insets, preventing them from being obscured by on-screen keyboards. Added entrance scale/fade animation, `isDestructive` option on warning dialogs, and `autofocus` on input dialogs.
* **Loading UX**: `FrostLoadingButton` now preserves its width while loading by default, utilizes a compact indicator, and exposes accessible state labels (`loadingLabel`, `successLabel`, `errorLabel`). Added `collapseOnLoading: true` for the legacy collapsing behavior.
* **Performance**: Optimized floating navigation bar rendering by isolating repaints with `RepaintBoundary` and refined safe area padding.

## 1.1.5

* **Feature**: Added `Key? key` support to all widgets and mixin generator methods (`appButton`, `textField`, `showAppBottomSheet`, etc.) to fully support in-app tutorials, interactive tours (e.g., `showcaseview`), and automated testing.

## 1.1.4

* **Fix**: Renamed the generated localization class from `AppLocalizations` to `FrostedAppLocalizations` to prevent naming conflicts with applications that import this package and also use their own Flutter localizations.

## 1.1.3

* **UI Polish**: Fixed the Alpha Transparency fallback on Android to use a semi-solid `surface` color (`0.85` opacity) instead of a highly transparent `primaryColor` (`0.15` opacity). This ensures readable text and a luxurious frosted-like feel (similar to Telegram) on low-end devices without hardware blur.

## 1.1.2

* **Fix**: Shortened package description in `pubspec.yaml` to meet pub.dev scoring requirements (under 180 characters) to achieve 160/160 pub points.

## 1.1.1

* **Fix**: Updated README to properly render the demo GIF on pub.dev using standard Markdown and an absolute GitHub raw URL.

## 1.1.0

* **Smart Platform Adaptation**: `BlurredCard` now intelligently auto-adapts to the platform. It uses smooth hardware-accelerated `BackdropFilter` on iOS, and seamlessly falls back to smooth Alpha Transparency (`disableBlur: true`) on Android to maintain Telegram-like 60fps fluidity on all device tiers.
* **Performance Optimizations**: Reduced default blur sigma values to `5.0` and changed default `clipBehavior` to `Clip.hardEdge` for significantly better rendering performance.
* **Feature**: Added `onTabChanged` global callback to `FrostedNavigationButtomBar` for easier tab state management.

## 1.0.2

* Added GIF demo to the pub.dev main page.
* Exported `AuthScreen` as part of the public API and extracted `AuthView` for inline embedding.
* Fixed button animations and padding for `AppButton`, `CricleButton`, and `FrostLoadingButton`.
* Added feature flags and custom widget overrides (e.g., `customLoginButton`) to `AuthScreen` to allow disabling or customizing specific authentication flows.

## 1.0.1

* Updated README with full documentation URL and complete example code.

## 1.0.0

* Initial release of the `frosted_ui_kit` package.
* Added standard UI components: Glass Cards, Action Buttons, Sliding Tabs, Bottom Sheets, Inputs, Dialogs, Loading Indicator, List Tiles, and Stepper.
* Included generic Authentication module UI screens.
