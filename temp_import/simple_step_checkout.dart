import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that displays a stepper with a progress indicator.
///
/// The [SimpleCheckoutStepper] widget requires a [SimpleCheckoutStepperController] to manage
/// the current step and navigation. It supports customization of colors, text styles,
/// and layout properties.
///
/// Usage with important options only:
/// ```dart
/// SimpleCheckoutStepper(
///   controller: controller,
/// )
/// ```
class SimpleCheckoutStepper extends StatelessWidget {
  /// Creates a [SimpleCheckoutStepper].
  ///
  /// The [controller] argument must not be null.
  const SimpleCheckoutStepper({
    super.key,
    required this.controller,
    this.stepTitleStyle,
    this.stepNumberStyle = const TextStyle(color: Colors.white),
    this.doneColor = Colors.blueAccent,
    this.unDoneColor = Colors.blueGrey,
    this.stepIndexColor = Colors.white,
    this.titlePaddingTop = 16,
    this.lineSize = 2,
    this.stepBuilder,
    this.stepTitleBuilder,
    this.stepLineWidget,
    this.direction = SimpleCheckoutStepperDirection.horizontal,
    this.stepHeight = 10,
    this.stepWidth,
    this.hroizatalPadding,
    this.gapBetweenStepAndTitle = 0,
    this.stepRadiusVertical = 0,
    this.stepRadiusHorizontal = 10,
  });

  /// direction of the stepper
  final SimpleCheckoutStepperDirection direction;

  /// controller for managing the current step and navigation
  final SimpleCheckoutStepperController controller;

  /// style for step title
  final TextStyle? stepTitleStyle;

  /// style for step number
  final TextStyle? stepNumberStyle;

  /// color for done step
  final Color doneColor;

  /// color for un done step
  final Color unDoneColor;

  /// color for index step
  final Color stepIndexColor;

  /// padding top for step title
  final double titlePaddingTop;

  /// size for step line
  final double lineSize;

  /// step widget override takes three parameters (int index, bool isDone, bool isActive)
  final StepWidgetBuilder? stepBuilder;

  /// step height override
  final double? stepHeight;

  /// step width override
  final double? stepWidth;

  /// step line widget override
  final Widget? stepLineWidget;

  /// hroizatal padding for step title in vertical direction only needed
  final double? hroizatalPadding;

  /// step title override takes three parameters (int index, bool isDone, bool isActive)
  final StepWidgetBuilder? stepTitleBuilder;

  /// gap between step and step title
  final double gapBetweenStepAndTitle;

  /// radius for step in vertical direction only needed
  final double stepRadiusVertical;

  /// radius for step in horizontal direction only needed
  final double stepRadiusHorizontal;

  @override
  Widget build(BuildContext context) {
    bool isVertical = direction == SimpleCheckoutStepperDirection.vertical;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final index = controller.index;
        return isVertical
            ? LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth * 0.9;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _wdSteps(index, isVertical, hroizatalPadding ?? width),
                  );
                },
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _wdSteps(index, isVertical, hroizatalPadding ?? 0),
              );
      },
    );
  }

  List<Widget> _wdSteps(int index, bool isVertical, double hroizatalPadding) {
    if (isVertical) {
      List<Widget> list = [];
      for (int i = 0; i <= controller.steps - 1; i++) {
        list.add(_wdStep(i, isVertical, hroizatalPadding));
        if (i < controller.steps - 1) {
          list.add(_wdStepLine(i, isVertical));
        }
      }
      return list;
    } else {
      List<Widget> list = [];
      for (int i = 0; i <= controller.steps - 1; i++) {
        list.add(_wdStep(i, isVertical, hroizatalPadding));
        if (i < controller.steps - 1) {
          list.add(_wdStepLine(i, isVertical));
        }
      }
      return list;
    }
  }

  Widget _wdStep(int index, bool isVertical, double hroizatalPadding) {
    final stepWidget = Container(
      padding: EdgeInsets.symmetric(vertical: isVertical ? stepRadiusVertical : 10, horizontal: isVertical ? stepRadiusHorizontal : 10),
      decoration: BoxDecoration(color: index <= controller.index ? doneColor : unDoneColor, shape: BoxShape.circle),
      child: stepBuilder?.call(index, index <= controller.index, index == controller.index) ??
          Text((index + 1).toString(), style: stepNumberStyle?.copyWith(color: stepIndexColor)),
    );

    final titleWidget = SizedBox(
      width: 0,
      height: 0,
      child: OverflowBox(
        fit: OverflowBoxFit.deferToChild,
        maxHeight: double.infinity,
        maxWidth: double.infinity,
        child: Container(
          alignment: Alignment.centerRight,
          margin: isVertical ? EdgeInsets.only(right: hroizatalPadding - gapBetweenStepAndTitle) : EdgeInsets.only(top: titlePaddingTop),
          child: SizedBox(
            width: isVertical ? hroizatalPadding : null,
            child: stepTitleBuilder?.call(index, index <= controller.index, index == controller.index) ??
                Text(
                  controller.stepsList != null ? controller.stepsList![index] : "",
                  maxLines: 1,
                  style: stepTitleStyle?.copyWith(color: index <= controller.index ? doneColor : unDoneColor),
                ),
          ),
        ),
      ),
    );

    final children = [stepWidget, if (controller.showTitles) titleWidget];

    if (isVertical) {
      return Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: children);
      //return Stack(clipBehavior: Clip.none, fit: StackFit.passthrough, alignment: Alignment.centerRight, children: children);
    } else {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: children);
    }
  }

  Widget _wdStepLine(int index, bool isVertical) {
    if (isVertical) {
      return SizedBox(
        height: stepHeight,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            stepLineWidget ??
                Container(
                  width: lineSize,
                  decoration: BoxDecoration(color: index < controller.index ? doneColor : unDoneColor, borderRadius: BorderRadius.circular(10)),
                ),
          ],
        ),
      );
    }
    if (stepWidth != null) {
      return SizedBox(
        width: stepWidth,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              stepLineWidget ??
                  Container(
                    height: lineSize,
                    decoration: BoxDecoration(color: index < controller.index ? doneColor : unDoneColor, borderRadius: BorderRadius.circular(10)),
                  ),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              stepLineWidget ??
                  Container(
                    height: lineSize,
                    decoration: BoxDecoration(color: index < controller.index ? doneColor : unDoneColor, borderRadius: BorderRadius.circular(10)),
                  ),
            ],
          ),
        ),
      );
    }
  }
}

/// A controller for [SimpleCheckoutStepper].
///
/// This controller manages the current step index and allows navigating
/// between steps using [next], [previous], and [reset].
class SimpleCheckoutStepperController extends ChangeNotifier {
  int _index = 0;

  /// number of steps
  final int steps;

  /// steps titles
  List<String>? stepsList;

  /// show titles
  final bool showTitles;

  /// create a new instance of CheckoutStepperController
  SimpleCheckoutStepperController({required this.steps, this.stepsList, this.showTitles = true})
      : assert(steps > 0, 'steps must be greater than 0'),
        assert(stepsList == null || stepsList.length == steps, 'steps title List length must be equal to the number of steps');

  /// current step index
  int get index => _index;

  /// move to next step
  void next() {
    if (_index < steps) {
      _index++;
      notifyListeners();
    }
  }

  /// move to previous step
  void previous() {
    if (_index > 0) {
      _index--;
      notifyListeners();
    }
  }

  /// reset step index to 0
  void reset() {
    _index = 0;
    notifyListeners();
  }
}

/// A enum for [SimpleCheckoutStepper].
///
/// This enum defines the direction of the stepper, vertical or horizontal.
/// if direction is vertical, [stepHeight] will be length or height of step that will be displayed vertically.
/// if direction is horizontal, [stepWidget] will be width of step that will be displayed horizontally.
enum SimpleCheckoutStepperDirection {
  /// vertical stepper, [hroizatalPadding] is only needed in vertical direction
  vertical,

  /// horizontal stepper
  horizontal,
}

typedef StepWidgetBuilder = Widget Function(int index, bool isDone, bool isActive);
