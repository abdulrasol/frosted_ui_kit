import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('destructive role survives appearances in ${brightness.name}', (
      tester,
    ) async {
      final scheme = ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: brightness,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: scheme, brightness: brightness),
          home: Scaffold(
            body: Column(
              children: [
                FrostedButton.destructive(
                  key: const Key('filled'),
                  label: 'Filled delete',
                  onPressed: () {},
                ),
                FrostedButton.destructive(
                  label: 'Glass delete',
                  style: AppButtonStyle.glass,
                  onPressed: () {},
                ),
                FrostedButton.destructive(
                  label: 'Outlined delete',
                  style: AppButtonStyle.outlined,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(_textColor(tester, 'Filled delete'), scheme.onError);
      expect(_textColor(tester, 'Glass delete'), scheme.error);
      expect(_textColor(tester, 'Outlined delete'), scheme.error);

      final filledMaterial = tester.widget<Material>(
        find.descendant(
          of: find.byKey(const Key('filled')),
          matching: find.byType(Material),
        ),
      );
      expect(filledMaterial.color, scheme.error);
    });
  }

  testWidgets('role tokens and local overrides follow documented precedence', (
    tester,
  ) async {
    const tokenAccent = Color(0xff7b1fa2);
    const tokenOnAccent = Color(0xfffff59d);
    const localForeground = Color(0xff00ffff);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const [
            FrostedThemeData(
              destructiveActionColor: tokenAccent,
              onDestructiveActionColor: tokenOnAccent,
            ),
          ],
        ),
        home: Scaffold(
          body: Column(
            children: [
              FrostedButton.destructive(label: 'Token', onPressed: () {}),
              FrostedButton.destructive(
                label: 'Local',
                foregroundColor: localForeground,
                onPressed: () {},
              ),
              const FrostedButton.destructive(
                label: 'Disabled',
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );

    expect(_textColor(tester, 'Token'), tokenOnAccent);
    expect(_textColor(tester, 'Local'), localForeground);
    expect(
      _textColor(tester, 'Disabled'),
      Theme.of(
        tester.element(find.text('Disabled')),
      ).colorScheme.onSurface.withValues(alpha: 0.38),
    );

    final inkWell = tester.widget<InkWell>(
      find.descendant(
        of: find.widgetWithText(FrostedButton, 'Token'),
        matching: find.byType(InkWell),
      ),
    );
    expect(
      inkWell.overlayColor?.resolve({WidgetState.focused}),
      tokenAccent.withValues(alpha: 0.16),
    );
  });

  testWidgets('icon buttons and FABs forward their semantic role', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              FrostedIconButton(
                icon: Icons.delete_outline,
                tooltip: 'Delete icon',
                role: FrostedActionRole.destructive,
                onPressed: () {},
              ),
              AppFloatingActionButton(
                title: 'Delete FAB',
                icon: Icons.delete_outline,
                role: FrostedActionRole.destructive,
                style: AppButtonStyle.outlined,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      tester.widget<CircleButton>(find.byType(CircleButton)).role,
      FrostedActionRole.destructive,
    );
    expect(
      tester.widget<AppButton>(find.byType(AppButton)).role,
      FrostedActionRole.destructive,
    );
  });
}

Color? _textColor(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label)).style?.color;
