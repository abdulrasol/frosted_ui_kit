import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
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
