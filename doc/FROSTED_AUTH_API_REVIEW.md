# Authentication API Review

## Current contract

The authentication module is generic at its domain boundary:

- `UserEntity` carries app-specific attributes through `customData`.
- `AuthRepository` is the application-facing contract.
- `AuthRemoteDataSource` is an injectable backend adapter.
- `AuthController` owns view state and can be supplied by the host app.
- `AuthScreen` and `AuthView` expose flow flags and button overrides.

The data models and mock data source remain exported for 1.x compatibility and
for package examples. Applications with a real backend should provide their
own `AuthRemoteDataSource` and `AuthRepository` implementation.

## Lifecycle correction

`AuthScreen` no longer creates a throwaway `AuthController` inside `build`.
When no controller is supplied, `AuthView` creates exactly one local controller
and disposes it with the view. When a controller is supplied, ownership stays
with the caller.

This prevents duplicate listeners, unnecessary allocations, and state updates
being sent to a controller different from the one rendering the forms.

## Remaining follow-up

The controller currently contains default English feedback messages for the
legacy standalone auth flow. A future major API can expose message builders or
localized callbacks without changing the repository contract. Existing strings
are retained for compatibility in the current release.
