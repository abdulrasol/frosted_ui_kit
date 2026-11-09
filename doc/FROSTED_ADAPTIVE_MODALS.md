# Adaptive Dialogs and Bottom Sheets

Dialogs and bottom sheets share `FrostedAdaptiveSurfaceLayout`, which divides a
modal surface into optional header, scrollable body, and optional actions.
This keeps behavior consistent across compact phones, tablets, large text,
RTL, and keyboard-visible layouts.

## Layout behavior

On a regular viewport the header and actions remain visible while only the body
scrolls. When available height is too small, all three regions move into one
scroll view. The threshold scales with accessibility text size so a large
header or stacked actions cannot overflow.

`FrostedAdaptiveActions` displays secondary and primary actions in one row when
space allows. Below 360 logical pixels, or at a text scale of 1.3 and above,
the actions stack vertically with full-width touch targets. Secondary remains
before primary, keeping the safe action ahead of a destructive action.

## Dialog usage

```dart
AppDialog(
  header: Text(appStrings.deleteTitle),
  actions: FrostedAdaptiveActions(
    secondary: FrostedButton.secondary(
      label: appStrings.cancel,
      onPressed: cancel,
    ),
    primary: FrostedButton.destructive(
      label: appStrings.delete,
      onPressed: confirmDelete,
    ),
  ),
  child: Text(appStrings.deleteDescription),
)
```

`showAppWarningDialog(isDestructive: true)` assigns the destructive role to
the confirmation action. Default Confirm, Cancel, Submit, and OK labels follow
`FrostedAppLocalizations` when its delegate is installed. Explicit strings
continue to take precedence.

Input dialogs retain one validation path for keyboard Done and the confirmation
button. Dialog constraints continue to account for keyboard insets without
adding them twice.

## Bottom-sheet usage

```dart
showAppBottomSheet(
  context: context,
  title: appStrings.settings,
  actions: FrostedButton.primary(
    label: appStrings.save,
    onPressed: save,
  ),
  child: const SettingsForm(),
)
```

`AppBottomSheet` animates the complete surface above `viewInsets.bottom`
instead of inserting a large empty spacer inside its content. Its height is
clamped to the usable viewport through `maxHeightFactor`, which defaults to
0.92. `header` can replace the title row; `showCloseButton`, `showDragHandle`,
and `closeTooltip` customize the default chrome.

## Performance on lower-end devices

Each modal owns one `BlurredCard` surface. Nested kit controls detect the glass
ancestor and do not create another backdrop blur. Bottom sheets use
`Clip.hardEdge` by default, avoiding anti-aliased save layers for routine
clipping.

All surfaces honor `FrostedPerformance`. In lite mode no `BackdropFilter` is
created; the opaque fallback preserves contrast and geometry. Balanced mode
scales sigma once. Keyboard padding uses the shared theme duration and becomes
immediate when reduced motion is active. No FPS claim is made without
profile-mode device measurements.

## Compatibility

Existing child, title, sizing, glass, drag, and dismissal parameters remain
supported. New `header` and `actions` parameters are additive. Existing custom
dialog children continue to render, so applications can migrate incrementally.

## Verification

Widget tests cover destructive roles, 320px width with 2x text, keyboard
insets, a long bottom-sheet body, localized default actions, and blur counts in
full and lite modes. Existing dialog validation, rotation, RTL, and keyboard
tests remain part of the full suite.
