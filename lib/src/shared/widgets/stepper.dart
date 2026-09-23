import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A direction enum for [FrostedStepper].
enum FrostedStepperDirection {
  /// Vertical layout
  vertical,

  /// Horizontal layout
  horizontal,
}

/// A controller for [FrostedStepper].
/// Uses a ValueNotifier internally for lightweight state management.
class FrostedStepperController extends ValueNotifier<int> {
  FrostedStepperController({
    required this.steps,
    this.stepsList,
    this.showTitles = true,
    int initialIndex = 0,
  }) : assert(steps > 0, 'steps must be greater than 0'),
       assert(
         !showTitles || stepsList == null || stepsList.length == steps,
         'stepsList length must be equal to the number of steps if titles are shown',
       ),
       super(initialIndex);

  /// Number of steps
  final int steps;

  /// Steps titles (optional)
  final List<String>? stepsList;

  /// Whether to show titles under the steps
  final bool showTitles;

  /// Move to the next step
  void next() {
    if (value < steps - 1) {
      value++;
    }
  }

  /// Move to the previous step
  void previous() {
    if (value > 0) {
      value--;
    }
  }

  /// Reset step index to 0
  void reset() {
    value = 0;
  }
}

/// A glassmorphic stepper widget.
class FrostedStepper extends StatelessWidget {
  const FrostedStepper({
    super.key,
    required this.controller,
    this.direction = FrostedStepperDirection.horizontal,
    this.activeColor,
    this.inactiveColor,
    this.textColor,
    this.lineSize = 2,
    this.stepSize = 32,
    this.titlePaddingTop = 12,
    this.gapBetweenStepAndTitle = 16,
    this.verticalLineHeight = 32,
    this.stepLineLength,
  });

  /// The controller for the stepper.
  final FrostedStepperController controller;

  /// The direction of the stepper (horizontal or vertical).
  final FrostedStepperDirection direction;

  /// The color for the active/done steps and lines. Defaults to theme primary.
  final Color? activeColor;

  /// The color for the inactive steps and lines. Defaults to theme outline.
  final Color? inactiveColor;

  /// The color for the text inside the step circle. Defaults to onPrimary.
  final Color? textColor;

  /// The thickness of the line between steps.
  final double lineSize;

  /// The size (diameter) of the step circle.
  final double stepSize;

  /// Padding above the title in horizontal mode.
  final double titlePaddingTop;

  /// Gap between step and title in vertical mode.
  final double gapBetweenStepAndTitle;

  /// Fixed height for the line connecting steps in vertical mode.
  final double verticalLineHeight;

  /// Fixed length for the connecting line in horizontal mode.
  /// If null, lines will expand to fill available horizontal space.
  final double? stepLineLength;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller,
      builder: (context, currentIndex, child) {
        final isVertical = direction == FrostedStepperDirection.vertical;

        if (isVertical) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildSteps(context, currentIndex, isVertical),
          );
        } else {
          return Row(
            mainAxisSize: stepLineLength != null
                ? MainAxisSize.min
                : MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildSteps(context, currentIndex, isVertical),
          );
        }
      },
    );
  }

  List<Widget> _buildSteps(
    BuildContext context,
    int currentIndex,
    bool isVertical,
  ) {
    final list = <Widget>[];
    for (int i = 0; i < controller.steps; i++) {
      list.add(_buildStep(context, i, currentIndex, isVertical));
      if (i < controller.steps - 1) {
        list.add(_buildStepLine(context, i, currentIndex, isVertical));
      }
    }
    return list;
  }

  Widget _buildStep(
    BuildContext context,
    int index,
    int currentIndex,
    bool isVertical,
  ) {
    final theme = Theme.of(context);
    final activeColorToUse = activeColor ?? theme.colorScheme.primary;
    final inactiveColorToUse =
        inactiveColor ??
        theme.colorScheme.outlineVariant.withValues(alpha: 0.4);
    final isDoneOrActive = index <= currentIndex;

    final stepWidget = Container(
      width: stepSize,
      height: stepSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDoneOrActive
            ? activeColorToUse
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDoneOrActive ? activeColorToUse : inactiveColorToUse,
          width: 1.5,
        ),
      ),
      child: Text(
        (index + 1).toString(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: isDoneOrActive
              ? (textColor ?? theme.colorScheme.onPrimary)
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    Widget titleWidget = const SizedBox.shrink();
    if (controller.showTitles && controller.stepsList != null) {
      final textWidget = Text(
        controller.stepsList![index],
        maxLines: 1,
        textAlign: isVertical ? TextAlign.start : TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isDoneOrActive
              ? activeColorToUse
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isDoneOrActive ? FontWeight.bold : FontWeight.normal,
        ),
      );

      if (isVertical) {
        titleWidget = Container(
          margin: EdgeInsets.only(left: gapBetweenStepAndTitle),
          child: textWidget,
        );
      } else {
        titleWidget = SizedBox(
          width: 0,
          height: 0,
          child: OverflowBox(
            alignment: Alignment.topCenter,
            fit: OverflowBoxFit.deferToChild,
            maxHeight: double.infinity,
            maxWidth: double.infinity,
            child: Container(
              margin: EdgeInsets.only(top: titlePaddingTop),
              child: textWidget,
            ),
          ),
        );
      }
    }

    if (isVertical) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [stepWidget, titleWidget],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [stepWidget, if (controller.showTitles) titleWidget],
      );
    }
  }

  Widget _buildStepLine(
    BuildContext context,
    int index,
    int currentIndex,
    bool isVertical,
  ) {
    final theme = Theme.of(context);
    final activeColorToUse = activeColor ?? theme.colorScheme.primary;
    final inactiveColorToUse =
        inactiveColor ??
        theme.colorScheme.outlineVariant.withValues(alpha: 0.4);
    final isDone = index < currentIndex;

    if (isVertical) {
      return Container(
        margin: EdgeInsets.only(left: (stepSize - lineSize) / 2),
        width: lineSize,
        height: verticalLineHeight,
        decoration: BoxDecoration(
          color: isDone ? activeColorToUse : inactiveColorToUse,
          borderRadius: BorderRadius.circular(lineSize),
        ),
      );
    } else {
      final lineWidget = Container(
        margin: EdgeInsets.only(top: (stepSize - lineSize) / 2),
        height: lineSize,
        decoration: BoxDecoration(
          color: isDone ? activeColorToUse : inactiveColorToUse,
          borderRadius: BorderRadius.circular(lineSize),
        ),
      );

      if (stepLineLength != null) {
        return SizedBox(width: stepLineLength, child: lineWidget);
      } else {
        return Expanded(flex: 3, child: lineWidget);
      }
    }
  }
}

/// A mixin providing utility methods to create glassmorphic steppers.
mixin Steppers {
  /// Builds a [FrostedStepper].
  Widget appStepper({
    Key? key,
    required FrostedStepperController controller,
    FrostedStepperDirection direction = FrostedStepperDirection.horizontal,
    Color? activeColor,
    Color? inactiveColor,
    Color? textColor,
    double? stepLineLength,
  }) {
    return FrostedStepper(
      key: key,
      controller: controller,
      direction: direction,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      textColor: textColor,
      stepLineLength: stepLineLength,
    );
  }
}
