import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

class _DialogHost with Dialogs {}

void main() {
  testWidgets('destructive dialog stacks safe and destructive actions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: AppButton(
              title: 'Open warning',
              onPressed: () => _DialogHost().showAppWarningDialog(
                context: context,
                title: 'Delete customer?',
                description: List.filled(
                  8,
                  'This action cannot be undone.',
                ).join(' '),
                confirmText: 'Delete permanently',
                cancelText: 'Keep customer',
                isDestructive: true,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open warning'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final dialogButtons = tester
        .widgetList<AppButton>(
          find.descendant(
            of: find.byType(AppDialog),
            matching: find.byType(AppButton),
          ),
        )
        .toList();
    expect(dialogButtons.map((button) => button.role), [
      FrostedActionRole.secondary,
      FrostedActionRole.destructive,
    ]);
    expect(
      tester.getTopLeft(find.text('Keep customer')).dy,
      lessThan(tester.getTopLeft(find.text('Delete permanently')).dy),
    );
  });

  testWidgets('bottom sheet keeps actions reachable above keyboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 700);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.8)),
          child: child!,
        ),
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomSheet(
              title: 'Edit a very long profile title',
              actions: FrostedAdaptiveActions(
                secondary: AppButton(
                  title: 'Cancel changes',
                  role: FrostedActionRole.secondary,
                  style: AppButtonStyle.outlined,
                  onPressed: () {},
                ),
                primary: AppButton(title: 'Save changes', onPressed: () {}),
              ),
              child: SizedBox(
                height: 500,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('Body end'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Save changes'));
    await tester.pumpAndSettle();
    final keyboardTop = 700 - 300;
    expect(
      tester.getBottomLeft(find.text('Save changes')).dy,
      lessThanOrEqualTo(keyboardTop),
    );
    await tester.ensureVisible(find.text('Body end'));
    await tester.pumpAndSettle();
    expect(find.text('Body end'), findsOneWidget);
  });

  testWidgets('sheet uses one blur in full mode and none in lite mode', (
    tester,
  ) async {
    Future<int> pump(FrostedPerformanceData data) async {
      await tester.pumpWidget(
        FrostedPerformance.fromData(
          data: data,
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: const Scaffold(
              body: AppBottomSheet(title: 'Settings', child: Text('Content')),
            ),
          ),
        ),
      );
      return find.byType(BackdropFilter).evaluate().length;
    }

    expect(await pump(FrostedPerformance.full), 1);
    expect(await pump(FrostedPerformance.lite), 0);
  });

  testWidgets('dialog defaults follow the package locale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: const [
          ...FrostedAppLocalizations.localizationsDelegates,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: FrostedAppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: AppButton(
              title: 'Open',
              onPressed: () => _DialogHost().showAppWarningDialog(
                context: context,
                title: 'تحذير',
                description: 'وصف',
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('تأكيد'), findsOneWidget);
    expect(find.text('إلغاء'), findsOneWidget);
  });
}
