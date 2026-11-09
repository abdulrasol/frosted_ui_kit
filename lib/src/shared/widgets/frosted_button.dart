import 'package:flutter/material.dart';
import 'buttons.dart';

/// A concise button API backed by [AppButton] and the shared Frosted theme.
///
/// Use [FrostedButton.primary] for the main action and
/// [FrostedButton.secondary] for alternatives. A null callback disables the
/// button. [AppButton] remains available for advanced glass customization.
class FrostedButton extends StatelessWidget {
  /// Creates a filled primary action.
  const FrostedButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.style = AppButtonStyle.colored,
  }) : _role = FrostedActionRole.primary;

  /// Creates an outlined secondary action.
  const FrostedButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.style = AppButtonStyle.outlined,
  }) : _role = FrostedActionRole.secondary;

  /// Creates a destructive action whose meaning survives appearance changes.
  const FrostedButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.style = AppButtonStyle.colored,
  }) : _role = FrostedActionRole.destructive;

  /// Visible label, supplied in the application's current language.
  final String label;

  /// Action callback; null disables pointer and keyboard activation.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Shows a progress indicator and blocks activation.
  final bool isLoading;

  /// Optional width; otherwise follows the parent's constraints.
  final double? width;

  /// Optional local fill color, overriding the default role color.
  final Color? backgroundColor;

  /// Optional local icon and label color.
  final Color? foregroundColor;

  /// Optional local radius, overriding the shared theme.
  final BorderRadiusGeometry? borderRadius;

  /// Visual appearance, independent from the action's semantic role.
  final AppButtonStyle style;

  final FrostedActionRole _role;

  @override
  Widget build(BuildContext context) => AppButton(
    title: label,
    icon: icon,
    onPressed: onPressed,
    isDisabled: onPressed == null,
    isLoading: isLoading,
    style: style,
    role: _role,
    width: width,
    backgroundColor: backgroundColor,
    iconColor: foregroundColor,
    borderRadius: borderRadius,
  );
}

/// Accessible icon action with a required localized tooltip.
///
/// Uses [CircleButton], including its selected state, minimum touch target,
/// shared theme and water-drop default appearance.
class FrostedIconButton extends StatelessWidget {
  /// Creates an icon action with an accessible name.
  const FrostedIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.selected = false,
    this.selectedColor,
    this.selectedIconColor,
    this.style = CircleButtonStyle.waterDrop,
    this.role = FrostedActionRole.primary,
    this.size = 48,
  });

  /// Icon displayed by the action.
  final IconData icon;

  /// Localized tooltip and screen-reader label.
  final String tooltip;

  /// Callback; null disables the action.
  final VoidCallback? onPressed;

  /// Whether the action is selected.
  final bool selected;

  /// Optional selected surface color.
  final Color? selectedColor;

  /// Optional selected icon color.
  final Color? selectedIconColor;

  /// Optional appearance override.
  final CircleButtonStyle style;

  /// Semantic role used for icon and surface accent colors.
  final FrostedActionRole role;

  /// Requested size; the base widget enforces a minimum 48px touch target.
  final double size;

  @override
  Widget build(BuildContext context) => CircleButton(
    icon: icon,
    tooltip: tooltip,
    semanticLabel: tooltip,
    onPressed: onPressed,
    selected: selected,
    selectedColor: selectedColor,
    selectedIconColor: selectedIconColor,
    style: style,
    role: role,
    size: size,
  );
}
