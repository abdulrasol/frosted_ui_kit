import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  testWidgets('all glass surfaces honor explicit modes on Android and iOS', (
    tester,
  ) async {
    final navbar = FrostedNavbarController();
    final loading = FrostLoadingButtonController();
    addTearDown(navbar.dispose);
    addTearDown(loading.dispose);
    final surfaces = <Widget>[
      const BlurredCard(child: Text('Card')),
      const FrostedAppBar(title: 'Title'),
      AppButton(title: 'Glass', onPressed: () {}),
      AppButton(
        title: 'Drop',
        style: AppButtonStyle.waterDrop,
        onPressed: () {},
      ),
      CircleButton(icon: Icons.add, onPressed: () {}),
      CircleButton(
        icon: Icons.add,
        style: CircleButtonStyle.glass,
        onPressed: () {},
      ),
      const AppTextField(),
      AppSlidingTabs(
        tabs: const ['One', 'Two'],
        selectedIndex: 0,
        onTabChanged: (_) {},
      ),
      const FrostedListSection(
        children: [FrostedListTile(title: Text('Tile'))],
      ),
      FrostedNavigationButtomBar(
        controller: navbar,
        items: const [FrostedNavbarItem(icon: Icons.home)],
      ),
      const AppBottomSheet(child: Text('Sheet')),
      const AppDialog(child: Text('Dialog')),
      FrostLoadingButton(
        controller: loading,
        title: 'Load',
        style: AppButtonStyle.glass,
        onPressed: () {},
      ),
      AppFloatingActionButton(icon: Icons.add, onPressed: () {}),
    ];
    for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
      for (final surface in surfaces) {
        String? fullFilter;
        for (final mode in [
          FrostedPerformance.full,
          FrostedPerformance.balanced,
          FrostedPerformance.lite,
        ]) {
          await tester.pumpWidget(
            FrostedPerformance.fromData(
              data: mode,
              child: MaterialApp(
                theme: ThemeData(platform: platform),
                home: Scaffold(body: Center(child: surface)),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final filters = tester.widgetList<BackdropFilter>(
            find.byType(BackdropFilter),
          );
          if (mode == FrostedPerformance.lite) {
            expect(
              filters,
              isEmpty,
              reason: '$platform ${surface.runtimeType} lite',
            );
          } else {
            expect(
              filters,
              isNotEmpty,
              reason: '$platform ${surface.runtimeType} enabled',
            );
            final filter = filters.first.filter.toString();
            if (mode == FrostedPerformance.full) {
              fullFilter = filter;
            } else {
              expect(
                filter,
                isNot(fullFilter),
                reason: 'Balanced scales ${surface.runtimeType}',
              );
            }
          }
        }
      }
    }
  });

  testWidgets(
    'local performance scope is captured by dialog and sheet routes',
    (tester) async {
      for (final mode in [FrostedPerformance.full, FrostedPerformance.lite]) {
        late BuildContext launchContext;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: FrostedPerformance.fromData(
              data: mode,
              child: Builder(
                builder: (context) {
                  launchContext = context;
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
        showDialog<void>(
          context: launchContext,
          builder: (_) => const AppDialog(child: Text('Dialog')),
        );
        await tester.pumpAndSettle();
        expect(
          find.byType(BackdropFilter),
          mode.blurEnabled ? findsOneWidget : findsNothing,
        );
        Navigator.of(launchContext).pop();
        await tester.pumpAndSettle();
        showModalBottomSheet<void>(
          context: launchContext,
          builder: (_) => const AppBottomSheet(child: Text('Sheet')),
        );
        await tester.pumpAndSettle();
        expect(
          find.byType(BackdropFilter),
          mode.blurEnabled ? findsOneWidget : findsNothing,
        );
        Navigator.of(launchContext).pop();
        await tester.pumpAndSettle();
      }
    },
  );
}
