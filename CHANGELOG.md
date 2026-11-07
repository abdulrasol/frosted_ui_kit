## 1.2.0

* **Feature**: Added `BaseWidget.hideAppBarOnScroll` and `appBarScrollBehavior` (`AppBarScrollBehavior.hideAll`, `AppBarScrollBehavior.collapseTitle`, and `AppBarScrollBehavior.none`) to allow the default floating `FrostedAppBar` to hide or collapse on downward scroll and reappear on upward scroll with smooth transitions and hysteresis control.
* **Feature**: Added subtle status bar background gradient via `BaseWidget.showStatusBarGradient` to improve legibility of system status bar icons when content scrolls underneath.
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
