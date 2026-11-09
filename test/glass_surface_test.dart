import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  Widget host(FrostedPerformanceData settings) => FrostedPerformance.fromData(
    data: settings,
    child: MaterialApp(
      home: Scaffold(
        body: BlurredCard(
          disableBlur: false,
          sigmaX: 8,
          sigmaY: 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleButton(icon: Icons.add, onPressed: () {}),
              AppButton(
                title: 'Save',
                style: AppButtonStyle.waterDrop,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ),
  );

  testWidgets('nested surfaces share ancestor blur and lite creates none', (
    tester,
  ) async {
    await tester.pumpWidget(host(FrostedPerformance.full));
    expect(find.byType(BackdropFilter), findsOneWidget);
    await tester.pumpWidget(host(FrostedPerformance.lite));
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
    await tester.pumpWidget(host(const FrostedPerformanceData(blurScale: 0)));
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets(
    'balanced scales sigma once and independent siblings stay independent',
    (tester) async {
      await tester.pumpWidget(host(FrostedPerformance.balanced));
      expect(
        tester
            .widget<BackdropFilter>(find.byType(BackdropFilter))
            .filter
            .toString(),
        contains('4.0'),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                CircleButton(icon: Icons.add, onPressed: () {}),
                CircleButton(icon: Icons.close, onPressed: () {}),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNWidgets(2));
    },
  );

  testWidgets('android preset skips backdrop filters', (tester) async {
    await tester.pumpWidget(
      FrostedPerformance.fromData(
        data: FrostedPerformance.android,
        child: MaterialApp(home: BlurredCard(child: const Text('android'))),
      ),
    );

    expect(find.byType(BackdropFilter), findsNothing);
    expect(find.text('android'), findsOneWidget);
  });
}
