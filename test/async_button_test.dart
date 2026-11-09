import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

void main() {
  testWidgets('manages success and blocks rapid repeat activation', (
    tester,
  ) async {
    final completer = Completer<void>();
    var calls = 0;
    var successes = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FrostedAsyncButton(
            title: 'Save',
            feedbackDuration: const Duration(milliseconds: 100),
            onPressed: () {
              calls++;
              return completer.future;
            },
            onSuccess: () => successes++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppButton));
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(calls, 1);
    expect(find.byKey(const ValueKey('loading')), findsOneWidget);
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);

    completer.complete();
    await tester.pump();
    expect(successes, 1);
    expect(find.byKey(const ValueKey('success')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey('idle')), findsOneWidget);
  });

  testWidgets('captures errors and supports retry after feedback', (
    tester,
  ) async {
    var attempts = 0;
    Object? reportedError;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FrostedAsyncButton(
            title: 'Retry',
            feedbackDuration: const Duration(milliseconds: 10),
            onPressed: () async {
              attempts++;
              if (attempts == 1) throw StateError('rejected');
            },
            onError: (error, stackTrace) => reportedError = error,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(reportedError, isA<StateError>());
    expect(find.byKey(const ValueKey('error')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(milliseconds: 10));
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(attempts, 2);
    expect(find.byKey(const ValueKey('success')), findsOneWidget);
  });

  testWidgets('ignores late completion after unmount', (tester) async {
    final completer = Completer<void>();
    var callbacks = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FrostedAsyncButton(
            title: 'Save',
            onPressed: () => completer.future,
            onSuccess: () => callbacks++,
            onError: (error, stackTrace) => callbacks++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppButton));
    await tester.pumpWidget(const SizedBox());
    completer.complete();
    await tester.pump();

    expect(callbacks, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('null callback exposes a disabled button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FrostedAsyncButton(title: 'Unavailable', onPressed: null),
        ),
      ),
    );

    final semantics = tester.getSemantics(find.bySemanticsLabel('Unavailable'));
    expect(
      semantics.getSemanticsData().hasAction(SemanticsAction.tap),
      isFalse,
    );
    expect(semantics.flagsCollection.isEnabled, ui.Tristate.isFalse);
  });
}
