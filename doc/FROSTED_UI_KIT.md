# ❄️ Frosted UI Kit Catalog & API Indexing

Welcome to the **`frosted_ui_kit`** Widget Catalog and Technical API Index. This document provides a complete visual reference, parameter guide, and code snippets for all components in the library.

---

## 📊 API & Widget Catalog Index

| Component | File / Module | Primary Class | Mixin Shortcut | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Input Fields** | `inputs.dart` | `AppTextField` | `emailField`, `passwordField`, `nameField`, `textField` | Pre-configured glassmorphic inputs with auto-obscure toggle, icons, and validation. |
| **Glass Cards** | `cards.dart` | `BlurredCard` | `blurredCard` (`bluredCard`) | Translucent card container with backdrop blur filter (`sigmaX: 10, sigmaY: 10`). |
| **Action Buttons** | `buttons.dart` | `AppButton`, `CircleButton`, `AppFloatingActionButton` | `appButton`, `circleButton`, `backButton`, `appFab` | Multi-styled buttons (`glass`, `colored`, `outlined`, `text`) and floating action buttons. |
| **Sliding Tabs** | `tabs.dart` | `AppSlidingTabs` | `appSlidingTabs` | Telegram-style animated sliding segmented control with RTL support. |
| **Bottom Sheets** | `bottom_sheet.dart` | `AppBottomSheet` | `showAppBottomSheet` | Modal bottom sheet with backdrop blur filter and drag indicator. |
| **Dialogs** | `dialogs.dart` | `AppDialog` | `showAppWarningDialog`, `showAppErrorDialog`, `showAppInputDialog` | Pop-up glassmorphic dialogs for warnings, errors, and input prompts. |
| **List Tiles** | `list_tile.dart` | `FrostedListSection` | *N/A* | Grouped, glassmorphic settings-style lists with integrated dividers. |
| **App Bars** | `app_bar.dart` | `FrostedAppBar` | *N/A* | Modern, glassmorphic primary application bar with auto-fitting title. |
| **Navigation Bars** | `navigation_bar.dart` | `FrostedNavigationButtomBar`, `FrostedNavbarController` | *N/A* | Glassmorphic bottom navigation bar with animated tab selection. |
| **Screen Layout** | `base_widget.dart` | `BaseWidget` | *Scaffold Wrapper* | Screen wrapper providing integrated `FrostedAppBar` and `FrostedNavigationButtomBar`. |
| **Auth Feature** | `features/auth/` | `AuthScreen`, `AuthController` | *Complete Flow* | Pure UI authentication screens (`login`, `register`, `reset`, `verify`). |

---

## 🧩 Widget Catalog & Detailed API Guide

### 1. 📝 Input Fields (`AppTextField` & `Inputs`)
Modern glassmorphic text input fields supporting pre-configured presets, automatic obscure text toggles for passwords, custom error feedback, and label support.

#### Supported Preset Variants (`AppTextFieldType`):
- `AppTextFieldType.email`: Auto-configured with email keyboard, email icon, and validation.
- `AppTextFieldType.password`: Auto-configured with obscure text mask and interactive eye toggle button.
- `AppTextFieldType.name`: Auto-configured with word capitalization and person icon.
- `AppTextFieldType.phone`: Auto-configured with numeric phone keypad.
- `AppTextFieldType.number`: Auto-configured with numeric keypad.
- `AppTextFieldType.multiline`: Text area supporting multiline input.
- `AppTextFieldType.text`: Standard generic text field.

#### API & Key Parameters:
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `type` | `AppTextFieldType` | `text` | Field preset variant controlling defaults. |
| `label` | `String?` | `null` | Label text rendered above input box. |
| `placeholder` | `String?` | `null` | Hint text displayed when field is empty. |
| `controller` | `TextEditingController?` | `null` | Controller for managing text state. |
| `obscureText` | `bool?` | *Auto for password* | Whether to mask text input. |
| `prefix` | `Widget?` | *Auto based on type* | Leading icon or widget. |
| `suffix` | `Widget?` | *Eye icon for password* | Trailing icon or widget. |
| `validator` | `FormFieldValidator<String>?` | `null` | Validation function for Form state. |

#### Code Usage Examples:

##### Email & Password Shortcuts via Mixin:
```dart
class LoginSampleWidget extends StatelessWidget with Inputs {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        emailField(
          context: context,
          controller: _emailController,
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 14),
        passwordField(
          context: context,
          controller: _passwordController,
        ),
      ],
    );
  }
}
```

---

### 2. 🧊 Glass Cards (`BlurredCard` & `Cards`)
Translucent glassmorphic container leveraging Flutter's `BackdropFilter` and `ClipRRect` to create realistic glass depth.

#### API & Key Parameters:
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `child` | `Widget` | *Required* | Child content inside the glass card. |
| `borderRadius` | `BorderRadiusGeometry?` | `BorderRadius.circular(radius)` | Custom border radius geometry. |
| `radius` | `double?` | `50` | Circular corner radius when `borderRadius` is omitted. |
| `height` | `double?` | `null` | Explicit height for the container. |
| `width` | `double?` | `null` | Explicit width for the container. |
| `padding` | `EdgeInsetsGeometry?` | `null` | Inner padding surrounding child. |
| `margin` | `EdgeInsetsGeometry?` | `null` | Outer margin around card box. |
| `border` | `BoxBorder?` | `AppThemes.border` | Translucent border stroke decoration. |

#### Code Usage Example:
```dart
class CardSampleWidget extends StatelessWidget with Cards {
  @override
  Widget build(BuildContext context) {
    return blurredCard(
      context: context,
      padding: const EdgeInsets.all(16),
      child: const Text('Frosted Glass Container'),
    );
  }
}
```

---

### 3. 🔘 Action Buttons (`AppButton`, `CircleButton`, `AppFloatingActionButton` & `Buttons`)
A comprehensive set of action buttons supporting 4 visual style variants (`AppButtonStyle`). It also includes `AppFloatingActionButton` which acts as a versatile FAB (icon only, text only, or extended icon + text).

#### Supported Style Variants (`AppButtonStyle`):
- `AppButtonStyle.glass`: Translucent glassmorphic button with backdrop blur.
- `AppButtonStyle.colored`: Solid primary accent filled button.
- `AppButtonStyle.outlined`: Transparent button with primary border outline.
- `AppButtonStyle.text`: Subtle text-only button without border or card fill.

#### API & Key Parameters:
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `title` | `String?` | `null` | Button label text string. |
| `icon` | `IconData?` | `null` | Icon displayed beside title label. |
| `style` | `AppButtonStyle` | `glass` | Visual style variant choice. |
| `isLoading` | `bool` | `false` | Displays progress indicator when true. |
| `isDisabled` | `bool` | `false` | Disables touch interactions and dims colors. |
| `onPressed` | `VoidCallback?` | `null` | Tap callback handler. |
| `height` | `double?` | `48` | Fixed button height. |

#### Code Usage Examples:

```dart
class ButtonSampleWidget extends StatelessWidget with Buttons {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Glass Button
        appButton(
          context: context,
          title: 'Glass Action',
          style: AppButtonStyle.glass,
          onPressed: () {},
        ),
        const SizedBox(height: 10),
        // Colored Button with Loading
        appButton(
          context: context,
          title: 'Submit',
          style: AppButtonStyle.colored,
          isLoading: false,
          onPressed: () {},
        ),
        const SizedBox(height: 10),
        // Navigation Back Button
        Row(
          children: [
            backButton(context),
            const SizedBox(width: 8),
            closeButton(context),
          ],
        ),
        const SizedBox(height: 10),
        // Extended Floating Action Button
        appFab(
          context: context,
          icon: Icons.add,
          title: 'Create',
          onPressed: () {},
        ),
      ],
    );
  }
}
```

---

### 3.1 🔄 Animated Loading Buttons (`FrostLoadingButton`)
A dynamic button wrapper built on `AppButton` that handles transitions between multiple states (idle, loading, success, error) using Lottie animations. 

#### Available States (`FrostLoadingButtonState`):
- `idle`: Displays the normal text and icon.
- `loading`: Shrinks (or maintains width) to show an `AppLoadingIndicator` built with Lottie.
- `success`: Shows a success icon with customizable success color.
- `error`: Shows an error icon with customizable error color.

#### Code Usage Example:
```dart
class LoadingButtonSample extends StatelessWidget {
  final FrostLoadingButtonController controller = FrostLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return FrostLoadingButton(
      controller: controller,
      title: 'Submit Data',
      icon: Icons.upload,
      onPressed: () async {
        controller.start(); // Switch to loading
        await Future.delayed(const Duration(seconds: 2));
        controller.success(); // Switch to success
      },
    );
  }
}
```

---

### 4. 🗂️ Sliding Segmented Tabs (`AppSlidingTabs` & `Tabs`)
Telegram-inspired sliding tab selector with an animated pill indicator that smoothly slides between tab options. Fully RTL-aware.

#### API & Key Parameters:
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `tabs` | `List<String>` | *Required* | List of tab label strings. |
| `selectedIndex` | `int` | *Required* | Currently active tab index. |
| `onTabChanged` | `ValueChanged<int>` | *Required* | Callback triggered when a tab is tapped. |
| `height` | `double` | `46` | Total height of tabs container. |
| `activeTextStyle` | `TextStyle?` | *Bold OnPrimary* | Custom style for selected tab text. |
| `inactiveTextStyle` | `TextStyle?` | *OnSurfaceVariant* | Custom style for inactive tab text. |

#### Code Usage Example:
```dart
class TabSampleWidget extends StatefulWidget with Tabs {
  @override
  State<TabSampleWidget> createState() => _TabSampleWidgetState();
}

class _TabSampleWidgetState extends State<TabSampleWidget> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.appSlidingTabs(
      context: context,
      tabs: const ['Tab One', 'Tab Two', 'Tab Three'],
      selectedIndex: _tabIndex,
      onTabChanged: (index) => setState(() => _tabIndex = index),
    );
  }
}
```

---

### 5. 📑 Glassmorphic Bottom Sheets (`AppBottomSheet` & `BottomSheets`)
Translucent backdrop filter bottom sheet modal with drag handle indicator and automatic keyboard inset padding (`viewInsets`).

#### API & Key Parameters:
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `context` | `BuildContext` | *Required* | Build context for navigator. |
| `child` | `Widget` | *Required* | Sheet content widget. |
| `title` | `String?` | `null` | Optional header title string with close button. |
| `isScrollControlled` | `bool` | `true` | Allows sheet to resize with keyboard. |

#### Code Usage Example:
```dart
class SheetSampleWidget extends StatelessWidget with BottomSheets {
  void _openSheet(BuildContext context) {
    showAppBottomSheet(
      context: context,
      title: 'Modal Settings',
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('BottomSheet Content Here'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _openSheet(context),
      child: const Text('Open Sheet'),
    );
  }
}
```

---

### 6. 💬 Glassmorphic Dialogs (`AppDialog` & `Dialogs`)
Glassmorphic popup dialogs designed to alert the user, ask for confirmation, or prompt for text input.

#### Available Mixin Methods:
- `showAppWarningDialog`: Shows a warning dialog returning a boolean.
- `showAppErrorDialog`: Shows an error dialog with an OK button.
- `showAppInputDialog`: Shows an input dialog returning the submitted string, with support for validation.

#### Shared API & Key Parameters:
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `context` | `BuildContext` | *Required* | Build context for navigator. |
| `title` | `String?` | `null` | Optional header title string. |
| `description` | `String?` | `null` | Optional description or body text. |
| `icon` | `IconData?` | *Varies* | Optional top icon. Set to `null` to hide. |
| `iconColor` | `Color?` | `error` | Theme color applied to the icon and its background. |
| `confirmText` | `String` | *Varies* | Label for the positive/submit button. |
| `cancelText` | `String` | `Cancel` | Label for the negative button (if available). |
| `validator` | `FormFieldValidator<String>?`| `null` | Validation logic for `showAppInputDialog`. |
| `titleColor` | `Color?` | `null` | Custom color for the title text. |
| `descriptionColor` | `Color?` | `null` | Custom color for the description text. |
| `confirmButtonColor` | `Color?` | `null` | Custom background color for the confirm button. |
| `confirmTextColor` | `Color?` | `null` | Custom text color for the confirm button. |
| `cancelButtonColor` | `Color?` | `null` | Custom background color for the cancel button. |
| `cancelTextColor` | `Color?` | `null` | Custom text color for the cancel button. |

#### Code Usage Example:
```dart
class DialogSampleWidget extends StatelessWidget with Dialogs {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await showAppInputDialog(
          context: context,
          title: 'Enter Name',
          description: 'Please enter your full name below.',
          hintText: 'John Doe',
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        );
      },
      child: const Text('Open Input Dialog'),
    );
  }
}
```

---

### 7. ⏳ Loading Indicator (`AppLoadingIndicator`)
A generic glassmorphic loading indicator built on a Lottie animation (`assets/lottie/loading.json`), acting as a drop-in replacement for standard `CircularProgressIndicator`.

#### Available Methods in `Dialogs` mixin:
- `showAppLoadingDialog`: Shows a glassmorphic non-dismissible loading dialog featuring the `AppLoadingIndicator` and an optional message.

#### Code Usage Example:
```dart
class LoadingSampleWidget extends StatelessWidget with Dialogs {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Raw indicator
        const AppLoadingIndicator(size: 40),
        // Dialog wrapper
        ElevatedButton(
          onPressed: () => showAppLoadingDialog(
            context: context, 
            message: 'Loading...', 
          ),
          child: const Text('Show Loading Dialog'),
        ),
      ],
    );
  }
}
```

---

### 7. 📋 Glassmorphic List Tiles (`FrostedListSection` & `FrostedListTile`)
A glassmorphic list section that groups multiple list tiles together. It automatically handles rounded corners and dividers between tiles, mimicking native iOS settings menus but with a modern glass look.

#### API & Key Parameters:
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `header` | `Widget?` | `null` | Header widget displayed above the section. |
| `children` | `List<Widget>` | *Required* | List of `FrostedListTile`s. |
| `margin` | `EdgeInsetsGeometry` | `EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)` | Margin around the section. |
| `separatorColor` | `Color?` | `dividerColor` | Color of the divider line between tiles. |

#### Code Usage Example:
```dart
class SettingsSampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FrostedListSection(
      header: const Text('Preferences'),
      children: [
        FrostedListTile(
          title: const Text('Notifications'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        FrostedListTile(
          title: const Text('Privacy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    );
  }
}
```

---

### 8. 🖼️ Screen Scaffold Layout (`BaseWidget`, `FrostedAppBar` & `FrostedNavigationButtomBar`)
Screen scaffold wrapper ensuring consistent layout padding, safe areas, and a floating glass app bar (`FrostedAppBar`) as well as an optional floating glass bottom navigation bar (`FrostedNavigationButtomBar`).

#### API & Key Parameters (`BaseWidget`):
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `child` | `Widget` | *Required* | Body content widget. |
| `title` | `String?` | `null` | Title displayed inside the glass `FrostedAppBar`. |
| `actions` | `List<Widget>?` | `null` | End-aligned action icons in `FrostedAppBar`. |
| `isHideAppbar` | `bool` | `false` | Hides the top app bar when true. |
| `bottomNavigationBar` | `Widget?` | `null` | Optional bottom bar component. |

#### API & Key Parameters (`FrostedNavigationButtomBar`):
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `controller` | `FrostedNavbarController` | *Required* | Controller managing the active tab index. |
| `items` | `List<FrostedNavbarItem>` | *Required* | List of tab items to display (data class). |
| `action` | `Widget?` | `null` | Optional action widget (e.g. FAB) displayed at the end. |

#### Code Usage Example:
```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final FrostedNavbarController _navController = FrostedNavbarController();

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: 'Dashboard',
      actions: [
        IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
      ],
      bottomNavigationBar: FrostedNavigationButtomBar(
        controller: _navController,
        items: [
          FrostedNavbarItem(icon: Icons.home, title: 'Home'),
          FrostedNavbarItem(icon: Icons.search, title: 'Search', badgeCount: 3),
        ],
        action: appFab(context: context, icon: Icons.add, onPressed: () {}),
      ),
      child: const Center(child: Text('Screen Content')),
    );
  }
}
```

---

### 7. 🚦 Glassmorphic Stepper (`FrostedStepper` & `Steppers`)
A multi-step progress indicator designed with the liquid glass aesthetic. Supports both horizontal and vertical orientations.

#### Available Mixin Methods:
- `appStepper`: Returns a `FrostedStepper` instance.

#### API & Key Parameters:
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `controller` | `FrostedStepperController` | *Required* | Manages the current step and navigation. |
| `direction` | `FrostedStepperDirection` | `horizontal` | Layout direction (`horizontal` or `vertical`). |
| `activeColor` | `Color?` | `primary` | Color for active steps and completed lines. |
| `inactiveColor` | `Color?` | `outlineVariant` | Color for inactive steps and remaining lines. |
| `textColor` | `Color?` | `onPrimary` | Color for the step number text. |
| `lineSize` | `double` | `2` | Thickness of the connecting line. |
| `stepSize` | `double` | `32` | Diameter of the step circle. |

#### Code Usage Example:
```dart
class StepperSampleWidget extends StatefulWidget {
  @override
  State<StepperSampleWidget> createState() => _StepperSampleWidgetState();
}

class _StepperSampleWidgetState extends State<StepperSampleWidget> with Steppers {
  late FrostedStepperController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FrostedStepperController(
      steps: 3,
      stepsList: ['Cart', 'Address', 'Payment'],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return appStepper(
      controller: _controller,
      direction: FrostedStepperDirection.horizontal,
    );
  }
}
```

---

## 🔐 Generic Authentication Catalog (`features/auth`)

The authentication module provides ready-to-use pure UI screens and forms for sign-in, registration, password recovery, and email verification:

- **`AuthScreen`**: Complete unified page featuring sliding tabs between Sign In and Register.
- **`LoginFormWidget`**: Standalone sign-in form using `emailField` and `passwordField`.
- **`RegisterFormWidget`**: Account creation form with name, email, password, and confirm password.
- **`ForgotPasswordFormWidget`**: Reset email request form.
- **`ResetPasswordFormWidget`**: Token verification and new password entry form.
- **`VerifyEmailFormWidget`**: Email token confirmation form.
- **`AuthController`**: Pure UI state manager for view modes, loading states, and user feedback.

```dart
// Example embedding AuthScreen with callbacks:
AuthScreen(
  onLoginSuccess: () {
    Navigator.of(context).pushReplacementNamed('/home');
  },
  onRegisterSuccess: () {
    // Perform post-registration navigation
  },
);
```
