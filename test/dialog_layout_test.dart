import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  testWidgets('RTL large text footer survives keyboard and rotation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 850);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        ),
        home: AppDialog(
          actions: const Text('Confirm footer'),
          child: Text(List.filled(30, 'وصف طويل لاختبار التمرير').join(' ')),
        ),
      ),
    );
    for (final scenario in [
      (const Size(430, 850), 350.0),
      (const Size(850, 430), 240.0),
      (const Size(430, 850), 0.0),
    ]) {
      tester.view.physicalSize = scenario.$1;
      tester.view.viewInsets = FakeViewPadding(bottom: scenario.$2);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Confirm footer'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final footer = tester.getRect(find.text('Confirm footer'));
      expect(footer.top, greaterThanOrEqualTo(0));
      expect(
        footer.bottom,
        lessThanOrEqualTo(scenario.$1.height - scenario.$2),
      );
    }
  });
  testWidgets('dialog remains scrollable when keyboard leaves little space', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(600, 400);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: AppDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 300, child: Text('Long content')),
              Text('Confirm action'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Confirm action'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getBottomLeft(find.text('Confirm action')).dy, lessThan(150));
  });
}
