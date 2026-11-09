# Visual Consistency

The kit uses one surface language across cards, app bars, buttons, navigation,
dialogs, and sheets:

- translucent fills instead of opaque white panels;
- shared rounded geometry and border treatment;
- readable foreground contrast in light and dark themes;
- explicit performance fallbacks on Android;
- custom colors remain higher priority than defaults.

The default app-bar title uses the same translucent surface family as the
water-drop controls. On Android, where the default card fallback skips
`BackdropFilter`, this keeps the title from becoming a visually disconnected
opaque panel. Applications can still override it with `glassColor`.

`FrostedListTile` adds a selected icon capsule, state-aware typography, and
semantic selection metadata. `AppSlidingTabs` uses a bordered gradient pill
with selected semantics, while `FrostedStepper` uses a lightweight gradient
node and current-step emphasis instead of adding another backdrop filter.
Stepper nodes also accept an optional `stepBuilder` for icons, images, Lottie,
or any custom widget. The builder receives the step state and its content is
constrained to the node size.

Visual regression checks cover both theme brightnesses. When changing surface
tokens, verify the catalog on Android and iOS and rerun the profile scroll
scenario before changing the default appearance.
