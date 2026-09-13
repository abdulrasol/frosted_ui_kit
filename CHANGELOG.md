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
