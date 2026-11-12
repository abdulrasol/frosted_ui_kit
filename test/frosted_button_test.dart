import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  testWidgets('short API supports activation, loading and null callbacks', (
    tester,
  ) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              FrostedButton.primary(label: 'Save', onPressed: () => count++),
              const FrostedButton.secondary(label: 'Disabled', onPressed: null),
              FrostedButton.primary(
                label: 'Loading',
                isLoading: true,
                onPressed: () => count++,
              ),
              FrostedIconButton(
                icon: Icons.settings,
                tooltip: 'Settings',
                onPressed: () => count++,
              ),
              AppButton(title: 'Legacy', onPressed: () => count++),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Save'));
    await tester.tap(find.text('Disabled'));
    await tester.tap(find.byType(FrostedButton).at(2));
    await tester.tap(find.byTooltip('Settings'));
    await tester.tap(find.text('Legacy'));
    expect(count, 3);
    expect(find.bySemanticsLabel('Settings'), findsOneWidget);
  });
}
