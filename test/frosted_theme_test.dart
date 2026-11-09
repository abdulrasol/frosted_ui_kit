import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  testWidgets(
    'tabs inputs navigation and sheets inherit component blur tokens',
    (tester) async {
      const tokens = FrostedThemeData(
        inputBlur: 2,
        tabsBlur: 3,
        sheetBlur: 4,
        navigationBlur: 6,
      );
      final controller = FrostedNavbarController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [tokens]),
          home: Scaffold(
            body: Column(
              children: [
                AppSlidingTabs(
                  tabs: const ['A', 'B'],
                  selectedIndex: 0,
                  onTabChanged: (_) {},
                ),
                const AppTextField(),
                FrostedNavigationButtomBar(
                  controller: controller,
                  items: const [FrostedNavbarItem(icon: Icons.home)],
                ),
                const Expanded(child: AppBottomSheet(child: Text('Sheet'))),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      final sigmas = tester
          .widgetList<BlurredCard>(find.byType(BlurredCard))
          .map((card) => card.sigmaX)
          .toSet();
      expect(sigmas, containsAll([2.0, 3.0, 4.0, 6.0]));
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [tokens]),
          home: Scaffold(
            body: AppSlidingTabs(
              tabs: const ['A'],
              selectedIndex: 0,
              sigmaX: 9,
              sigmaY: 9,
              onTabChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<BlurredCard>(find.byType(BlurredCard)).sigmaX, 9);
    },
  );
  test(
    'copyWith and interpolation preserve endpoints and interpolate tokens',
    () {
      const a = FrostedThemeData();
      final b = a.copyWith(
        buttonRadius: 32,
        glassBlur: 9,
        surfaceColor: Colors.blue,
        motionDuration: const Duration(milliseconds: 400),
      );
      expect(a.buttonRadius, 16);
      expect(b.dialogRadius, a.dialogRadius);
      expect(a.lerp(b, 0), same(a));
      expect(a.lerp(b, 1), same(b));
      expect(a.lerp(b, .5).buttonRadius, 24);
      expect(a.lerp(b, .5).motionDuration.inMilliseconds, 300);
      expect(a.lerp(null, .5), same(a));
    },
  );

  testWidgets('theme resolves centrally; local overrides and scope win', (
    tester,
  ) async {
    const tokens = FrostedThemeData(
      surfaceColor: Colors.teal,
      buttonRadius: 30,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [tokens]),
        home: Scaffold(
          body: Column(
            children: [
              AppButton(
                title: 'Themed',
                style: AppButtonStyle.colored,
                onPressed: () {},
              ),
              const BlurredCard(child: Text('Surface')),
              const BlurredCard(color: Colors.orange, child: Text('Local')),
            ],
          ),
        ),
      ),
    );
    final context = tester.element(find.text('Surface'));
    expect(FrostedThemeData.of(context), same(tokens));
    final surfaces = tester
        .widgetList<Container>(find.byType(Container))
        .map((w) => w.decoration)
        .whereType<BoxDecoration>()
        .toList();
    expect(surfaces.any((d) => d.color == Colors.teal), isTrue);
    expect(surfaces.any((d) => d.color == Colors.orange), isTrue);
    expect(
      surfaces.any((d) => d.borderRadius == BorderRadius.circular(30)),
      isTrue,
    );
    await tester.pumpWidget(
      MaterialApp(
        key: const ValueKey('defaults'),
        home: Builder(
          builder: (context) {
            expect(
              FrostedThemeData.of(context),
              same(FrostedThemeData.defaults),
            );
            return const SizedBox();
          },
        ),
      ),
    );
  });
}
