# Waracle Tech Test – Notes

## Flutter Version

- Flutter 3.38.5 (stable)
- Dart 3.10.4

## Bugs Found & Fixed

- `dispose()` ordering — `super.dispose()` was called before child resources were disposed
- Force-unwrap on nullable `image` field — would crash on null image URLs
- No loading or error states — the list showed nothing while data was loading or if it failed
- No image error handling — broken image URLs caused rendering errors

## What I Changed

- Removed `pull_to_refresh` third-party library; replaced with Flutter's built-in `RefreshIndicator`
- Extracted networking logic from the view into a separate data layer (`CakeApiClient` + `CakeRepository`)
- Improved the `Cake` model — non-nullable fields with safe defaults
- Added loading, error, and empty states to the cake list
- Added `errorBuilder` and `loadingBuilder` to `Image.network` on the detail view
- Replaced placeholder tests with real unit and widget tests
- Enabled Material 3 theming

## Architecture Update — BLoC & GoRouter

Introduced **flutter_bloc** for state management and **go_router** for declarative routing:

### State Management (flutter_bloc)
- `CakeListBloc` — handles cake fetching and pull-to-refresh; emits loading/success/failure states
- `SettingsCubit` — manages theme mode with `shared_preferences` persistence; replaces the previous `ChangeNotifier`-based `SettingsController`
- Views are now `StatelessWidget`s that use `BlocBuilder` for reactive UI

### Routing (go_router)
- Replaced `onGenerateRoute` with a declarative `GoRouter` configuration
- Three routes: cake list (`/`), cake detail (`/cake/:index`), settings (`/settings`)
- Cake detail receives its `Cake` object via GoRouter's `extra` parameter
- Route names centralised in `RouteNames` constants for clean navigation

### Environment Config
- Base URL configured via `String.fromEnvironment('BASE_URL')` — override with `--dart-define-from-file` at build time
- `AppConfig` provides a single source of truth for environment-specific values

### Local Storage
- Theme preference persisted locally using `shared_preferences`
- `SettingsService` reads/writes the `theme_mode` key

### Third-Party Packages Used
| Package | Purpose |
|---|---|
| `flutter_bloc` | BLoC pattern state management |
| `go_router` | Declarative routing |
| `equatable` | Value equality for BLoC states/events |
| `shared_preferences` | Persisting theme preference locally |
| `http` | HTTP client (unchanged) |
| `bloc_test` (dev) | BLoC testing utilities |
| `mocktail` (dev) | Mocking for tests |

### Test Coverage
- Cake model unit tests (unchanged)
- `CakeDetailsView` widget tests (updated import paths)
- `CakeListBloc` unit tests (new) — covers fetch success, fetch failure, refresh success, refresh failure