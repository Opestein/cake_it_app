# Waracle Tech Test – Notes

## Flutter Version

- Flutter 3.38.5 (stable)
- Dart 3.10.4

## Bugs Found & Fixed

- `dispose()` ordering — `super.dispose()` was called before child resources were disposed
- Hero tag mismatch — list view used `index`, detail view used `cake.uui`, causing broken animations
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