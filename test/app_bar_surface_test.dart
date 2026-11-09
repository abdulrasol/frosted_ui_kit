import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('app bar title uses the shared translucent surface in '
        '${brightness.name} mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: const Scaffold(
            body: Column(
              children: [
                SizedBox(height: 80, child: FrostedAppBar(title: 'Preview')),
                Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        ),
      );

      final titleSurface = tester.widget<BlurredCard>(
        find.byType(BlurredCard).first,
      );
      expect(titleSurface.color, isNotNull);
      expect(titleSurface.color!.a, lessThan(0.5));
    });
  }
}
