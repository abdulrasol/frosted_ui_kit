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

```dart
import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/shared/widgets/base_widget.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';

class HomeScreen extends StatelessWidget with Cards, Buttons {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      titleText: 'Frosted UI',
      child: Column(
        children: [
          bluredCard(
            child: const Text('Liquid Glass Container'),
          ),
          const SizedBox(height: 16),
          appButton(
            text: 'Glass Button',
            style: AppButtonStyle.glass,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
```

---

## 📚 Code Quality & Documentation

All components in `frosted_ui_kit` adhere to strict 100% DartDoc coverage standards for seamless developer experience and rich IDE hover tooltips.
