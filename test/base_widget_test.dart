import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  testWidgets('status bar gradient darkens light content only', (tester) async {
    Future<List<Color>> pump(Brightness brightness) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            brightness: brightness,
            scaffoldBackgroundColor: brightness == Brightness.dark
                ? const Color(0xff12121a)
                : const Color(0xfffff8e1),
          ),
          home: const BaseWidget(isHideAppbar: true, child: SizedBox.expand()),
        ),
      );
      await tester.pumpAndSettle();
      final box = tester.widget<DecoratedBox>(
        find.byKey(const ValueKey('base-widget-status-bar-gradient')),
      );
      return (box.decoration as BoxDecoration).gradient!.colors;
    }

    final lightColors = await pump(Brightness.light);
    expect(lightColors.first.withValues(alpha: 1), Colors.black);
    expect(lightColors[1].withValues(alpha: 1), Colors.black);
    expect(lightColors.first.a, greaterThan(lightColors[1].a));
    expect(lightColors[1].a, greaterThan(0));
    expect(lightColors.last, Colors.transparent);

    final darkColors = await pump(Brightness.dark);
    expect(darkColors.first, const Color(0xff12121a).withValues(alpha: 0.92));
    expect(darkColors[1], const Color(0xff12121a).withValues(alpha: 0.52));
  });

  Widget buildScreen({bool hideAppBarOnScroll = false}) {
    return MaterialApp(
      home: BaseWidget(
        title: 'Scrollable screen',
        hideAppBarOnScroll: hideAppBarOnScroll,
        child: ListView.builder(
          itemCount: 40,
          itemBuilder: (context, index) =>
              SizedBox(height: 80, child: Text('Item $index')),
        ),
      ),
    );
  }

  testWidgets(
    'top bounce and direction notifications never flicker the header',
    (tester) async {
      late BuildContext scrollContext;
      await tester.pumpWidget(
        MaterialApp(
          home: BaseWidget(
            hideAppBarOnScroll: true,
            child: Builder(
              builder: (context) {
                scrollContext = context;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      );
      FixedScrollMetrics metrics(double pixels) => FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 1000,
        pixels: pixels,
        viewportDimension: 400,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 1,
      );
      double opacity() => tester
          .widget<AnimatedOpacity>(find.byType(AnimatedOpacity).first)
          .opacity;
      for (final position in [0.0, -10.0, -30.0, -5.0, 0.0, 3.0, 0.0]) {
        UserScrollNotification(
          metrics: metrics(position),
          context: scrollContext,
          direction: ScrollDirection.reverse,
        ).dispatch(scrollContext);
        ScrollUpdateNotification(
          metrics: metrics(position),
          context: scrollContext,
          scrollDelta: 30,
        ).dispatch(scrollContext);
        await tester.pump();
        expect(opacity(), 1);
      }
      // A direction alone is insufficient; actual in-range movement is required.
      UserScrollNotification(
        metrics: metrics(100),
        context: scrollContext,
        direction: ScrollDirection.reverse,
      ).dispatch(scrollContext);
      ScrollUpdateNotification(
        metrics: metrics(100),
        context: scrollContext,
        scrollDelta: 10,
      ).dispatch(scrollContext);
      await tester.pump();
      expect(opacity(), 1);
      ScrollUpdateNotification(
        metrics: metrics(110),
        context: scrollContext,
        scrollDelta: 10,
      ).dispatch(scrollContext);
      await tester.pump();
      expect(opacity(), 0);
      ScrollUpdateNotification(
        metrics: metrics(1005),
        context: scrollContext,
        scrollDelta: -40,
      ).dispatch(scrollContext);
      await tester.pump();
      expect(opacity(), 0);
      ScrollUpdateNotification(
        metrics: metrics(0),
        context: scrollContext,
        scrollDelta: -10,
      ).dispatch(scrollContext);
      await tester.pump();
      expect(opacity(), 1);
    },
  );

  group('BaseWidget app bar scroll behavior', () {
    testWidgets('keeps the app bar visible by default', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pump();

      final opacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).first,
      );
      expect(opacity.opacity, 1);
    });

    testWidgets('hides on downward scroll and shows on upward scroll', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen(hideAppBarOnScroll: true));

      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pump();
      final hiddenOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).first,
      );
      expect(hiddenOpacity.opacity, 0);

      await tester.drag(find.byType(ListView), const Offset(0, 50));
      await tester.pump();
      final visibleOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).first,
      );
      expect(visibleOpacity.opacity, 1);
    });

    testWidgets('collapses only the title when configured', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BaseWidget(
            title: 'Details',
            appBarScrollBehavior: AppBarScrollBehavior.collapseTitle,
            child: ListView.builder(
              itemCount: 40,
              itemBuilder: (context, index) =>
                  SizedBox(height: 80, child: Text('Item $index')),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pump();

      expect(find.byType(FrostedAppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
      final titleOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).last,
      );
      expect(titleOpacity.opacity, 0);
    });

    testWidgets('does not hide when scrolling at the top', (tester) async {
      await tester.pumpWidget(buildScreen(hideAppBarOnScroll: true));
      await tester.drag(find.byType(ListView), const Offset(0, 1));
      await tester.pump();

      final opacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).first,
      );
      expect(opacity.opacity, 1);
    });

    testWidgets('stays hidden when downward scrolling settles at the bottom', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen(hideAppBarOnScroll: true));

      await tester.fling(find.byType(ListView), const Offset(0, -4000), 6000);
      await tester.pumpAndSettle();

      final hiddenOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).first,
      );
      expect(hiddenOpacity.opacity, 0);

      await tester.drag(find.byType(ListView), const Offset(0, 50));
      await tester.pump();
      final visibleOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).first,
      );
      expect(visibleOpacity.opacity, 1);
    });
  });
}
