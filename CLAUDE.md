# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter authentication app using Supabase backend with Clean Architecture and BLoC pattern. Supports email/password, social login (Google, Apple, GitHub), magic link, and phone OTP authentication.

## Common Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run app
flutter test             # Run tests
flutter analyze          # Run static analysis
flutter clean            # Clean build artifacts
```

## Architecture

### Clean Architecture Layers

```
lib/
├── core/
│   ├── di/injection_container.dart    # get_it service locator setup
│   ├── error/                         # Exceptions and Failures for Either pattern
│   └── network/supabase/              # AuthClient abstraction over Supabase
└── features/auth/
    ├── data/                          # DataSources, Models, Repository implementations
    ├── domain/                        # Entities, Repository interfaces
    └── presentation/                  # BLoCs, Screens
```

### Data Flow

```
Screen → BLoC.add(Event) → Repository → DataSource → Supabase API
                ↓
Screen ← BlocBuilder(State) ← Repository returns Either<Failure, Success>
```

### BLoC Structure

Five separate BLoCs, each with its own events/states:
- **EmailAuthBloc**: signup, signin, password reset with OTP
- **SocialAuthBloc**: Google, Apple, GitHub login
- **PhoneAuthBloc**: OTP send/verify
- **SessionBloc**: auth state, signout, session checking
- **ProfileBloc**: profile updates, picture upload, account deletion

### Dependency Injection Pattern

```dart
final sl = GetIt.instance;  // Global service locator

// Registration order in injection_container.dart:
// 1. AuthClient (singleton) - wraps Supabase GoTrueClient
// 2. DataSources (lazy singletons) - depend on AuthClient
// 3. Repositories (lazy singletons) - depend on DataSources
// 4. BLoCs (factories) - new instance per screen

// Usage in screens:
BlocProvider(create: (context) => sl<EmailAuthBloc>())
```

### Error Handling Pattern

Uses `dartz` Either pattern. Repositories catch exceptions and return failures:

```dart
// In repository implementation:
try {
  final user = await _datasource.signUp(...);
  return Right(user);
} on AuthException catch (e) {
  return Left(AuthFailure(e.message));
}
```

Exception types: `AuthException`, `ServerException`, `ValidationException`, `NetworkException`, `CacheException`

## Key Files

- `lib/main.dart` - Supabase init with dotenv, app entry
- `lib/core/di/injection_container.dart` - All DI registration
- `lib/core/network/supabase/auth_client.dart` - Abstract auth interface
- `lib/features/auth/data/models/user_model.dart` - Supabase User → UserEntity conversion

## Environment Setup

Create `.env` from `.env.example`:
```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

## Linting

Uses `flutter_lints` with strict rules (see `analysis_options.yaml`):
- Enforce const constructors
- Require explicit return types
- Prefer single quotes
- Avoid print statements