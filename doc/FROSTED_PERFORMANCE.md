# Frosted UI Kit Performance Policy

`FrostedPerformance` is the single performance policy for glass surfaces in
`frosted_ui_kit`. It lets an application choose the rendering cost once at the
root of a widget tree instead of configuring every component independently.

## Presets

```dart
FrostedPerformance.fromData(
  data: FrostedPerformance.balanced,
  child: MaterialApp(home: const HomePage()),
)
```

| Preset | Backdrop blur | Blur scale | Recommended use |
|---|---:|---:|---|
| `full` | Enabled | `1.0` | Flagship devices and desktop |
| `balanced` | Enabled | `0.5` | General mobile default |
| `lite` | Disabled | `1.0` | Low-end devices and reduced transparency |

`lite` removes `BackdropFilter` entirely. It keeps the same layout, surface
geometry, interaction, borders, and translucent fallback fill, so changing
the policy does not cause a layout shift.

## Component contract

Every shared glass surface must:

1. Read `FrostedPerformance.of(context)`.
2. Skip `BackdropFilter` when `blurEnabled` is false.
3. Multiply requested sigma values by `blurScale` exactly once.
4. Preserve dimensions and decoration in all presets.
5. Avoid nested filters through the shared `GlassBackdrop` scope.
6. Keep clipping bounded to the surface shape.

On Android, `BlurredCard` also defaults to the lightweight alpha fallback unless
the caller explicitly opts into blur with `disableBlur: false`. Explicit widget
properties remain available for advanced cases, but the root performance policy
always has the final ability to disable the filter.

## Choosing a mode at runtime

Expose the policy as an application setting or derive it from a device-tier
decision. Do not toggle it on every frame. A single inherited update rebuilds
only the surfaces that depend on the policy:

```dart
class AppRoot extends StatelessWidget {
  const AppRoot({super.key, required this.mode});

  final FrostedPerformanceData mode;

  @override
  Widget build(BuildContext context) {
    return FrostedPerformance.fromData(
      data: mode,
      child: const MaterialApp(home: HomePage()),
    );
  }
}
```

Use `lite` when the platform requests reduced transparency, when sustained
raster work is too high, or on low-end hardware. Use `balanced` before choosing
`full` as the default for a broad mobile audience.

## Measurement protocol

Performance claims must be made from profile builds, not debug mode:

```bash
flutter run --profile -d <device-id>
flutter drive --profile --no-dds -d <device-id> \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/performance_test.dart
```

The repository includes a repeatable example scenario at
`example/integration_test/performance_test.dart`. Run it from the example
directory:

```bash
flutter drive --profile --no-dds -d <device-id> \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/performance_test.dart
```

The test reports a `catalog_scroll` timeline suitable for comparing the same
build with `full`, `balanced`, and `lite`. The app starts in `balanced`; change
the Rendering Mode in Catalog settings and rerun the same scenario for the
other modes.

Record the device model, OS, Flutter version, preset, screen, scroll scenario,
and warm-up duration. Capture build time, raster time, frame timing, and jank.
Compare the same scenario in `full`, `balanced`, `android`, and `lite`. This repository
does not claim a fixed FPS or percentage improvement without those measurements.

For Android scrolling-heavy screens, the explicit `android` preset removes
backdrop readback while preserving surface geometry, opacity, borders, and
semantics:

```dart
FrostedPerformance.fromData(
  data: FrostedPerformance.android,
  child: MaterialApp(home: MyHomePage()),
)
```

Use `balanced` when reduced blur is acceptable, and use `full` only when the
device and screen can sustain the additional raster work.

## Android baseline (2026-11-08)

The first physical baseline was captured with the repeatable `catalog_scroll`
scenario in `balanced` mode:

| Field | Value |
| --- | --- |
| Device | Xiaomi `24069PC21G` |
| Android | 16 |
| Display | 1220 x 2712, configured for 120 Hz |
| Flutter | 3.47.9 stable |
| Build | Profile |
| Scenario | 8 down/up drag cycles, 250 ms between gestures, 2 s warm-up |
| Frames captured | 32 |
| Average build time | 0.505 ms |
| 90th / 99th build time | 1.058 / 1.439 ms |
| Worst build time | 1.439 ms |
| Average rasterizer time | 11.722 ms |
| 90th / 99th rasterizer time | 19.877 / 21.297 ms |
| Worst rasterizer time | 21.297 ms |
| Missed build budget | 0 |
| Missed raster budget | 11 of 32 frames |

At 120 Hz the frame budget is approximately 8.33 ms. The measured raster
average is therefore above the 120 Hz budget, while build work remains well
below it. The report does not emit a display FPS value; `1000 / 11.722` is an
approximate raster-work capacity of 85.3 fps, not measured on-screen FPS and
must not be presented as one. The raw report is generated at
`example/build/integration_response_data.json` for future comparisons.

## Android preset comparison

The same scenario was rerun with `FrostedPerformance.android` on the same
device and build configuration:

| Metric | Balanced | Android preset | Change |
| --- | ---: | ---: | ---: |
| Average build time | 0.505 ms | 0.561 ms | +0.056 ms |
| Average rasterizer time | 11.722 ms | 5.913 ms | -49.6% |
| 90th percentile rasterizer | 19.877 ms | 13.466 ms | -32.2% |
| Worst rasterizer time | 21.297 ms | 14.120 ms | -33.7% |
| Missed raster budgets | 11 / 32 | 0 / 32 | eliminated |

This is a device-specific baseline, not a universal FPS guarantee. The
Android preset is the recommended choice for scrolling-heavy Android screens;
the raw report at `example/build/integration_response_data.json` contains the
latest Android-preset run.

## iOS baseline (2026-11-09)

The same `catalog_scroll` scenario was captured on the connected physical
device `AbdulRasol's iPhone` running iOS `27.0.1` in Profile mode with the
default `balanced` preset:

| Metric | Value |
| --- | ---: |
| Frames captured | 32 |
| Average build time | 0.525 ms |
| 90th / 99th build time | 0.761 / 0.858 ms |
| Worst build time | 0.858 ms |
| Average rasterizer time | 10.425 ms |
| 90th / 99th rasterizer time | 13.459 ms |
| Worst rasterizer time | 19.910 ms |
| Missed build budgets | 0 |
| Missed raster budgets | 1 of 32 |

The iOS report does not expose a reliable display FPS value through this
runner, so no fixed FPS claim is made. The raw report is generated at
`example/build/integration_response_data.json` after each run and should be
archived with the device and preset details.

## Current verification

Widget tests verify that `lite` creates no `BackdropFilter`, `balanced` scales
sigma once, nested glass surfaces do not add filters, and independent surfaces
remain independently bounded. The Android baseline above is intentionally
kept separate from unit tests. An iOS profile run is still required before P1
can be marked complete.
