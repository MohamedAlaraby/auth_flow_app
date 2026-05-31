# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run the app
flutter test             # Run all tests
flutter test test/path/to/test.dart  # Run a single test file
flutter build apk --release          # Build Android release
flutter build ios --release          # Build iOS release
flutter clean            # Clean build artifacts
```

## Environment Setup

The app requires a `.env` file in the project root (loaded as a Flutter asset via `flutter_dotenv`):

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

`initDependencies()` in `injection_container.dart` must be called **before** `Supabase.initialize()` in `main()` — the DI container registers `Supabase.instance.client.auth` which is only available after init.

## Architecture

Clean Architecture with three layers inside `lib/features/auth/`:

- **domain/**: Pure Dart — `UserEntity` (Equatable), repository interfaces returning `Either<Failure, T>` via `dartz`
- **data/**: `UserModel` extends `UserEntity`, datasource interfaces + impls calling `AuthClient`, repository impls catching exceptions and mapping them to failures
- **presentation/**: BLoC per concern (`EmailAuthBloc`, `PhoneAuthBloc`, `SocialAuthBloc`, `SessionBloc`, `ProfileBloc`)

**Error flow**: datasource throws `AppException` subclass → repository impl catches and returns `Left(Failure)` → BLoC folds the Either and emits error state.

**AuthClient** (`core/network/supabase/`) is a thin abstract wrapper around `GoTrueClient`, injected into all datasource impls. This is the boundary between app code and Supabase SDK.

**DI**: `get_it` via `sl = GetIt.instance` in `injection_container.dart`. Datasources and repositories are `registerLazySingleton`; BLoCs are `registerFactory` (new instance per screen).

**Session management**: `SessionBloc` subscribes to `sessionRepository.authStateChanges` (a `Stream`) in its constructor and dispatches `AuthStateChangedEvent` on every emission. It also responds to `CheckAuthStatusEvent` on startup. `AuthWrapper` in `main.dart` uses `BlocBuilder<SessionBloc>` to decide the initial route.

## Datasource Split

The project splits auth concerns across five datasources (unlike the original single-datasource README):

| Datasource | Handles |
|---|---|
| `EmailAuthDataSource` | sign up, sign in, reset password, verify email, magic link |
| `SocialAuthDataSource` | Google, Apple, GitHub sign-in |
| `PhoneAuthDataSource` | phone OTP send/verify |
| `SessionDataSource` | getCurrentUser, signOut, authStateChanges stream |
| `ProfileDataSource` | profile read/update, avatar upload |

Many methods in the `*_impl.dart` files still throw `UnimplementedError` — this is intentional; they are completed lesson by lesson.

## Linting

Rules from `analysis_options.yaml` to keep in mind: `prefer_single_quotes`, `avoid_print`, `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_final_fields`, `prefer_final_locals`, `always_declare_return_types`.
