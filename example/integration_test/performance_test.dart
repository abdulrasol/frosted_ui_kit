import 'package:example_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const preset = String.fromEnvironment(
    'FROSTED_PERFORMANCE',
    defaultValue: 'balanced',
  );

  testWidgets('catalog scroll performance baseline', (tester) async {
    await tester.pumpWidget(MySandboxApp(performancePreset: preset));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await binding.watchPerformance(() async {
      final list = find.byType(ListView).first;
      for (var index = 0; index < 8; index++) {
        await tester.drag(list, const Offset(0, -420));
        await tester.pump(const Duration(milliseconds: 250));
        await tester.drag(list, const Offset(0, 420));
        await tester.pump(const Duration(milliseconds: 250));
      }
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }, reportKey: 'catalog_scroll');
  });
}
