import 'package:example_app/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('catalog searches and filters components', (tester) async {
    await tester.pumpWidget(const MySandboxApp());
    await tester.pumpAndSettle();

    expect(find.text('Component Library'), findsOneWidget);
    expect(find.text('Cards'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'dialogs');
    await tester.pumpAndSettle();

    expect(find.text('Dialogs'), findsOneWidget);
    expect(find.text('Cards'), findsNothing);
    expect(find.text('Buttons'), findsNothing);
  });

  testWidgets('catalog exposes compact preview and settings controls', (
    tester,
  ) async {
    await tester.pumpWidget(const MySandboxApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Compact preview').first);
    await tester.pumpAndSettle();
    expect(find.text('Compact preview'), findsOneWidget);

    await tester.tap(find.byTooltip('Catalog settings'));
    await tester.pumpAndSettle();
    expect(find.text('Catalog preview'), findsOneWidget);
    expect(find.text('Right-to-left layout'), findsOneWidget);
    expect(find.text('Large text'), findsOneWidget);
  });
}
