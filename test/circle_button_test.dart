import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  Widget host(Widget child) {
    return MaterialApp(
      theme: ThemeData(platform: TargetPlatform.iOS),
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('CircleButton', () {
    testWidgets('waterDrop uses a low-sigma liquid-glass blur', (tester) async {
      await tester.pumpWidget(
        host(
          const CircleButton(
            icon: Icons.water_drop,
            style: CircleButtonStyle.waterDrop,
            onPressed: null,
          ),
        ),
      );

      final blur = tester.widget<BackdropFilter>(find.byType(BackdropFilter));
      expect(blur.filter.toString(), contains('5.0'));
      expect(find.byType(AnimatedScale), findsOneWidget);
    });

    testWidgets('exposes tooltip and semantics label', (tester) async {
      await tester.pumpWidget(
        host(
          const CircleButton(
            icon: Icons.settings,
            tooltip: 'Settings',
            semanticLabel: 'Open settings',
            onPressed: null,
          ),
        ),
      );

      expect(find.byTooltip('Settings'), findsOneWidget);
      expect(find.bySemanticsLabel('Open settings'), findsOneWidget);
      final semantics = tester.getSemantics(
        find.bySemanticsLabel('Open settings'),
      );
      expect(semantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('disabled button is exposed as disabled', (tester) async {
      await tester.pumpWidget(
        host(
          const CircleButton(
            icon: Icons.lock,
            semanticLabel: 'Locked action',
            onPressed: null,
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CircleButton));
      expect(semantics.flagsCollection.isEnabled != ui.Tristate.none, isTrue);
      expect(
        semantics.flagsCollection.isEnabled == ui.Tristate.isTrue,
        isFalse,
      );
    });

    testWidgets('press animation scales the button', (tester) async {
      await tester.pumpWidget(
        host(const CircleButton(icon: Icons.add, onPressed: _noop)),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(CircleButton)),
      );
      await tester.pump(const Duration(milliseconds: 40));
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        lessThan(1),
      );
      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}

void _noop() {}
