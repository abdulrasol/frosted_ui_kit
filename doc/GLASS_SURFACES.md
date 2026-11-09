# Shared glass rendering

All kit backdrop filters are built by the internal `GlassBackdrop` primitive.
Cards and water-drop buttons retain their own tint, border, shadow and content
layout; the primitive owns bounded clipping and blur only. No extra controller,
timer, raster cache or unconditional RepaintBoundary is introduced.

`FrostedPerformance` is exported from the main library. Global blurEnabled and
blurScale apply to all surfaces. Lite and zero scale create no backdrop filter.
Cards retain their platform-specific Android fallback and local disableBlur;
explicit colors are retained. Default card fallback uses fallbackOpacity in lite.

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
