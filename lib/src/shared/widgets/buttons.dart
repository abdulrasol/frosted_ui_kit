import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';
import 'glass_backdrop.dart';
import 'package:frosted_ui_kit/src/utils/frosted_theme.dart';

/// Defines visual style variants for [AppButton].
enum AppButtonStyle {
  /// Default glassmorphic button style (built on [BlurredCard] with backdrop blur).
  glass,

  /// Solid colored filled button style using primary theme color or custom background color.
  colored,

  /// Outlined button style with solid border line and transparent background.
  outlined,

  /// Text-only button style without border or card background.
  text,

  /// Lightweight liquid-glass style with a low-sigma, performance-aware blur.
  waterDrop,
}

/// Semantic meaning of an action, independent from its visual appearance.
///
/// Keep the same role when switching between [AppButtonStyle] values so color,
/// focus feedback and accessibility meaning remain consistent.
enum FrostedActionRole {
  /// Main action in the current context.
  primary,

  /// Supporting or lower-emphasis action.
  secondary,

  /// Irreversible or dangerous action such as delete or remove.
  destructive,
}

/// Visual treatments available for icon-only circular buttons.
enum CircleButtonStyle {
  /// Uses the existing glassmorphic surface.
  glass,

  /// Uses a translucent layered highlight and low-sigma blur that resembles a water droplet.
  waterDrop,

  /// Uses a solid themed surface without backdrop blur.
  solid,
}

/// A circular glassmorphic button built on [BlurredCard] with customizable blur, border, and color.
class CircleButton extends StatelessWidget {
  /// Creates a [CircleButton] with specified tap callback, icon, and optional glass parameters.
  const CircleButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 48.0,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.glassColor,
    this.borderColor,
    this.borderWidth,
    this.border,
    this.margin,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
    this.style = CircleButtonStyle.waterDrop,
    this.role = FrostedActionRole.primary,
    this.selected = false,
    this.selectedColor,
    this.selectedIconColor,
    this.tooltip,
    this.semanticLabel,
  });

  /// Callback function executed when the button is tapped.
  final VoidCallback? onPressed;

  /// Icon data displayed at the center of the button.
  final IconData icon;

  /// Custom diameter size for the circular button (defaults to 48.0).
  final double? size;

  /// Horizontal backdrop blur intensity (defaults to 10.0).
  final double sigmaX;

  /// Vertical backdrop blur intensity (defaults to 10.0).
  final double sigmaY;

  /// Optional custom glass background tint color.
  final Color? glassColor;

  /// Optional border color override.
  final Color? borderColor;

  /// Optional border width override.
  final double? borderWidth;

  /// Optional custom border override. If provided, overrides [borderColor] and [borderWidth].
  final BoxBorder? border;

  /// Outer margin surrounding the button container.
  final EdgeInsetsGeometry? margin;

  /// Optional list of box shadows applied to the circular button.
  final List<BoxShadow>? boxShadow;

  /// Content clipping behavior (defaults to [Clip.antiAlias]).
  final Clip clipBehavior;

  /// Visual treatment used by the button.
  final CircleButtonStyle style;

  /// Semantic role used to resolve icon and surface accent colors.
  final FrostedActionRole role;

  /// Whether the button is currently selected.
  final bool selected;

  /// Optional surface color used while [selected] is true.
  final Color? selectedColor;

  /// Optional icon color used while [selected] is true.
  final Color? selectedIconColor;

  /// Optional tooltip shown for pointer and long-press interactions.
  final String? tooltip;

  /// Accessible label announced by screen readers.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? 48.0;
    BoxBorder? customBorder;
    if (borderColor != null) {
      customBorder = Border.all(color: borderColor!, width: borderWidth ?? 1.0);
    }

    final Widget surface;
    final tokens = FrostedThemeData.of(context);
    final roleColors = role.resolveColors(context);
    final selectedIcon =
        selectedIconColor ??
        (selected
            ? Theme.of(context).colorScheme.onPrimary
            : role == FrostedActionRole.primary
            ? tokens.contentColor
            : style == CircleButtonStyle.solid
            ? roleColors.onAccent
            : roleColors.accent);
    if (style == CircleButtonStyle.waterDrop) {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      final surfaceColor = selected && selectedColor != null
          ? selectedColor!
          : (glassColor ??
                (role == FrostedActionRole.primary
                    ? null
                    : roleColors.accent) ??
                tokens.surfaceColor ??
                theme.colorScheme.surfaceContainerHighest);
      surface = Container(
        height: effectiveSize,
        width: effectiveSize,
        margin: margin,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? null : surfaceColor.withValues(alpha: 0.20),
          gradient: isDark
              ? const RadialGradient(
                  center: Alignment(-0.35, -0.4),
                  radius: 0.9,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.14),
                    Color.fromRGBO(255, 255, 255, 0.04),
                    Color.fromRGBO(0, 0, 0, 0.10),
                  ],
                  stops: [0, 0.48, 1],
                )
              : null,
          border:
              border ??
              Border.all(
                color:
                    (borderColor ??
                            (isDark ? Colors.white : theme.colorScheme.outline))
                        .withValues(alpha: isDark ? 0.34 : 0.48),
                width: borderWidth ?? 1,
              ),
          boxShadow:
              boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.045),
                  blurRadius: isDark ? 8 : 4,
                  offset: const Offset(1, 2),
                ),
              ],
        ),
        child: _buildInteractiveContent(
          context,
          effectiveSize,
          onPressed,
          semanticLabel,
          selectedIcon,
        ),
      );
    } else if (style == CircleButtonStyle.solid) {
      surface = Container(
        height: effectiveSize,
        width: effectiveSize,
        margin: margin,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected && selectedColor != null
              ? selectedColor
              : (glassColor ?? roleColors.accent),
          border:
              border ??
              (borderColor == null
                  ? null
                  : Border.all(color: borderColor!, width: borderWidth ?? 1)),
          boxShadow: boxShadow,
        ),
        child: _buildInteractiveContent(
          context,
          effectiveSize,
          onPressed,
          semanticLabel,
          selectedIcon,
        ),
      );
    } else {
      surface = BlurredCard(
        height: effectiveSize,
        width: effectiveSize,
        shape: BoxShape.circle,
        sigmaX: sigmaX,
        sigmaY: sigmaY,
        color: glassColor,
        border: border ?? customBorder,
        boxShadow: boxShadow,
        margin: margin,
        clipBehavior: clipBehavior,
        padding: EdgeInsets.zero,
        child: _buildInteractiveContent(
          context,
          effectiveSize,
          onPressed,
          semanticLabel,
          selectedIcon,
        ),
      );
    }

    final liquidSurface = style == CircleButtonStyle.waterDrop
        ? _wrapWaterDrop(context, surface)
        : surface;
    final button = Semantics(
      button: true,
      enabled: onPressed != null,
      selected: selected,
      label: semanticLabel,
      onTap: onPressed,
      excludeSemantics: semanticLabel != null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: _PressScale(enabled: onPressed != null, child: liquidSurface),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }

  Widget _buildInteractiveContent(
    BuildContext context,
    double effectiveSize,
    VoidCallback? onPressed,
    String? semanticLabel,
    Color? iconColor,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Center(
          child: Icon(
            icon,
            size: effectiveSize * 0.5,
            color: iconColor,
            semanticLabel: semanticLabel,
          ),
        ),
      ),
    );
  }

  Widget _wrapWaterDrop(BuildContext context, Widget child) {
    final sigma = FrostedThemeData.of(context).glassBlur;
    return GlassBackdrop(
      sigmaX: sigma,
      sigmaY: sigma,
      shape: BoxShape.circle,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _PressScale extends StatefulWidget {
  const _PressScale({required this.child, required this.enabled});

  final Widget child;
  final bool enabled;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(widget.enabled),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale:
            _pressed &&
                widget.enabled &&
                !MediaQuery.disableAnimationsOf(context)
            ? 0.92
            : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// Legacy alias for [CircleButton] to maintain backwards compatibility.
@Deprecated('Use CircleButton instead. This alias remains for compatibility.')
typedef CricleButton = CircleButton;

/// A versatile button widget supporting multiple style variants ([AppButtonStyle.glass],
/// [AppButtonStyle.colored], [AppButtonStyle.outlined], [AppButtonStyle.text]).
class AppButton extends StatelessWidget {
  /// Creates an [AppButton] with customizable style, size, glass effects, and tap handler.
  const AppButton({
    super.key,
    this.title,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.height = 48,
    this.width,
    this.borderRadius,
    this.margin,
    this.padding,
    this.textStyle,
    this.iconColor,
    this.style = AppButtonStyle.glass,
    this.role = FrostedActionRole.primary,
    this.backgroundColor,
    this.borderColor,
    this.border,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
    this.child,
  });

  /// Optional text string displayed on the button.
  final String? title;

  /// Optional icon displayed beside or inside the button.
  final IconData? icon;

  /// Callback function triggered on button tap.
  final VoidCallback? onPressed;

  /// Whether the button shows a progress loading indicator.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// Fixed height for the button card (defaults to 48).
  final double? height;

  /// Custom child to override the default text/icon content.
  final Widget? child;

  /// Optional fixed width for the button card.
  final double? width;

  /// Custom border radius geometry for the button card.
  final BorderRadiusGeometry? borderRadius;

  /// Outer margin surrounding the button container.
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the button container.
  final EdgeInsetsGeometry? padding;

  /// Text style for the title label.
  final TextStyle? textStyle;

  /// Icon color override.
  final Color? iconColor;

  /// Visual style variant (defaults to [AppButtonStyle.glass]).
  final AppButtonStyle style;

  /// Semantic role used to resolve colors independently from [style].
  final FrostedActionRole role;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom border color override.
  final Color? borderColor;

  /// Optional custom border override. If provided, overrides [borderColor].
  final BoxBorder? border;

  /// Horizontal backdrop blur intensity for glass style (defaults to 10.0).
  final double sigmaX;

  /// Vertical backdrop blur intensity for glass style (defaults to 10.0).
  final double sigmaY;

  /// Optional list of box shadows applied to the button container.
  final List<BoxShadow>? boxShadow;

  /// Content clipping behavior (defaults to [Clip.antiAlias]).
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOnPressed = (isLoading || isDisabled) ? null : onPressed;
    final tokens = FrostedThemeData.of(context);
    final effectiveRadius =
        borderRadius?.resolve(Directionality.of(context)) ??
        BorderRadius.circular(tokens.buttonRadius);

    final roleColors = role.resolveColors(context);
    final isFilled = style == AppButtonStyle.colored;

    final Color contentColor = isDisabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
        : (iconColor ??
              (role == FrostedActionRole.primary && tokens.contentColor != null
                  ? tokens.contentColor!
                  : null) ??
              (isFilled ? roleColors.onAccent : roleColors.accent));
    final overlayColor = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) return Colors.transparent;
      if (states.contains(WidgetState.focused)) {
        return roleColors.accent.withValues(alpha: 0.16);
      }
      if (states.contains(WidgetState.pressed)) {
        return roleColors.accent.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return roleColors.accent.withValues(alpha: 0.08);
      }
      return null;
    });

    final Widget innerContent = Center(
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: contentColor,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                if (icon != null) Icon(icon, size: 20, color: contentColor),
                if (title != null)
                  Flexible(
                    child: Text(
                      title!,
                      style:
                          textStyle ??
                          theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: contentColor,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
              ],
            ),
    );

    final Widget content = child ?? innerContent;

    if (style == AppButtonStyle.waterDrop) {
      final isDark = theme.brightness == Brightness.dark;
      final surfaceColor =
          backgroundColor ??
          (role == FrostedActionRole.primary
              ? tokens.surfaceColor ??
                    (isDark
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest)
              : roleColors.accent);
      final buttonSurface = Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          color: isDark ? null : surfaceColor.withValues(alpha: 0.18),
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment(-0.8, -1),
                  end: Alignment(0.8, 1),
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.14),
                    Color.fromRGBO(255, 255, 255, 0.04),
                    Color.fromRGBO(0, 0, 0, 0.10),
                  ],
                )
              : null,
          border:
              border ??
              Border.all(
                color:
                    (borderColor ??
                            (isDark ? Colors.white : theme.colorScheme.outline))
                        .withValues(alpha: isDark ? 0.34 : 0.44),
              ),
          boxShadow:
              boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.04),
                  blurRadius: isDark ? 8 : 4,
                  offset: const Offset(2, 4),
                ),
              ],
        ),
        child: Material(
          color: Colors.transparent,
          clipBehavior: clipBehavior,
          borderRadius: effectiveRadius,
          child: InkWell(
            onTap: effectiveOnPressed,
            overlayColor: overlayColor,
            borderRadius: effectiveRadius,
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: content,
            ),
          ),
        ),
      );
      return GlassBackdrop(
        sigmaX: tokens.glassBlur,
        sigmaY: tokens.glassBlur,
        borderRadius: effectiveRadius,
        clipBehavior: clipBehavior,
        child: buttonSurface,
      );
    }

    // 1. Text Button variant
    if (style == AppButtonStyle.text) {
      return Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: effectiveOnPressed,
            overlayColor: overlayColor,
            borderRadius: effectiveRadius as BorderRadius?,
            child: content,
          ),
        ),
      );
    }

    // 2. Colored Button variant
    if (style == AppButtonStyle.colored) {
      final fillBg = isDisabled
          ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
          : (backgroundColor ?? roleColors.accent);

      return Container(
        height: height,
        width: width,
        margin: margin,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          border:
              border ??
              (borderColor != null ? Border.all(color: borderColor!) : null),
          boxShadow: boxShadow,
        ),
        child: Material(
          color: fillBg,
          clipBehavior: clipBehavior,
          borderRadius: effectiveRadius as BorderRadius?,
          child: InkWell(
            onTap: effectiveOnPressed,
            overlayColor: overlayColor,
            borderRadius: effectiveRadius as BorderRadius?,
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: content,
            ),
          ),
        ),
      );
    }

    // 3. Outlined Button variant
    if (style == AppButtonStyle.outlined) {
      final borderCol = isDisabled
          ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
          : (borderColor ?? roleColors.accent);

      return Container(
        height: height,
        width: width,
        margin: margin,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          border: border ?? Border.all(color: borderCol, width: 1.5),
          boxShadow: boxShadow,
        ),
        child: Material(
          color: backgroundColor ?? Colors.transparent,
          clipBehavior: clipBehavior,
          borderRadius: effectiveRadius as BorderRadius?,
          child: InkWell(
            onTap: effectiveOnPressed,
            overlayColor: overlayColor,
            borderRadius: effectiveRadius as BorderRadius?,
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: content,
            ),
          ),
        ),
      );
    }

    // 4. Default Glassmorphic Button variant built on BlurredCard
    return BlurredCard(
      height: height,
      width: width,
      margin: margin,
      padding: EdgeInsets.zero,
      borderRadius: effectiveRadius,
      border:
          border ??
          (borderColor != null ? Border.all(color: borderColor!) : null),
      // Preserve the original primary glass surface. Other roles receive a
      // restrained tint so their meaning survives an appearance change.
      color:
          backgroundColor ??
          (role == FrostedActionRole.primary
              ? null
              : roleColors.accent.withValues(alpha: 0.12)),
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: effectiveOnPressed,
          overlayColor: overlayColor,
          borderRadius: effectiveRadius as BorderRadius?,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// Resolved accent pair for a [FrostedActionRole].
@immutable
class FrostedActionColors {
  /// Creates a resolved action color pair.
  const FrostedActionColors(this.accent, this.onAccent);

  /// Accent used by fills, borders, text, and interaction feedback.
  final Color accent;

  /// Foreground placed on a solid [accent] surface.
  final Color onAccent;
}

/// Theme-aware color resolution for [FrostedActionRole].
extension FrostedActionRoleColors on FrostedActionRole {
  /// Resolves Frosted role tokens first, then Material [ColorScheme] values.
  FrostedActionColors resolveColors(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = FrostedThemeData.of(context);
    final scheme = theme.colorScheme;
    return switch (this) {
      FrostedActionRole.primary => FrostedActionColors(
        tokens.primaryActionColor ?? scheme.primary,
        tokens.onPrimaryActionColor ?? scheme.onPrimary,
      ),
      FrostedActionRole.secondary => FrostedActionColors(
        tokens.secondaryActionColor ?? scheme.secondary,
        tokens.onSecondaryActionColor ?? scheme.onSecondary,
      ),
      FrostedActionRole.destructive => FrostedActionColors(
        tokens.destructiveActionColor ?? scheme.error,
        tokens.onDestructiveActionColor ?? scheme.onError,
      ),
    };
  }
}

/// A mixin providing utility methods for constructing standard navigation and action buttons.
mixin Buttons {
  /// Returns a custom [CircleButton] with specified icon, tap callback, and glass options.
  Widget circleButton({
    Key? key,
    required BuildContext context,
    required IconData icon,
    VoidCallback? onPressed,
    double? size,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? glassColor,
    Color? borderColor,
    double? borderWidth,
    BoxBorder? border,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
    String? tooltip,
    String? semanticLabel,
    CircleButtonStyle style = CircleButtonStyle.waterDrop,
    FrostedActionRole role = FrostedActionRole.primary,
    bool selected = false,
    Color? selectedColor,
    Color? selectedIconColor,
  }) {
    return CircleButton(
      key: key,
      onPressed: onPressed,
      icon: icon,
      size: size,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      glassColor: glassColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      border: border,
      margin: margin,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
      style: style,
      role: role,
      selected: selected,
      selectedColor: selectedColor,
      selectedIconColor: selectedIconColor,
    );
  }

  /// Legacy alias for [circleButton].
  Widget cricleButton({
    Key? key,
    required BuildContext context,
    required IconData icon,
    VoidCallback? onPressed,
    double? size,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? glassColor,
    Color? borderColor,
    double? borderWidth,
    BoxBorder? border,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
    String? tooltip,
    String? semanticLabel,
    CircleButtonStyle style = CircleButtonStyle.waterDrop,
    FrostedActionRole role = FrostedActionRole.primary,
    bool selected = false,
    Color? selectedColor,
    Color? selectedIconColor,
  }) {
    return circleButton(
      context: context,
      icon: icon,
      onPressed: onPressed,
      size: size,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      glassColor: glassColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      border: border,
      margin: margin,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
      style: style,
      role: role,
      selected: selected,
      selectedColor: selectedColor,
      selectedIconColor: selectedIconColor,
    );
  }

  /// Returns a configured [AppButton] with support for style variants ([AppButtonStyle]).
  Widget appButton({
    Key? key,
    required BuildContext context,
    String? title,
    IconData? icon,
    Widget? child,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? height = 48,
    double? width,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? iconColor,
    AppButtonStyle style = AppButtonStyle.glass,
    FrostedActionRole role = FrostedActionRole.primary,
    Color? backgroundColor,
    Color? borderColor,
    BoxBorder? border,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppButton(
      key: key,
      title: title,
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      height: height,
      width: width,
      borderRadius: borderRadius,
      margin: margin,
      padding: padding,
      textStyle: textStyle,
      iconColor: iconColor,
      style: style,
      role: role,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      border: border,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// Returns a custom glassmorphic Floating Action Button.
  Widget appFab({
    Key? key,
    required BuildContext context,
    String? title,
    IconData? icon,
    VoidCallback? onPressed,
    AppButtonStyle style = AppButtonStyle.glass,
    FrostedActionRole role = FrostedActionRole.primary,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
  }) {
    return AppFloatingActionButton(
      key: key,
      title: title,
      icon: icon,
      onPressed: onPressed,
      style: style,
      role: role,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      border: border,
      borderRadius: borderRadius,
      margin: margin,
      boxShadow: boxShadow,
    );
  }

  /// Returns an RTL-aware back navigation button built on [CircleButton].
  Widget backButton(
    BuildContext context, {
    VoidCallback? onTap,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? glassColor,
    BoxBorder? border,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return circleButton(
      context: context,
      // Directional Material icons mirror themselves when placed in an RTL
      // context. Keep the logical back icon here and let Flutter perform the
      // single visual flip; choosing chevron_right manually would flip twice.
      icon: Icons.chevron_left_rounded,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      glassColor: glassColor,
      border: border,
      margin: margin,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      onPressed:
          onTap ??
          () {
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }
          },
    );
  }

  /// Returns a close icon navigation button built on [CircleButton].
  Widget closeButton(
    BuildContext context, {
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? glassColor,
    BoxBorder? border,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return circleButton(
      context: context,
      icon: Icons.close,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      glassColor: glassColor,
      border: border,
      margin: margin,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        }
      },
    );
  }
}

/// A flexible glassmorphic floating action button that supports icon-only, text-only, or both (extended).
class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
    this.title,
    this.icon,
    required this.onPressed,
    this.style = AppButtonStyle.glass,
    this.role = FrostedActionRole.primary,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.border,
    this.borderRadius,
    this.margin,
    this.boxShadow,
  }) : assert(
         title != null || icon != null,
         'A FAB must have either a title or an icon.',
       );

  /// Optional text label (makes the FAB extended).
  final String? title;

  /// Optional icon.
  final IconData? icon;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// The visual style of the FAB.
  final AppButtonStyle style;

  /// Semantic action role, independent from [style].
  final FrostedActionRole role;

  final double sigmaX;
  final double sigmaY;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    // If it has only an icon, it is circular. If it has text, it is rounded rect (extended).
    final isExtended = title != null;

    if (!isExtended) {
      return CircleButton(
        key: key,
        icon: icon!,
        onPressed: onPressed,
        size: 56.0, // Standard FAB size
        sigmaX: sigmaX,
        sigmaY: sigmaY,
        role: role,
        glassColor: style == AppButtonStyle.glass ? backgroundColor : null,
        borderColor:
            borderColor ??
            (style == AppButtonStyle.outlined
                ? Theme.of(context).primaryColor
                : null),
        borderWidth: borderWidth,
        border: border,
        margin: margin,
        boxShadow: boxShadow,
      );
    }

    return AppButton(
      key: key,
      title: title,
      icon: icon,
      style: style,
      role: role,
      onPressed: onPressed,
      height: 56.0,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      // borderWidth: borderWidth,
      border: border,
      borderRadius: borderRadius ?? BorderRadius.circular(16.0),
      margin: margin,
      boxShadow: boxShadow,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
    );
  }
}
