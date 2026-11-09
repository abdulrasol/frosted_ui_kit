# Package Layout and Example Boundary

## Package source

`lib/frosted_ui_kit.dart` is the supported public entry point. Reusable
components live under `lib/src/shared/widgets/`, design-system utilities live
under `lib/src/utils/`, and the generic authentication module follows the
feature boundaries under `lib/src/features/auth/`.

The `lib/main.dart` file is retained only as a legacy package-local smoke-test
harness. It is not exported and is not the recommended application entry point.

## Interactive example

The `example/` application is the canonical showcase. It owns the catalog
screens, integration tests, profile performance scenario, and platform runner
configuration. Package consumers should copy component usage from the example
or the quick-start guide, not import files from `lib/main.dart`.

## Dependency boundary

The package must not depend on its example. Example-only dependencies and test
drivers stay under `example/`, while reusable code and public API tests stay in
the package root.
