import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
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

      await tester.drag(find.byType(ListView), const Offset(0, 10));
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
  });
}
