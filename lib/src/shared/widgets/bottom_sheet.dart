import 'package:material_ui/material_ui.dart';
import 'package:frosted_ui_kit/src/extensions/context.dart';
import 'package:frosted_ui_kit/src/shared/widgets/adaptive_surface_layout.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';
import 'package:frosted_ui_kit/src/utils/frosted_theme.dart';

/// A responsive glass bottom-sheet surface with shared header/body/actions layout.
///
/// The body scrolls independently on regular viewports. On very short
/// viewports, including those reduced by the keyboard, all regions remain
/// reachable through one scroll view. The glass surface uses [BlurredCard], so
/// global performance settings are honored without another blur layer.
class AppBottomSheet extends StatelessWidget {
  /// Creates an [AppBottomSheet] with customizable glass and layout options.
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.header,
    this.actions,
    this.showCloseButton = true,
    this.showDragHandle = true,
    this.closeTooltip,
    this.padding,
    this.margin,
    this.borderRadius,
    this.height,
    this.maxHeightFactor = 0.92,
    this.sigmaX,
    this.sigmaY,
    this.glassColor,
    this.border,
    this.boxShadow,
    this.clipBehavior = Clip.hardEdge,
  }) : assert(maxHeightFactor > 0 && maxHeightFactor <= 1);

  /// Main scrollable bottom-sheet content.
  final Widget child;

  /// Optional localized title used by the default header.
  final String? title;

  /// Optional custom header replacing the default title row.
  final Widget? header;

  /// Optional action footer pinned when vertical space allows.
  final Widget? actions;

  /// Whether the default title header includes a close button.
  final bool showCloseButton;

  /// Whether a visual drag handle is displayed.
  final bool showDragHandle;

  /// Optional localized close-button tooltip.
  /// Null uses [MaterialLocalizations.closeButtonTooltip].
  final String? closeTooltip;

  /// Inner padding for the bottom-sheet surface.
  final EdgeInsetsGeometry? padding;

  /// Outer margin surrounding the sheet.
  final EdgeInsetsGeometry? margin;

  /// Custom surface radius.
  final BorderRadiusGeometry? borderRadius;

  /// Optional requested height, clamped by the available viewport.
  final double? height;

  /// Maximum fraction of screen height occupied by the surface.
  final double maxHeightFactor;

  /// Horizontal backdrop blur override.
  final double? sigmaX;

  /// Vertical backdrop blur override.
  final double? sigmaY;

  /// Optional translucent surface tint.
  final Color? glassColor;

  /// Optional border override.
  final BoxBorder? border;

  /// Optional surface shadows.
  final List<BoxShadow>? boxShadow;

  /// Surface clipping behavior.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = FrostedThemeData.of(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final mediaPadding = MediaQuery.paddingOf(context);
    final usableHeight =
        MediaQuery.sizeOf(context).height -
        viewInsets.bottom -
        mediaPadding.bottom;
    final maxHeight =
        usableHeight.clamp(0.0, double.infinity) * maxHeightFactor;
    final requestedHeight = height?.clamp(0.0, maxHeight).toDouble();
    final effectiveRadius =
        borderRadius ??
        BorderRadius.vertical(top: Radius.circular(tokens.dialogRadius + 4));
    final defaultColor =
        (glassColor ?? tokens.surfaceColor ?? theme.colorScheme.surface)
            .withValues(alpha: glassColor?.a ?? 0.72);
    final effectiveHeader = _buildHeader(context, theme, tokens);

    return AnimatedPadding(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : tokens.motionDuration,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SafeArea(
        top: false,
        bottom: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: BlurredCard(
            height: requestedHeight,
            margin: margin,
            padding:
                padding ??
                EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: context.horizontalPadding,
                ),
            borderRadius: effectiveRadius,
            sigmaX: sigmaX ?? tokens.sheetBlur,
            sigmaY: sigmaY ?? tokens.sheetBlur,
            color: defaultColor,
            border: border,
            boxShadow: boxShadow,
            clipBehavior: clipBehavior,
            child: FrostedAdaptiveSurfaceLayout(
              header: effectiveHeader,
              body: child,
              actions: actions,
              spacing: tokens.spacing,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildHeader(
    BuildContext context,
    ThemeData theme,
    FrostedThemeData tokens,
  ) {
    final defaultHeader = title == null
        ? null
        : Row(
            children: [
              Expanded(
                child: Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (showCloseButton) ...[
                SizedBox(width: tokens.spacing / 2),
                CircleButton(
                  icon: Icons.close_rounded,
                  size: 48,
                  style: CircleButtonStyle.glass,
                  role: FrostedActionRole.secondary,
                  tooltip:
                      closeTooltip ??
                      MaterialLocalizations.of(context).closeButtonTooltip,
                  semanticLabel:
                      closeTooltip ??
                      MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ],
          );
    final contentHeader = header ?? defaultHeader;
    if (!showDragHandle && contentHeader == null) return null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDragHandle) ...[
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (contentHeader != null) SizedBox(height: tokens.spacing),
        ],
        ?contentHeader,
      ],
    );
  }
}

/// Utilities for displaying standardized responsive bottom sheets.
mixin BottomSheets {
  /// Displays an [AppBottomSheet] using one shared glass surface.
  Future<T?> showAppBottomSheet<T>({
    required BuildContext context,
    Key? key,
    required Widget child,
    String? title,
    Widget? header,
    Widget? actions,
    bool showCloseButton = true,
    bool showDragHandle = true,
    String? closeTooltip,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool isDismissible = true,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    double? height,
    double maxHeightFactor = 0.92,
    double? sigmaX,
    double? sigmaY,
    Color? glassColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: false,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        key: key,
        title: title,
        header: header,
        actions: actions,
        showCloseButton: showCloseButton,
        showDragHandle: showDragHandle,
        closeTooltip: closeTooltip,
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        height: height,
        maxHeightFactor: maxHeightFactor,
        sigmaX: sigmaX,
        sigmaY: sigmaY,
        glassColor: glassColor,
        border: border,
        boxShadow: boxShadow,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
}
