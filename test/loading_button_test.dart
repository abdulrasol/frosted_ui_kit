import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

class _Controller extends FrostLoadingButtonController {
  bool get attached => hasListeners;
}

void main() {
  testWidgets('blocks rapid repeats, preserves width and feedback colors', (
    tester,
  ) async {
    final controller = FrostLoadingButtonController();
    addTearDown(controller.dispose);
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FrostLoadingButton(
            controller: controller,
            title: 'Save',
            successColor: Colors.teal,
            errorColor: Colors.orange,
            onPressed: () {
              calls++;
              controller.start();
            },
          ),
        ),
      ),
    );
    final width = tester.getSize(find.byType(AppButton)).width;
    await tester.tap(find.byType(AppButton));
    await tester.tap(find.byType(AppButton));
    expect(calls, 1);
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.getSize(find.byType(AppButton)).width, width);
    for (final state in [
      FrostLoadingButtonState.success,
      FrostLoadingButtonState.error,
    ]) {
      controller.value = state;
      await tester.pump();
      expect(
        tester.widget<AppButton>(find.byType(AppButton)).backgroundColor,
        state == FrostLoadingButtonState.success ? Colors.teal : Colors.orange,
      );
      await tester.tap(find.byType(AppButton));
      expect(calls, 1);
    }
    controller.reset();
    await tester.pump();
    await tester.tap(find.byType(AppButton));
    expect(calls, 2);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('switches controller listeners and detaches on unmount', (
    tester,
  ) async {
    final first = _Controller();
    final second = _Controller();
    Widget host(FrostLoadingButtonController controller) => MaterialApp(
      home: Scaffold(
        body: FrostLoadingButton(
          controller: controller,
          title: 'Save',
          onPressed: () {},
        ),
      ),
    );
    await tester.pumpWidget(host(first));
    expect(first.attached, isTrue);
    await tester.pumpWidget(host(second));
    expect(first.attached, isFalse);
    expect(second.attached, isTrue);
    first.dispose();
    second.success();
    await tester.pump();
    expect(find.byKey(const ValueKey('success')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    expect(second.attached, isFalse);
    second.reset();
    second.dispose();
    expect(tester.takeException(), isNull);
  });
}
