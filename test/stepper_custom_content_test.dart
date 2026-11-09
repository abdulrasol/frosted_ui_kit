import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  testWidgets('step builder renders custom content and receives state', (
    tester,
  ) async {
    final controller = FrostedStepperController(
      steps: 3,
      stepsList: const ['Cart', 'Address', 'Review'],
      initialIndex: 1,
    );
    final states = <int, FrostedStepState>{};

    await tester.pumpWidget(
      MaterialApp(
        home: FrostedStepper(
          controller: controller,
          stepSize: 48,
          stepBuilder: (context, index, state) {
            states[index] = state;
            return Icon(Icons.check, key: ValueKey('step-icon-$index'));
          },
        ),
      ),
    );

    expect(find.byKey(const ValueKey('step-icon-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('step-icon-1')), findsOneWidget);
    expect(states[0], FrostedStepState.completed);
    expect(states[1], FrostedStepState.current);
    expect(states[2], FrostedStepState.upcoming);
    expect(
      tester.getSize(find.byKey(const ValueKey('step-icon-1'))).width,
      lessThan(48),
    );

    controller.dispose();
  });
}
