# ❄️ Frosted UI Kit (`frosted_ui_kit`)

A modern, highly-customizable Flutter UI kit inspired by **Apple's Liquid Glass** aesthetic and **Telegram's modern Android redesign**. `frosted_ui_kit` brings translucent backdrops, soft backdrop blurs, realistic glossy borders, fluid animations, and high-level control surfaces to your Flutter applications.

---

## ✨ Features

- 🧊 **Glassmorphism & Liquid Aesthetics**: Soft backdrop blurs (`BackdropFilter`), custom translucent depth, realistic borders, and subtle shadows.
- ⚡ **Telegram-Style Fluidity**: Dynamic sliding tabs, responsive micro-animations, floating rounded containers, and interactive control surfaces.
- 📱 **Standardized Component Suite**:
  - **`BaseWidget`**: Foundational layout wrapper with integrated glassmorphic app bar (`PrimaryAppBar`).
  - **`BluredCard` & `Cards`**: Glassmorphic container widgets with customizable blur intensity.
  - **`AppButton` & `CricleButton`**: Multi-styled buttons supporting `glass`, `colored`, `outlined`, and `text` styles.
  - **`AppSlidingTabs` & `Tabs`**: Telegram-inspired smooth sliding segmented controls.
  - **`AppBottomSheet` & `BottomSheets`**: Glassmorphic modal bottom sheets.
  - **`AppTextField` & `Inputs`**: Standardized input fields with validation and theme support.
- 🌍 **Full Localization & Theme Ready**: Built to work seamlessly with `flutter_localizations` and dark/light themes.

---

## 🚀 Getting Started

Add `frosted_ui_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  frosted_ui_kit:
    path: ./ # Or from pub.dev / github repository
```

Import the package:

```dart
import 'package:frosted_ui_kit/frosted_ui_kit.dart';
```

---

## 🛠️ Usage Example

Here is a full playground application demonstrating how to initialize and use the `frosted_ui_kit` components:

```dart
import 'package:flutter/material.dart';
import 'src/catalog_home_screen.dart';

void main() {
  runApp(const MySandboxApp());
}

/// Playground application for testing and extending [frosted_ui_kit] components.
class MySandboxApp extends StatefulWidget {
  const MySandboxApp({super.key});

  static MySandboxAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MySandboxAppState>()!;

  @override
  State<MySandboxApp> createState() => MySandboxAppState();
}

class MySandboxAppState extends State<MySandboxApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frosted UI Kit Sandbox',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1F1C2C),
      ),
      home: const CatalogHomeScreen(),
    );
  }
}
```

---

## 📚 Code Quality & Documentation

All components in `frosted_ui_kit` adhere to strict 100% DartDoc coverage standards for seamless developer experience and rich IDE hover tooltips.

For the complete technical API index and visual catalog, please visit the [Full Documentation](https://subultech.top/packages/frostuikit).
