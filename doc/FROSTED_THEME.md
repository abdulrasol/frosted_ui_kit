# Central theme tokens

Import `frosted_ui_kit.dart` and install `FrostedThemeData` in
`ThemeData.extensions`. Light/dark presets inherit colors from the matching
Material ColorScheme instead of creating separate color schemes per widget.

```dart
final theme = ThemeData(
  extensions: const [FrostedThemeData(
    surfaceColor: Color(0xFFE6F0F4),
    contentColor: Color(0xFF172B36),
    borderColor: Color(0x55778899),
    buttonRadius: 20,
    dialogRadius: 28,
    glassBlur: 4,
    dialogBlur: 10,
    appBarBlur: 4,
    spacing: 12,
    motionDuration: Duration(milliseconds: 180),
  )],
);
```

Resolution: explicit local property, then theme token, then existing default.
Generic cards inherit surface/border/radius/blur. Regular buttons inherit
radius and foreground; water-drop surfaces inherit tint/blur. AppBar inherits
blur, and Dialog inherits surface/opacity/radius/blur/spacing/entrance duration.
Tabs and input fields inherit buttonRadius and their own blur tokens. Bottom
sheets inherit surface tint, sheetBlur and dialogRadius + 4 for the top corners.
Navigation inherits borderColor, navigationBlur and twice buttonRadius. Tabs
use motionDuration for text and 1.25 times that duration for sliding feedback.
A filled primary button still uses its ColorScheme primary. Local style
overrides remain available; fixed functional measurements such as drag handles
and icon sizes intentionally remain separate from design tokens.

Action roles can be customized independently from button appearance with
`primaryActionColor`/`onPrimaryActionColor`,
`secondaryActionColor`/`onSecondaryActionColor`, and
`destructiveActionColor`/`onDestructiveActionColor`. Null role colors inherit
the matching primary, secondary, or error pair from Material `ColorScheme`.
The resolution order is local widget color, role token, then ColorScheme.
Disabled colors derive from `onSurface`; interaction overlays derive from the
resolved role accent.

Component blur defaults preserve existing appearances: inputBlur 10, tabsBlur
10, sheetBlur 15, navigationBlur 20. For a lighter recipe:

```dart
const FrostedThemeData(
  inputBlur: 4,
  tabsBlur: 4,
  sheetBlur: 8,
  navigationBlur: 6,
)
```

Instances are immutable and const defaults are reused. Lookup uses the normal
Theme inherited dependency; no additional controller, timer or listener is
created. `lerp` supports theme transitions with endpoint fast paths. `copyWith`
retains nullable colors when omitted; construct a fresh instance to clear them.
Blur performance settings remain independent of design tokens. No device FPS
or GPU improvement is claimed without profiling.

Compatibility: constructor calls remain supported. `BlurredCard.sigmaX/Y`,
`FrostedAppBar.sigmaX/Y`, and `AppDialog.surfaceOpacity/blurSigma` are now
nullable overrides so an omitted value can inherit the theme. Code directly
reading these public fields must handle null. Existing defaults and geometry
goldens pass when no custom extension is installed.

The sigmaX/Y override fields and helper arguments on inputs, tabs and sheets
are nullable too, to distinguish omitted values from explicit overrides. Their
effective defaults are unchanged. Code reading these fields should resolve
them against the matching token.

Verification: copyWith, lerp endpoints/interpolation, fallback, local surface
override and button radius; complete widget/golden suite. Extend token coverage
tests alongside further component migrations.
