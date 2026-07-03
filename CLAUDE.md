# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run in debug mode
flutter build apk        # Build Android APK
flutter analyze          # Static analysis
flutter test             # Run all tests
flutter test test/features/auth/presentation/providers/auth_provider_test.dart  # Single test file
```

Code generation (for mocks):
```bash
dart run build_runner build
```

## Architecture

Clean Architecture with Riverpod state management. Every feature under `lib/features/` follows this structure:

```
features/<feature>/
  data/
    datasources/    # HTTP calls via AppHttpClient
    models/         # JSON-serializable, extend domain entities
    repositories/   # Implementations returning Either<Failure, T>
  domain/
    entities/       # Pure Dart, no serialization
    repositories/   # Abstract interfaces
    usecases/       # Single-responsibility business logic
  presentation/
    pages/          # Screens
    providers/      # Riverpod providers + StateNotifiers
    widgets/        # Feature-specific widgets
```

**Data flow**: Page → Provider (StateNotifier) → UseCase → Repository → DataSource → HTTP

**Error handling**: All repository methods return `Either<Failure, T>` (dartz). The `safeRequest()` wrapper in `lib/core/network/app_http_client.dart` handles 401s by automatically logging out via `AppSession`.

**State management**: `AsyncValue<T>` from Riverpod is used for loading/error/data states in providers. Providers wire the full dependency chain (datasource → repository → usecase → notifier).

**Session**: JWT stored in `SharedPreferences` via `lib/core/utils/app_session.dart`. Decoded with `jwt_decoder`.

**Navigation**: Named routes defined in `lib/core/utils/app_routes.dart` with a global `navigatorKey`.

**Environment**: Base API URL loaded from `.env` file as `FLUTTER_HOST`. Firebase config is in `lib/firebase_options.dart` (auto-generated, project: `smartfarm-lele`).

## Testing Pattern

Tests use hand-written fake repositories (not Mockito mocks) that accept callback setups:

```dart
class FakeAuthRepository implements AuthRepository {
  Future<Either<Failure, Auth>> Function()? _loginCallback;
  void setupLogin(Future<Either<Failure, Auth>> Function() cb) => _loginCallback = cb;
  @override
  Future<Either<Failure, Auth>> login(...) => _loginCallback!();
}
```

Test files mirror the `lib/` structure under `test/features/`.

## Key Constraints

- `analysis_options.yaml` suppresses `use_build_context_synchronously` — async context usage is intentional in several places.
- Locale is fixed to `id_ID` (Indonesian). Date/number formatting uses `intl` with Indonesian locale throughout.
- The `.env` file must exist at the project root for the app to start (`flutter_dotenv` loads it in `main.dart`).
