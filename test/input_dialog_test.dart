import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

class _Dialogs with Dialogs {}

void main() {
  testWidgets('Done validates before returning input; Cancel returns null', (
    tester,
  ) async {
    String? result;
    var completions = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await _Dialogs().showAppInputDialog(
                    context: context,
                    title: 'Rename',
                    autofocus: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  );
                  completions++;
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsOneWidget);
    expect(completions, 0);
    await tester.enterText(find.byType(EditableText), 'Project');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(result, 'Project');
    expect(completions, 1);
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isNull);
    expect(completions, 2);
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(result, isNull);
    expect(completions, 3);
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), 'Confirmed');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(result, 'Confirmed');
    expect(completions, 4);
  });
}
