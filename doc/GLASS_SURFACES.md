# Shared glass rendering

All kit backdrop filters are built by the internal `GlassBackdrop` primitive.
Cards and water-drop buttons retain their own tint, border, shadow and content
layout; the primitive owns bounded clipping and blur only. No extra controller,
timer, raster cache or unconditional RepaintBoundary is introduced.

`FrostedPerformance` is exported from the main library. Global blurEnabled and
blurScale apply to all surfaces. Lite and zero scale create no backdrop filter.
All surfaces use the Android alpha fallback only when no explicit performance
scope exists. Full and Balanced explicitly enable blur on Android and iOS.
Cards retain local disableBlur; explicit colors are retained. Default card fallback uses fallbackOpacity in lite.

A private inherited marker prevents a nested kit surface from adding a second
blur when an ancestor already filters its backdrop. This intentionally changes
stacked glass: an input inside a glass dialog uses the dialog's blur, keeping its
own tint and border. Nested stronger blur is not independently applied.
Independent siblings keep separate filters; overlapping siblings are not given
a shared BackdropKey, which could produce incorrect compositing.

Animated child content stays in its original layer order. Moving it or adding
raster boundaries requires profile measurements, tracked in P1. Dialog entrance
and button press scaling respect reduced-motion settings. Full animation policy
for other components is outside this rendering refactor.

Tests verify ancestor filter reuse, independent siblings, lite and zero scale,
balanced scaling once, and existing light/dark geometry goldens. These establish
render-tree behavior and visual regression protection, not a measured FPS gain.

## Rendering mode precedence

1. Global disabled blur or zero scale disables every kit backdrop.
2. A card with `disableBlur: true` remains unblurred.
3. An explicit Full or Balanced scope enables all glass surfaces on every platform.
4. Without a scope, Android uses alpha transparency; other platforms use blur.
   A card may opt in with `disableBlur: false`.

The same policy covers cards, app-bar titles, navigation bars, glass and
water-drop buttons, FABs, glass loading buttons, text fields, tabs, list
sections, bottom sheets and dialogs. Solid/outlined/text button styles,
non-glass inputs, badges, separators and stepper connectors remain intentional
non-backdrop decorations. Alpha blending is still present in Lite: it is not
an opaque or reduced-transparency accessibility mode.

`FrostedPerformance` is an `InheritedTheme`, so Flutter captures a local scope
when opening a dialog or bottom sheet. Captured local settings are a snapshot
at route creation. Place a live application-wide scope above `MaterialApp`
when open routes must react to rendering-mode changes.

Explicit opaque tints still hide the visual blur, and a uniform background has
no details to blur. Rendering mode changes the filter, not caller-supplied colors.

## Scroll-driven app bars

`BaseWidget` accumulates actual primary vertical scroll deltas against
`hideAfter` and `showAfter`. Direction-only notifications do not toggle the bar.
At the leading edge (including top bounce), the bar stays visible and movement
counters reset. Out-of-range overscroll, horizontal and nested viewport
notifications do not toggle it. Disabling the scroll behavior restores visibility;
rebuilding a screen with `collapseTitle` does not reset its hidden state.

Regression tests cover all glass component families in Full, Balanced and Lite
on Android and iOS, modal route capture, top bounce and distance thresholds.
They do not replace on-device visual and frame-time profiling.
