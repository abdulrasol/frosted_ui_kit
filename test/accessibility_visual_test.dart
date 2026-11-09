import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

class _Buttons with Buttons {}

void main() {
  testWidgets(
    'selected semantics, keyboard activation and disabled exclusion',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CircleButton(
                  icon: Icons.check,
                  selected: true,
                  semanticLabel: 'Select',
                  onPressed: () => calls++,
                ),
                const CircleButton(
                  icon: Icons.close,
                  semanticLabel: 'Unavailable',
                  onPressed: null,
                ),
              ],
            ),
          ),
        ),
      );
      final semantics = tester.getSemantics(find.bySemanticsLabel('Select'));
      expect(semantics.flagsCollection.isSelected, ui.Tristate.isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(calls, 1);
      await tester.tap(find.bySemanticsLabel('Unavailable'));
      expect(calls, 1);
    },
  );

  testWidgets('small icons keep 48px target and back follows RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  CircleButton(size: 24, icon: Icons.add, onPressed: () {}),
                  _Buttons().backButton(context, onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byType(CircleButton).first);
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
  });

  testWidgets('default FrostedAppBar mirrors its back icon in RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/details',
        routes: {
          '/': (_) => const SizedBox.shrink(),
          '/details': (_) => const Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Column(
                children: [
                  FrostedAppBar(title: 'Settings'),
                  Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),
          ),
        },
      ),
    );
    await tester.pumpAndSettle();

    // The logical icon remains chevron-left; Flutter mirrors its glyph once
    // under RTL, so the rendered arrow points to the right.
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
  });

  for (final brightness in Brightness.values) {
    testWidgets('approved surfaces ${brightness.name}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: RepaintBoundary(
            key: const ValueKey('preview'),
            child: Scaffold(
              body: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleButton(icon: Icons.favorite, onPressed: () {}),
                  AppButton(
                    title: 'Save',
                    style: AppButtonStyle.waterDrop,
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: AppDialog(child: Text('Confirm changes')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const ValueKey('preview')),
        matchesGoldenFile('goldens/surfaces_${brightness.name}.png'),
      );
    });
  }
}
