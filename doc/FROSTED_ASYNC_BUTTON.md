# FrostedAsyncButton

`FrostedAsyncButton` is the beginner-friendly API for a button that starts a
`Future`. It owns loading, success, error, repeat-tap prevention, feedback
timing, and mounted checks. No controller or `setState` is required.

## Basic usage

```dart
FrostedAsyncButton(
  title: appStrings.save,
  icon: Icons.save_outlined,
  onPressed: () async => repository.save(),
  onSuccess: showSavedMessage,
  onError: (error, stackTrace) => logger.record(error, stackTrace),
)
```

The application supplies localized `title`, `loadingLabel`, `successLabel`,
and `errorLabel` values when the defaults do not match its language.

## State lifecycle

1. The idle button accepts one activation.
2. Its state changes to loading synchronously, before awaiting the callback.
   A second pointer, keyboard, or semantics activation is rejected.
3. A completed Future shows success; a thrown error shows error and is passed
   to `onError` with its stack trace.
4. The button returns to idle after `feedbackDuration`, which defaults to 1.2
   seconds. Set it to `null` to retain the terminal state while the widget
   remains mounted.

The widget never opens a Dialog, SnackBar, or retry UI automatically. Those
decisions remain in application code.

## Lifecycle and late results

Disposing the widget cancels its feedback timer and invalidates the active
operation generation. The application Future itself is not canceled because a
generic Dart Future has no cancellation contract. When that Future completes
after unmount, the result is consumed without `setState`, controller updates,
or success/error callbacks.

For cancellable network work, cancellation remains the responsibility of the
repository or request client. Pass its cancellation signal through the
application callback.

## Appearance and role

`style` controls appearance and `role` controls semantic colors, matching
`AppButton`. A destructive asynchronous action can therefore use a glass
surface without losing its error color family:

```dart
FrostedAsyncButton(
  title: appStrings.deleteAccount,
  role: FrostedActionRole.destructive,
  style: AppButtonStyle.glass,
  onPressed: accountRepository.delete,
)
```

## Choosing the correct API

| Need | API |
| --- | --- |
| Run one Future and show automatic feedback | `FrostedAsyncButton` |
| Application code drives every state manually | `FrostLoadingButton` |
| Normal synchronous action | `FrostedButton` or `AppButton` |

`FrostLoadingButtonController` remains supported and is not deprecated.

## Verification

Widget tests cover synchronous repeat blocking, success and automatic reset,
captured errors and retry, disabled semantics, and completion after unmount.
The full package test suite and `flutter analyze` must pass before release.
